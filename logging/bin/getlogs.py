#! /usr/bin/python3 

# Copyright Â© 2023, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

import time, calendar
import argparse
from opensearchpy import OpenSearch
import os, sys
import json, csv
import tempfile

##v 0.2.0

def validate_input(dict):
    ## Validate the arguments passed by the user to ensure script will function properly

    ## Ensure maxrows is less than 10000
    MAX_ROWS = 10000
    if dict['maxInt'] > MAX_ROWS:
        print("Error: Maxrows limit of 10000 exceeded.")
        exit()

    ##Check for existence of Connection Settings in input dictionary
    if(not dict['userName'] or not dict['password'] or not dict['host'] or not dict['port']):
        print('\nError: Missing required connection settings. Please specify username, password, host, and port. \n Default values can be manually exported as environment variables ESHOST, ESPORT, ESUSER, ESPASSWD')
        print("Username:", dict['userName'], " Password:", dict['password'], " Host:", dict['host'], " Port:", dict['port'])
        exit()

    if dict['out-filename']: ##Check for supported file-types and existence of file

        if(type(dict['out-filename']) == list):
            dict['out-filename']= " ".join(dict['out-filename'])

        dict['out-filename'] = dict['out-filename'] + "." + dict['format'] ## Add format to file

        if os.path.isfile(dict['out-filename']): ##Check if file already exists
            if (dict['force'] == False):
                print("\nUser specified output file already exists. Use -f to overwrite the file.\n")
                exit()
        
        safe_dir = os.getcwd() ## Check for path traversal attack
        if os.path.commonprefix((os.path.realpath(dict['out-filename']),safe_dir)) != safe_dir:
            print("Error: Path traversal in out-filename not allowed.")
            exit()

        try:
            x = open(args['out-filename'], 'w')    
        except FileNotFoundError as e:
            print("Error: Output file path not found. Please verify output file path. ")
            exit()

    if dict['savequery']: ##Find saved query path location     
        if(type(dict['savequery']) == list):
            dict['savequery']= " ".join(dict['savequery'])
        if (dict['savequery'].find('.') == -1):
            dict['savequery'] = dict['savequery'] + ".json"
        if ((not ".json" in dict['savequery'])):
            print('Error: Not a supported filetype for the saved query file. Supported type is .json')
            exit()

    if dict['query-filename']: ##Use for plugging in queries
        safe_dir = os.getcwd() ## Check for path traversal attack
        if os.path.commonprefix((os.path.realpath(dict['query-filename']),safe_dir)) != safe_dir:
            print("Error: Path traversal in query-filename not allowed.")
            exit()

        if (not os.path.isfile(dict['query-filename'])):
            print("Error: Invalid query file path.")
            exit()
 
    ##Time Validator - Verifies input, and converts it to UTC   
    if (type(dict['dateTimeStart']) ==list):
        dict['dateTimeStart'] = " ".join(dict['dateTimeStart'])
    if (type(dict['dateTimeEnd']) == list):
        dict['dateTimeEnd'] = " ".join(dict['dateTimeEnd'])
    try:
        dict['dateTimeStart'] = (time.strptime(dict.get('dateTimeStart'), "%Y-%m-%d %H:%M:%S"))
        dict['dateTimeEnd'] = (time.strptime(dict.get('dateTimeEnd'), "%Y-%m-%d %H:%M:%S"))
        if (calendar.timegm(dict['dateTimeStart']) > calendar.timegm(dict['dateTimeEnd'])):
            print("Given start date is after the end date.")
            exit()
        else:
            dict['dateTimeStart'] = time.strftime("%Y-%m-%dT%H:%M:%S", time.gmtime(time.mktime(dict['dateTimeStart'])))
            dict['dateTimeEnd'] = time.strftime("%Y-%m-%dT%H:%M:%S", time.gmtime(time.mktime(dict['dateTimeEnd'])))
    except ValueError:
        print("One or more date(s) have been formatted incorrectly. Correct format is Y-M-D H:M:S. Ex: 1999-02-16 10:00:00")  
        exit()

    if (dict['message']): ## Argument formatting for query builder
        if(type(dict['message']) == list):
            dict['message']= " ".join(dict['message'])
        if (dict['message'].find("'") > -1): ##Check for invalid single quotes
            print("Please remove single quotes ('') from search argument.")
            exit()

