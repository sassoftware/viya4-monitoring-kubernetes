#! /usr/bin/python3 

# Copyright Â© 2023, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

import time, calendar
import argparse
from opensearchpy import OpenSearch
import os, sys
import json, csv

## Cleanup temp file if not previously deleted, Create target directory
DEFAULT_DIR = "GetLogsFiles"
if not os.path.isdir(DEFAULT_DIR):
    os.mkdir(DEFAULT_DIR)

if os.path.isfile(DEFAULT_DIR + "/temp_SAS_OSQ.TXT"):
    os.remove(DEFAULT_DIR + "/temp_SAS_OSQ.TXT")

def validate_input(dict):
    """Validate the arguments passed by the user to ensure script will function properly"""
    
    if(len(sys.argv) == 1): ##Check if any args have been provided
        print("No arguments have been provided")
        exit()

    if dict['create-auth']:
        if (type(dict['create-auth'] == list)):
            dict['create-auth'] = " ".join(dict['create-auth'])
        if (not (DEFAULT_DIR + "/") in  dict['create-auth']):
            dict['create-auth'] = os.path.join(DEFAULT_DIR, dict['create-auth'])
        x = open(dict['create-auth'], "w")
        x.write('{"username": " " , "password": " " , "host": " ", "port": " "}')
        print("\nAuth File created.\n")

    if dict['auth-file']:
        if (type(dict['auth-file'] == list)):
            dict['auth-file'] = " ".join(dict['auth-file'])
        if (not (DEFAULT_DIR + "/") in  dict['auth-file']):
            dict['auth-file'] = os.path.join(DEFAULT_DIR,  dict['auth-file'])
        try: 
            a = open(dict['auth-file'], 'r')
            authDict = json.loads(a.read())
            dict['userName'] = authDict['username']
            dict['password'] = authDict['password']
            dict['host'] = authDict['host']
            dict['port'] = authDict['port']
        except Exception as e:
            print("Error: There was a problem with the authentication file. Please ensure that the values are in dictionary format with keys: 'username', 'password', 'host', 'port'")
            print(e)
            exit()

    """Ensure maxrows is less than 10000"""
    MAX_ROWS = 10000
    if dict['maxInt'] > MAX_ROWS:
        print("Error: Maxrows limit of 10000 exceeded.")
        exit()

    ##Check for existence of Connection Settings in input dictionary, if not, exit
    if(not dict['userName'] or not dict['password'] or not dict['host'] or not dict['port']):
        print('\nError: Missing required connection settings. Please specify username, password, host, or port.')
        print("Username:", dict['userName'], " Password:", dict['password'], " Host:", dict['host'], " Port:", dict['port'])
        exit()
        
    if (dict['message']):
        if(type(dict['message']) == list):
            dict['message']= " ".join(dict['message'])
        if (dict['message'].find("'") > -1): ##Check for invalid single quotes
            print("Please remove single quotes ('') from search argument.")
            exit()

    if dict['out-filename']: ##Check for supported file-types

        if (dict['maxInt'] == 0):
            dict['maxInt'] = 250

        if(type(dict['out-filename']) == list):
            dict['out-filename']= " ".join(dict['out-filename'])

        if(dict['format']):
            if ("." in dict['out-filename']):
                dict['out-filename'] = dict['out-filename'][0:dict['out-filename'].find(".")] + "." + dict['format']
            else:
                dict['out-filename'] = dict['out-filename'] + "." + dict['format']
        
        else:
            if ((not ".csv" in dict['out-filename']) and (not ".json" in dict['out-filename'])):
                if ("." in dict['out-filename']):
                    print('Error: Not a supported filetype for the output file.')
                    exit()
                else:
                    print('Setting default filetype: CSV')
                    dict['out-filename'] = dict['out-filename'] + ".csv"

        if (not (DEFAULT_DIR + "/") in dict['out-filename']):
            dict['out-filename'] = os.path.join(DEFAULT_DIR, dict['out-filename'])
        
        if os.path.isfile(dict['out-filename']):
            if (dict['force'] == False):
                print("\nUser specified output file already exists. Use -f to overwrite the file.\n")
                exit()

    if dict['savequery']:      
        if(type(dict['savequery']) == list):
            dict['savequery']= " ".join(dict['savequery'])
        if (dict['savequery'].find('.') == -1):
            dict['savequery'] = dict['savequery'] + ".json"
        if ((not ".json" in dict['savequery'])):
            print('Error: Not a supported filetype for the saved query file.')
            exit()
        if (not (DEFAULT_DIR + "/") in dict['savequery']):
            dict['savequery']= os.path.join(DEFAULT_DIR, dict['savequery'])

    if dict['query-filename']:
        if (not (DEFAULT_DIR + "/") in dict['query-filename']):
            dict['query-filename'] = os.path.join(DEFAULT_DIR, dict['query-filename'])
        
        if (not os.path.isfile(dict['query-filename'])):
            print("Error: Invalid query file path.")
            exit()
    else: ## If no output file, set default maxrows to 25
        if (dict['maxInt'] == 0):
            dict['maxInt'] = 25

    
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
            dict['dateTimeStart'] = time.strftime("%Y-%m-%dT%H:%M:%S%z", time.gmtime(time.mktime(dict['dateTimeStart'])))
            dict['dateTimeEnd'] = time.strftime("%Y-%m-%dT%H:%M:%S%z", time.gmtime(time.mktime(dict['dateTimeEnd'])))
    except ValueError:
        print("One or more date(s) have been formatted incorrectly. Correct format is Y-M-D H:M:S. Ex: 1999-02-07 10:00:00")  
        exit()

def build_query(dict): ##Generates Query using Opensearch DSL
    """Takes query arguments from user and builds a query to pass to opensearch client"""
    first = True 
    argcounter=0    ##Counts unique options entered by user, sets min_match to this number
    if (not dict['query-filename']):     ##If User has not specified query file, create temp file for one.                                                                                                                                                                                                                                                                                                                                                                                   first = True
        x = open(DEFAULT_DIR + "/temp_SAS_OSQ.TXT", 'x')
        x = open(DEFAULT_DIR + "/temp_SAS_OSQ.TXT", 'wt')  ## Create txt file to write query, make it writable
        x.write('{"size": ' + str(dict['maxInt']) + ',"sort": [{"@timestamp": {"order": "desc","unmapped_type": "boolean"} }]')     ## Establish size of query, remove scoring
        x.write(', "query": {"bool": {"must":[ {"range": {"@timestamp": {"gte": "' + dict['dateTimeStart'] + '","lt": "' + dict['dateTimeEnd'] + '"} } }], ')   ##Establish Query with Range Requirements, 3 open brackets
        x.write('"should": [ ')     ## Should Clause, search results must inlcude at least one of each specified option
        for arg in dict.keys():
            if (("kube" in arg or "level" in arg or "mes" in arg or "log" in arg) and (dict[arg]) and arg.find('-ex')==-1): ##Looking for non-exclusion options that are not NoneType in args dictionary
                argcounter+=1
                if (first == True):
                    first = False  
                else:
                    x.write(',')       
                if arg!='message':
                    for i in range(len(dict[arg])):
                        x.write('{"match_phrase": { "' + arg + '":"' + dict[arg][i] + '" } }')
                        if(i != len(dict[arg])-1):
                            x.write(',')
                else:
                    x.write('{"match_phrase": { "message":"' + (" ".join(dict[arg])) + '"} }')
        first = True
        x.write('], "minimum_should_match": ' + str(argcounter))
        for arg in dict.keys(): ##Must Not Clause, only added if specified by user
            if (("kube" in arg or "level" in arg or "log" in arg) and dict[arg] and arg.find('-ex')>-1):
                name = arg[0:arg.find('-')]
                if (first == True):
                    x.write(', "must_not": [')
                    first = False
                else:
                    x.write(',')
                for i in range(len(dict[arg])):
                    x.write('{"match_phrase": {"' + name + '":"' + dict[arg][i] + '"} }')
                    if i != len(dict[arg])-1:
                        x.write(',')
        if (first==False):
            x.write(']')
        x.write('} } }') ##Close 3 open brackets, end query
        x = open(DEFAULT_DIR + "/temp_SAS_OSQ.TXT", 'rt')
        query =  " ".join([line.strip() for line in x])
        x.close()
        os.remove(DEFAULT_DIR + "/temp_SAS_OSQ.TXT") ##Remove Temp File Created for Query Generation
    else:
        x = open(dict['query-filename'], 'rt')
        query =  " ".join([line.strip() for line in x]) ## Turn file into string, return.
        x.close()
    
    return query