def build_query(dict): ##Generates Query using Opensearch DSL
    ##Takes arguments from user and builds a query to pass to opensearch client
    tfile = tempfile.NamedTemporaryFile(delete = False)  ##If User has not specified query file, create temp file for one.
    temp = open(tfile.name, 'w')
    first = True 
    argcounter=0    ##Counts unique options entered by user, sets min_match to this number
    if (not dict['query-filename']):   
        temp.write('{"size": ' + str(dict['maxInt']) + ',"sort": [{"@timestamp": {"order": "desc","unmapped_type": "boolean"} }]')     ## Establish size of query, remove scoring
        temp.write(', "query": {"bool": {"must":[ {"range": {"@timestamp": {"gte": "' + dict['dateTimeStart'] + '","lt": "' + dict['dateTimeEnd'] + '"} } }], ')   ##Establish Query with Time Range Requirements
        temp.write('"should": [ ')     ## Should Clause, search results must inlcude at least one of each specified option
        for arg in dict.keys():
            if (("kube" in arg or "level" in arg or "mes" in arg or "log" in arg) and (dict[arg]) and arg.find('-ex')==-1): ##Looking for non-exclusion options that are not NoneType in args dictionary
                argcounter+=1
                if (first == True):
                    first = False  
                else:
                    temp.write(',')       
                if arg!='message':
                    for i in range(len(dict[arg])):
                        temp.write('{"match_phrase": { "' + arg + '":"' + dict[arg][i] + '" } }')
                        if(i != len(dict[arg])-1):
                            temp.write(',')
                else:
                    temp.write('{"match_phrase": { "message":"' + ("".join(dict[arg])) + '"} }')
        first = True
        temp.write('], "minimum_should_match": ' + str(argcounter))
        for arg in dict.keys(): ##Must Not Clause, only added if specified by user
            if (("kube" in arg or "level" in arg or "log" in arg) and dict[arg] and arg.find('-ex')>-1):
                name = arg[0:arg.find('-')]
                if (first == True):
                    temp.write(', "must_not": [')
                    first = False
                else:
                    temp.write(',')
                for i in range(len(dict[arg])):
                    temp.write('{"match_phrase": {"' + name + '":"' + dict[arg][i] + '"} }')
                    if i != len(dict[arg])-1:
                        temp.write(',')
        if (first==False):
            temp.write(']')
        temp.write('} },')
        temp.write(' "fields": [') ## Add fields param
        for i in range(len(dict['fields'])):
            if i < len(dict['fields']) - 1:
                temp.write('"' + dict['fields'][i] + '",' )
            else:
               temp.write('"' + dict['fields'][i] + '"],' )
        temp.write('"_source": {"excludes": [] } }')
        temp.close()
       
        temp = open(tfile.name, 'r')
        query =  " ".join([line.strip() for line in temp])
        temp.close()

    else: ##Open existing query
        x = open(dict['query-filename'], 'rt')
        query =  " ".join([line.strip() for line in x]) ## Turn file into string, return.
        x.close()
    
    return query