##List of VALID arguments that are read from user as soon as program is run, nargs=+ indicates that argument takes multiple whitespace separated values. 
def get_arguments():
    """Defines the arguments a user can pass and parses them"""
    parser = argparse.ArgumentParser(prog='getLogs.py', usage='\n%(prog)s [options]', description="This program generates OpenSearch DSL Queries from user specified parameters, and submits them to a database to retrieve logs. The flags below provide specifications for your Query, and can be placed in any order. \n   IMPORTANT NOTES: \n    *Connection settings are required in order to run the program. You can create config files to autofill this using --create-auth, and call them using --auth-file \n    *The NAMESPACE*, POD*, CONTAINER*, LOGSOURCE* and LEVEL* options accept multiple, space-separated, values (e.g. --level INFO NONE) Please refrain from passing single quotes ('') into arguments. \n    *All Generated Program files are placed in a folder titled GetLogssFiles in the directory where the program is run. It is not required to include this directory when passing created files in as arguments.\n    *Correct time format is Y-M-D H:M:S. Ex: 1999-02-07 10:00:00 \n    *All default values for username, password, host, and port are derived from the ENV variables ESUSER, USPASSWD, ESHOST, ESPORT\n\n\n \t\t\t\t QUERY SEARCH PARAMETERS: \n\n", formatter_class=argparse.RawTextHelpFormatter)
    
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
    parser.add_argument('-m', '--maxrows', required=False, dest ="maxInt", type=int, metavar="INTEGER", default=0,  help = "\nThe maximum number of log messsages to return. Max possible rows is 10000\n\n")
    parser.add_argument('-q', '--query-file ', required=False, dest="query-filename", metavar="FILENAME.*", help = "\nName of file containing search query (Including filetype) at end. Program will submit query from file, ALL other query parmeters ignored. Supported filetypes: .txt, .json\n\n")
    parser.add_argument('-sh', '--show-query', required=False, dest="showquery", action= "store_true", help = "\n Display example of actual query that will be submitted during execution.\n\n")
    parser.add_argument('-sq', '--save-query', required=False, dest="savequery",  nargs='*', metavar="FILENAME", help = "\n Specify a file name (WITHOUT filetype) in which to save the generated query. Query is saved as JSON file in current directory.\n\n")
    parser.add_argument('-o', '--out-file', required=False, dest="out-filename",  nargs='*', metavar="FILENAME", help = "\nName of file to write results to. Filetype is specified using -format. Supported filetypes: .csv, .json\n\n")
    parser.add_argument('-fo','--format',  required=True, dest="format", choices = ["json","csv"], help = "\n Formats results into the specified file (from --out-file). If no output file is provided, results will be outputted to STDOUT. Supported formats for console output are json and csv \n\n")
    parser.add_argument('-f','--force',  required=False, dest="force", action= "store_true", help = "\n If this option is provided, the output results file will be overwritten if it already exists.\n\n")
    parser.add_argument('-fi','--fields',  required=False, dest="fields", nargs="*", metavar= "FIELDS", default=['@timestamp', 'level', 'logsource', 'namespace','pod', 'container', 'message'], help = "\n Specify output columns (CSV file only) Please provide a space separated list of fields. \n Default fields: @timestamp level logsource namespace pod container message \n Additional arguments: host index properties debug \n\n")
    parser.add_argument('-st', '--start', required=False, dest="dateTimeStart", nargs='*', metavar="DATETIME",  default = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(time.mktime(time.localtime()) - 3600)), help = "\nDatetime for start of period for which logs are sought (default: 1 hour ago).\n\n")
    parser.add_argument('-en', '--end', required=False, dest="dateTimeEnd",nargs='*', metavar="DATETIME",  default = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime()), help = "\nDatetime for end of period for which logs are sought (default: now). \n\n\n \t\t\t CONNECTION SETTINGS: \n\n")
    
    parser.add_argument('-i', '--index', required=False, dest="index", metavar="INDEX", default="viya_logs-*") ## help = "\nDetermine which index to perform the search in. Default: viya-logs-*\n\n
    ##Connection settings
    parser.add_argument('-us','--user',  required=False, dest="userName", default=os.environ.get("ESUSER"), help = "\nUsername for connecting to OpenSearch/Kibana (default: $ESUSER)\n\n")
    parser.add_argument('-pw', '--password', required=False,  dest="password", default=os.environ.get("ESPASSWD"), help = "\nPassword for connecting to OpenSearch/Kibana  (default: $ESPASSWD)\n\n")
    parser.add_argument('-ho', '--host', required=False,  dest="host", default=os.environ.get("ESHOST"), help = "\nHostname for connection to OpenSearch/Kibana (default: $ESHOST)\n\n")
    parser.add_argument('-po', '--port', required=False,  dest="port", default=os.environ.get("ESPORT"), help = "\nPort number for connection to OpenSearch/Kibana (default: $ESPORT)\n\n")
    parser.add_argument('-nossl', '--disable-ssl', required=False, dest = "ssl", action= "store_false", help = "\n If this option is provided, SSL will not be used to connect to the database.\n\n")
    parser.add_argument('-af', '--auth-file', required=False, dest="auth-file", metavar="FILENAME.*", nargs='*', help = "\n The program will read the connection information from this file (include filetype).\n\n")
    parser.add_argument('-cf', '--create-auth', required=False, dest="create-auth", metavar="FILENAME.*", nargs='*', help = "\n Creates a template authentication file (include filetype) under the specified file name. Connection information can be entered here.")
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
    if (".json" in args['savequery']):
        with y as outfile:
            json.dump(eval(x), outfile, indent=2)   
    
    elif (".txt" in args['savequery'] or ".lst" in args['savequery']):
        y.write(str(x))

    else:
        print("Please provide a file type for the saved query")
        exit()

    print("\nQuery saved to " + args['savequery'])
    
print('\nSearching index: ')
try:
    response = client.search(body=x, index=index_name)
except Exception as e: 
    print(e)
    print("\n")
    if ("refused" in str(e)):
        print("Connection Refused. Verify that user authentication and connection settings are set for the correct database.")
    elif ("getaddrinfo" in str(e)):
        print("Connection Failed. Verify the host and port values. ")
    elif("Unauthorized" in str(e)):
        print("User Authentication failed. Verify username and password values. ")
    else:
        print("Connection error. Please verify connection values. ") 
    exit()

if response['hits']['total']['value'] == 0:
    print("No results found for submitted query.")
    exit()

stdout = False
if (args['out-filename']): ##Check if user specified file exists, and if it should be overwritten.
    try:
        x = open(args['out-filename'], 'w')    
    except FileNotFoundError as e:
        print("Output file Directory not found. Please verify output file path.")
        exit()
else:
    stdout = True

##Output as proper filetype
if("json" in args['format']): 
    if (not stdout):
        with x as outfile:
            json.dump(response['hits']['hits'], outfile, sort_keys=True, indent=2)
        print("Search complete. Results printed to " + args['out-filename'])
    else:
        print("Search complete.")
        sys.stdout.write(json.dumps(response['hits']['hits'], sort_keys=True, indent=2))

elif("csv" in args['format']):

    i =0
    for field in args['fields']:
        args['fields'][i] = field.replace(',','')
        i+=1
    
    valueStore = []
    dictArray=[]
    for log in response['hits']['hits']:
        for field in args['fields']: ##Compounds dictionaries inside of dictionaries into one dictionary so writerow works as intended.
            for arg in log.keys(): ##Finds dictionaries inside of dictionaries, stores values
                if (not field in arg):
                    if type(log[arg]) == dict:
                        for item in log[arg].keys():
                            if not field in item:
                                if type(log[arg][item]) == dict:
                                    for subitem in log[arg][item].keys():
                                        if subitem in field:
                                            valueStore.append(log[arg][item][subitem])
                            else:
                                valueStore.append(log[arg][item])
                else:
                    valueStore.append(log[arg])
        newDict= dict(zip(args['fields'], valueStore))
        dictArray.append(newDict)
        valueStore.clear()
    
    if (not stdout):
        with x as csvfile:
            header = args['fields']
            writer = csv.DictWriter(csvfile, fieldnames = header)
            writer.writeheader()
            for log in dictArray:
                writer.writerow(log)
            print("Search complete. Results printed to " + args['out-filename'])   
    else:
        print("Search complete")
        with sys.stdout as csvfile:
            header = args['fields']
            writer = csv.DictWriter(csvfile, fieldnames = header)
            writer.writeheader()
            for log in dictArray:
                writer.writerow(log)
                print("\n")