##List of VALID arguments that are read from user as soon as program is run, nargs=+ indicates that argument takes multiple whitespace separated values. 
def get_arguments():
    ###Defines the arguments a user can pass and parses them, includes help msgs
    parser = argparse.ArgumentParser(prog='getLogs.py', usage='\n%(prog)s [options]', description="""This program generates OpenSearch DSL Queries from user specified parameters, and submits them to a database to retrieve logs. The flags below provide specifications for your Query, and can be placed in any order. \n
    \033[1m NOTES: *All default values for username, password, host, and port, are derived from the ENV variables ESUSER, USPASSWD, ESHOST, ESPORT in that respective order. '\033[0m' \n
    \033[1m If you have default connections set in your environment variables, you can call this program without arguments and get the latest 10 logs from the target API in the default CSV format.  \033[0m \n
    Getlogs has a default set of fields that runs with every query (seen below). You can replace the default fields with your own space-separated set of fields using --fields. Ex: --fields kube.labels.sas_com/deployment properties.appname \n
    *The NAMESPACE*, POD*, CONTAINER*, LOGSOURCE* and LEVEL* options accept multiple, space-separated, values (e.g. --level INFO NONE). Please refrain from passing single quotes ('') into arguments. \n  
    *All Generated files are placed in the current working directory. 
    Don't include https:\\ in the HOST connection setting \n\n\n \t\t\t\t QUERY SEARCH PARAMETERS: \n\n""", formatter_class=argparse.RawTextHelpFormatter)
    
    ##Search Params
    parser.add_argument('-n', '--namespace', required=False, dest="kube.namespace", nargs='*', metavar="NAMESPACE", help="\nOne or more Viya deployments/Kubernetes Namespace for which logs are sought\n\n")
    parser.add_argument('-nx', '--namespace-exclude', required=False, dest="kube.namespace-ex", nargs='*', metavar="NAMESPACE", help='\nOne or more namespaces for which logs should be excluded from the output\n\n')
    parser.add_argument('-p', '--pod', required=False, dest="kube.pod", nargs='*', metavar="POD", help='\nOne or more pods for which logs are sought\n\n')
    parser.add_argument('-px', '--pod-exclude', required=False, dest="kube.pod-ex", nargs='*', metavar="POD",  help='\nOne or more pods for which logs should be excluded from the output\n\n')
    parser.add_argument('-c', '--container', required=False, dest="kube.container", nargs='*', metavar="CONTAINER",  help = "\nOne or more containers for which logs are sought\n\n")
    parser.add_argument('-cx', '--container-exclude', required=False, dest="kube.container-ex", nargs='*', metavar="CONTAINER",  help = "\nOne or more containers from which logs should be excluded from the output\n\n")
    parser.add_argument('-s', '--logsource', required=False, dest="logsource", nargs='*', metavar="LOGSOURCE",  help = "\nOne or more logsource for which logs are sought\n\n")
    parser.add_argument('-sx', '--logsource-exclude', required=False, dest="logsource-ex",nargs='*', metavar="LOGSOURCE",  help = "\nOne or more logsource for which logs should be excluded from the output\n\n")
    parser.add_argument('-l', '--level', required=False, dest='level', nargs='*', metavar="LEVEL",  help = "\nOne or more message levels for which logs are sought\n\n")
    parser.add_argument('-lx', '--level-exclude', required=False, dest = 'level-exclude', nargs='*', metavar="LEVEL", help = "\nOne or more message levels for which logs should be excluded from the output.\n\n")
    parser.add_argument('-se', '--search', required=False, dest= "message", nargs='*', metavar="MESSAGE",  help = "\nWord or phrase contained in log message. Do not include single quotes ('')\n\n\n \t\t\t QUERY OUTPUT SETTINGS: \n\n")

    ##Query and Output Params
    parser.add_argument('-m', '--maxrows', required=False, dest ="maxInt", type=int, metavar="INTEGER", default=10,  help = "\nThe maximum number of log messsages to return. Max possible rows is 10000\n\n")
    parser.add_argument('-q', '--query-file ', required=False, dest="query-filename", metavar="FILENAME.*", help = "\n Filepath of existing saved query in current working directory. Program will submit query from file, ALL other query parmeters ignored. Supported filetypes: .txt, .json\n\n")
    parser.add_argument('-sh', '--show-query', required=False, dest="showquery", action= "store_true", help = "\n Displays the actual query that will be submitted during execution.\n\n")
    parser.add_argument('-sq', '--save-query', required=False, dest="savequery",  nargs='*', metavar="FILENAME", help = "\n Specify a file name (without filetype) in which to save the generated query. Query is saved as JSON file in current working directory.\n\n")
    parser.add_argument('-o', '--out-file', required=False, dest="out-filename",  nargs='*', metavar="FILENAME", help = "\nName of file to write results to. Filetype is specified using -format. Supported filetypes: .csv, .json\n\n")
    parser.add_argument('-fo','--format',  required=False, dest="format", default = "csv", help = "\n Formats results into the specified file (from --out-file). If no output file is provided, results will be outputted to STDOUT. Supported formats for console output are json and csv. \n\n")
    parser.add_argument('-f','--force',  required=False, dest="force", action= "store_true", help = "\n If this option is provided, the output results file from --out-file will be overwritten if it already exists.\n\n")
    parser.add_argument('-fi','--fields',  required=False, dest="fields", nargs="*", metavar= "FIELDS", default=['@timestamp', 'level', 'kube.pod', 'message'], help = "\n Specify desired output columns from query. If a matching log is returned that does not have the specified field, a NULL value will be used as a placeholder. \n Default fields: @timestamp level kube.pod message \n Additional arguments: kube.host, properties.appname \n\n")
    parser.add_argument('-st', '--start', required=False, dest="dateTimeStart", nargs='*', metavar="DATETIME",  default = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(time.mktime(time.localtime()) - 3600)), help = "\nDatetime for start of period for which logs are sought (default: 1 hour ago). Correct format is Y-M-D H:M:S. Ex: 2023-02-16 10:00:00\n\n")
    parser.add_argument('-en', '--end', required=False, dest="dateTimeEnd",nargs='*', metavar="DATETIME",  default = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime()), help = "\nDatetime for end of period for which logs are sought (default: now). \n\n\n \t\t\t CONNECTION SETTINGS: \n\n")
    
    parser.add_argument('-i', '--index', required=False, dest="index", metavar="INDEX", default="viya_logs-*") ## help = "\nDetermine which index to perform the search in. Default: viya-logs-*\n\n
    ##Connection settings
    parser.add_argument('-us','--user',  required=False, dest="userName", default=os.environ.get("ESUSER"), help = "\nUsername for connecting to OpenSearch/Kibana (default: $ESUSER)\n\n")
    parser.add_argument('-pw', '--password', required=False,  dest="password", default=os.environ.get("ESPASSWD"), help = "\nPassword for connecting to OpenSearch/Kibana  (default: $ESPASSWD)\n\n")
    parser.add_argument('-ho', '--host', required=False,  dest="host", default=os.environ.get("ESHOST"), help = "\nHostname for connection to OpenSearch/Kibana (default: $ESHOST)\n\n")
    parser.add_argument('-po', '--port', required=False,  dest="port", default=os.environ.get("ESPORT"), help = "\nPort number for connection to OpenSearch/Kibana (default: $ESPORT)\n\n")
    parser.add_argument('-nossl', '--disable-ssl', required=False, dest = "ssl", action= "store_false", help = "\n If this option is provided, SSL will not be used to connect to the database.\n\n")
    return parser.parse_args().__dict__

args = get_arguments() ##Creates "args" dictionary that contains all user submitted options. Print "args" to debug values. Note that the 'dest' value for each argument in argparser object is its key.
validate_input(args)

# Establish Client Using User Authorization and Connection Settings
auth = (args['userName'], args['password'])
client = OpenSearch(
    hosts = [{'host': args['host'], 'port': args['port']}],
    http_compress = True, # enables gzip compression for request bodies
    http_auth = auth,
    # client_cert = client_cert_path,
    # client_key = client_key_path,
    timeout = 90,
    use_ssl = args['ssl'],
    verify_certs = False,
    ssl_assert_hostname = False,
    ssl_show_warn = False
)

##Build Query Using Arguments
x = build_query(args)
index_name = args['index']

if (args['showquery'] == True): ##Print Query if user asks. 
    print("The following query will be submitted:\n\n", json.dumps(eval(x), indent=2))

if(args['savequery']): ##Save Query if user asks.
    y = open(args['savequery'], 'w')  
    with y as outfile:
        json.dump(eval(x), outfile, indent=2)   

    print("\nQuery saved to " + args['savequery'])
    
print('\nSearching index: ')
try:
    response = client.search(body=x, index=index_name)
except Exception as e: 
    print(e)
    if ("getaddrinfo" in str(e)):
        print("Connection Failed. Please verify the host and port values. ")
        print("Username:", args['userName'], " Password:", args['password'], " Host:", args['host'], " Port:", args['port'])
    elif("Unauthorized" in str(e)):
        print("User Authentication failed. Please verify username and password values.")
        print("Username:", args['userName'], " Password:", args['password'], " Host:", args['host'], " Port:", args['port'])
    else:
        print("Connection error. Please verify connection values. ")
        print("Username:", args['userName'], " Password:", args['password'], " Host:", args['host'], " Port:", args['port']) 
    exit()

if response['hits']['total']['value'] == 0:
    print("No results found for submitted query.")
    exit()

stdout = False
if (not args['out-filename']):
    stdout = True
else:
    x = open(args['out-filename'], 'w')

hitsList = [] ##Check to see if any fields matched user provided fields, collect matching fields
for hit in response['hits']['hits']:
    try:
        hit['fields']['id'] = hit['_id']
        hitsList.append(hit['fields'])
    except KeyError as e:
        next

for fieldDict in hitsList:
    for field in args['fields']:
        if not field in fieldDict.keys(): ##replaces empty fields with NULL values
            fieldDict[field] = "NULL"
        elif type(fieldDict[field]) == list: ##Converts lists into strings for proper output
            fieldDict[field] = ''.join(fieldDict[field])

if (len(hitsList) == 0):
    print("Error: No fields matched provided fieldnames. Please verify the field on opensearch-dashboards.\n")
    exit()

##Output as proper filetype
if("json" in args['format']): ##JSON formatter, uses json.dump to print to stdout or file
    if (not stdout):
        with x as outfile:
            json.dump(hitsList, outfile, sort_keys=True, indent=2)
        print("Search complete. Results printed to " + args['out-filename'])
    else:
        print("Search complete.")
        sys.stdout.write(json.dumps(hitsList, sort_keys=True, indent=2))

elif("csv" in args['format']): ##CSV writer implemented using dictwriter
    args['fields'].append("id")

    if (not stdout):
        with x as csvfile:
            header = args['fields']
            writer = csv.DictWriter(csvfile, fieldnames = header)
            writer.writeheader()
            for fieldDict in hitsList:
                writer.writerow(fieldDict)
            print("Search complete. Results printed to " + args['out-filename'])   
    else:
        print("Search complete")
        with sys.stdout as csvfile:
            header = args['fields']
            writer = csv.DictWriter(csvfile, fieldnames = header)
            writer.writeheader()
            for fieldDict in hitsList:
                writer.writerow(fieldDict)
                print("\n")
