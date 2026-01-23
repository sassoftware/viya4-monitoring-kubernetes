#! /usr/bin/python3

# Copyright Â© 2023, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

import time, calendar
import argparse
from opensearchpy import OpenSearch
import os, sys
import json, csv
import tempfile
import subprocess, socket
from subprocess import run
##v 0.2.0

def validate_input(checkInput):
    """ Validate the arguments passed by the user to ensure script will function properly"""

    #Check whether user provided kubeconfig for port-forwarding
    if checkInput['portforward']:
        if os.environ.get('KUBECONFIG') is None:
            print("Error: Port forwarding argument selected but no KUBECONFIG env variable set.")
            sys.exit(1)
        else: ##Set default values
            checkInput['host'] = 'port forwarded'
            checkInput['port'] = 'port forwarded'

    ##Check for existence of Connection Settings in input dictionary
    if(not checkInput['userName'] or not checkInput['password'] or not checkInput['host'] or not checkInput['port']):
        print('\nError: Missing required connection settings. Please specify username, password, host, and port. \nDefault values can be manually exported as environment variables OSHOST, OSPORT, OSUSER, OSPASSWD \nTo port-forward and skip OSHOST and OSPORT, use -pf')
        print("Username:", checkInput['userName'], " Password:", checkInput['password'], " Host:", checkInput['host'], " Port:", checkInput['port'])
        sys.exit(1)

    if checkInput['out-filename']: ##Check for supported file-types and existence of file

        if(type(checkInput['out-filename']) == list):
            checkInput['out-filename']= " ".join(checkInput['out-filename'])

        if os.path.isfile(checkInput['out-filename']): ##Check if file already exists
            if (checkInput['force'] == False):
                print("\nUser specified output file already exists. Use -f to overwrite the file.\n")
                sys.exit(1)

        safe_dir = os.getcwd() ## Check for path traversal attack
        if os.path.commonprefix((os.path.realpath(checkInput['out-filename']),safe_dir)) != safe_dir:
            print("Error: Out-file path must be in the current working directory.")
            sys.exit(1)

        try:
            x = open(checkInput['out-filename'], 'w')
            x.close()
        except FileNotFoundError as e:
            print("Error: Output file path not found. Please verify output file path. ")
            sys.exit(1)

    if checkInput['savequery']: ##Find saved query path location
        if(type(checkInput['savequery']) == list):
            checkInput['savequery']= " ".join(checkInput['savequery'])
        if (checkInput['savequery'].find('.') == -1):
            checkInput['savequery'] = checkInput['savequery'] + ".json"
        if ((not ".json" in checkInput['savequery'])):
            print('Error: Not a supported filetype for the saved query file. Supported type is .json')
            sys.exit(1)

    if checkInput['query-filename']: ##Use for plugging in queries
        safe_dir = os.getcwd() ## Check for path traversal attack
        if os.path.commonprefix((os.path.realpath(checkInput['query-filename']),safe_dir)) != safe_dir:
            print("Error: Query file must be from the current working directory.")
            sys.exit(1)

        if (not os.path.isfile(checkInput['query-filename'])):
            print("Error: Invalid query file path.")
            sys.exit(1)

    ##Time Validator - Verifies input, and converts it to UTC
    if (type(checkInput['dateTimeStart']) ==list):
        checkInput['dateTimeStart'] = " ".join(checkInput['dateTimeStart'])
    if (type(checkInput['dateTimeEnd']) == list):
        checkInput['dateTimeEnd'] = " ".join(checkInput['dateTimeEnd'])
    try:
        checkInput['dateTimeStart'] = (time.strptime(checkInput.get('dateTimeStart'), "%Y-%m-%d %H:%M:%S"))
        checkInput['dateTimeEnd'] = (time.strptime(checkInput.get('dateTimeEnd'), "%Y-%m-%d %H:%M:%S"))
        if (calendar.timegm(checkInput['dateTimeStart']) > calendar.timegm(checkInput['dateTimeEnd'])):
            print("Error: Given start date is after the end date.")
            sys.exit(1)
        else:
            checkInput['dateTimeStart'] = time.strftime("%Y-%m-%dT%H:%M:%S", time.gmtime(time.mktime(checkInput['dateTimeStart'])))
            checkInput['dateTimeEnd'] = time.strftime("%Y-%m-%dT%H:%M:%S", time.gmtime(time.mktime(checkInput['dateTimeEnd'])))
    except ValueError:
        print("Error: One or more date(s) have been formatted incorrectly. Correct format is Y-M-D H:M:S. Ex: 1999-02-16 10:00:00")
        sys.exit(1)

    if (checkInput['message']): ## Argument formatting for query builder
        checkInput['message'] = checkInput['message'].replace('"',"'")

def open_port():
    """Binds the v4m-search service on port 9200 to a locally available port by accessing the namespace of running OpenSearch instance"""
    """Modifies host and port args"""
    #Get open port
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.bind(("",0))
    s.listen(1)
    port = s.getsockname()[1]
    s.close()

    find_namespace_cmd = ['kubectl', 'get', 'service', '-l' ,'app.kubernetes.io/component=v4m-search', '-A' ,'-o', 'jsonpath={range.items[0]}{.metadata.namespace}']
    result = subprocess.run(find_namespace_cmd, capture_output=True, text=True)

    port_namespace = result.stdout.replace("'", "")
    if (not port_namespace):
        print("Error: The V4M OpenSearch service is not currently running on this cluster. Port forwarding failed.")
        sys.exit(1)

    cmd = (["kubectl", "-n", port_namespace, "port-forward", "svc/v4m-search", str(port) + ':9200', '&'])
    full_command = " ".join(cmd)

    proc = subprocess.Popen(full_command, shell=True, stdout = subprocess.DEVNULL, stderr = subprocess.DEVNULL)

    time.sleep(5)

    return port

def build_query(args):
    """Generates Query using Opensearch DSL"""
    """Takes arguments from user and returns a JSON-format query to pass to OpenSearch API"""
    first = True
    sourcerequested = False
    argcounter=0    ##Counts unique options entered by user, sets min_match to this number
    if (not args['query-filename']):
        tfile = tempfile.NamedTemporaryFile(delete = False)  ##If User has not specified query file, create temp file for one.
        temp = open(tfile.name, 'w')

        temp.write('{"size": ' + str(args['maxInt']) + ',"sort": [{"@timestamp": {"order": "desc","unmapped_type": "boolean"} }]')     ## Establish size of query, remove scoring
        temp.write(', "query": {"bool": {"must":[ {"range": {"@timestamp": {"gte": "' + args['dateTimeStart'] + '","lt": "' + args['dateTimeEnd'] + '"} } }], ')   ##Establish Query with Time Range Requirements
        temp.write('"should": [ ')     ## Should Clause, search results must inlcude at least one of each specified option
        for argname in args.keys():
            if (("kube" in argname or "level" in argname or "mes" in argname or "log" in argname) and (args[argname]) and argname.find('-ex')==-1): ##Looking for non-exclusion options that are not NoneType in args argsionary
                argcounter+=1
                if (first == True):
                    first = False
                else:
                    temp.write(',')
                if argname!='message':
                    for i in range(len(args[argname])):
                        temp.write('{"match_phrase": { "' + argname + '":"' + args[argname][i] + '" } }')
                        if(i != len(args[argname])-1):
                            temp.write(',')
                else:
                    temp.write('{"match_phrase": { "message":"' + args[argname] + '"} }')
        first = True
        temp.write('], "minimum_should_match": ' + str(argcounter))
        for argname in args.keys(): ##Must Not Clause, only added if specified by user
            if (("kube" in argname or "level" in argname or "log" in argname) and args[argname] and argname.find('-ex')>-1):
                name = argname[0:argname.find('-')]
                if (first == True):
                    temp.write(', "must_not": [')
                    first = False
                else:
                    temp.write(',')
                for i in range(len(args[argname])):
                    temp.write('{"match_phrase": {"' + name + '":"' + args[argname][i] + '"} }')
                    if i != len(args[argname])-1:
                        temp.write(',')
        if (first==False):
            temp.write(']')
        temp.write('} },')
        temp.write(' "fields": [') ## Add fields param
        for i in range(len(args['fields'])):
            if args['fields'][i]=="_source":
               sourcerequested=True
            if i < len(args['fields']) - 1:
                temp.write('"' + args['fields'][i] + '",' )
            else:
               temp.write('"' + args['fields'][i] + '"],' )
        if (sourcerequested==True):
           temp.write('"_source": {"excludes": [] } }')
        else:
           temp.write('"_source": false }')
        temp.close()

        temp = open(tfile.name, 'r')
        query =  " ".join([line.strip() for line in temp]) ## Turns query into string
        temp.close()
        tfile.close()

    else: ##Open existing query
        x = open(args['query-filename'], 'rt')
        query =  " ".join([line.strip() for line in x]) ## Turn file into string, return.
        x.close()

    return query

def get_arguments():
    """List of valid arguments that are read from user as soon as program is run, nargs=+ indicates that argument takes multiple whitespace separated values. """

    parser = argparse.ArgumentParser(prog='getLogs.py', usage='\n%(prog)s [options]', description="""This program generates OpenSearch DSL Queries from user specified parameters, and submits them to a database to retrieve logs. The flags below provide specifications for your Query, and can be placed in any order. \n
    \033[1m NOTES: *All default values for username, password, host, and port, are derived from the ENV variables OSUSER, OSPASSWD, OSHOST, OSPORT in that respective order. '\033[0m' \n
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
    parser.add_argument('-se', '--search', required=False, dest= "message", metavar="MESSAGE",  help = "\nWord or phrase contained in log message. Use quotes to surround your message ('' or "")\n\n\n \t\t\t QUERY OUTPUT SETTINGS: \n\n")

    ##Query and Output Params
    parser.add_argument('-m', '--maxrows', required=False, dest ="maxInt", type=int, metavar="INTEGER", default=10,  help = "\nThe maximum number of log messsages to return.\n\n")
    parser.add_argument('-q', '--query-file ', required=False, dest="query-filename", metavar="FILENAME.*", help = "\n Filepath of existing saved query in current working directory. Program will submit query from file, ALL other query parmeters ignored. Supported filetypes: .txt, .json\n\n")
    parser.add_argument('-sh', '--show-query', required=False, dest="showquery", action= "store_true", help = "\n Displays the actual query that will be submitted during execution.\n\n")
    parser.add_argument('-sq', '--save-query', required=False, dest="savequery",  nargs='*', metavar="FILENAME", help = "\n Specify a file name (without filetype) in which to save the generated query. Query is saved as JSON file in current working directory.\n\n")
    parser.add_argument('-o', '--out-file', required=False, dest="out-filename",  nargs='*', metavar="FILENAME", help = "\nName of file to write results to. If no output file is provided, results will be outputted to STDOUT. \n\n")
    parser.add_argument('-fo','--format',  required=False, dest="format", default = "csv", choices = ['json', 'csv'], help = "\n Determines the output format for the returned log messages. Supported formats for output are json and csv. \n\n")
    parser.add_argument('-f','--force',  required=False, dest="force", action= "store_true", help = "\n If this option is provided, the output results file from --out-file will be overwritten if it already exists.\n\n")
    parser.add_argument('-fi','--fields',  required=False, dest="fields", nargs="*", metavar= "FIELDS", default=['@timestamp', 'level', 'kube.pod', 'message'], help = "\n Specify desired output columns from query. If a matching log is returned that does not have the specified field, a NULL value will be used as a placeholder. The _id field is always provided for every log message. \n Default fields: @timestamp level kube.pod message _id\n\n")
    parser.add_argument('-st', '--start', required=False, dest="dateTimeStart", nargs='*', metavar="DATETIME",  default = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(time.mktime(time.localtime()) - 3600)), help = "\nDatetime for start of period for which logs are sought (default: 1 hour ago). Correct format is Y-M-D H:M:S. Ex: 2023-02-16 10:00:00\n\n")
    parser.add_argument('-en', '--end', required=False, dest="dateTimeEnd",nargs='*', metavar="DATETIME",  default = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime()), help = "\nDatetime for end of period for which logs are sought (default: now). \n\n\n \t\t\t CONNECTION SETTINGS: \n\n")

    parser.add_argument('-i', '--index', required=False, dest="index", metavar="INDEX", default="viya_logs-*") ## help = "\nDetermine which index to perform the search in. Default: viya-logs-*\n\n
    ##Connection settings
    parser.add_argument('-pf','--port-forward', required=False, dest="portforward", action = 'store_true', help = "\n If this option is provided, getlogs will use the value in your KUBECONFIG (case-sensitive) environment variable to port-forward and connect to the OpenSearch API. This skips OSHOST and OSPORT, but OSUSER and OSPASSWD are stil required to authenticate and connect to the database. \n\n")
    parser.add_argument('-us','--user',  required=False, dest="userName", default=os.environ.get("OSUSER"), help = "\nUsername for connecting to OpenSearch (default: $OSUSER)\n\n")
    parser.add_argument('-pw', '--password', required=False,  dest="password", default=os.environ.get("OSPASSWD"), help = "\nPassword for connecting to OpenSearch  (default: $OSPASSWD)\n\n")
    parser.add_argument('-ho', '--host', required=False,  dest="host", default=os.environ.get("OSHOST"), help = "\nHostname for connection to OpenSearch Please ensure that host does not contain 'https://' (default: $OSHOST)\n\n")
    parser.add_argument('-po', '--port', required=False,  dest="port", default=os.environ.get("OSPORT"), help = "\nPort number for connection to OpenSearch (default: $OSPORT)\n\n")
    parser.add_argument('-nossl', '--disable-ssl', required=False, dest = "ssl", action= "store_false", help = "\n If this option is provided, SSL will not be used to connect to the database.\n\n")

    # Add arguments for path-based ingress configuration
    parser.add_argument('--path-based', required=False, dest="path_based", nargs='?',
                        const="opensearch", default=None,
                        help="Specify if path-based ingress is used. Without a value, defaults to 'opensearch' prefix. "
                             "You can also specify a custom prefix, e.g. --path-based my-custom-prefix")

    return parser.parse_args().__dict__

def main():
    url_prefix = None
    args = get_arguments() ##Creates "args" dictionary that contains all user submitted options. Print "args" to debug values. Note that the 'dest' value for each argument in argparser object is its key.
    validate_input(args) ##Pass args dictionary for input validation

    if args['portforward']: ##Modify connection settings if port forward is selected
        args['host'] = 'localhost'
        args['port'] = open_port()

    if args['path_based']:
        # User specified path-based ingress - either default or custom
        url_prefix = args['path_based']  # Will be "opensearch" or custom value

    # Establish Client Using User Authorization and Connection Settings

    # Create hosts configuration
    host_config = {
        'host': args['host'],
        'port': args['port']
    }
    if url_prefix:
        host_config['url_prefix'] = url_prefix
        print(f"Using path-based ingress with prefix: {url_prefix}")
    else:
        print("Using host-based ingress (no URL prefix)")

    auth = (args['userName'], args['password'])
    client = OpenSearch(
        # hosts = [{'host': args['host'], 'url_prefix': 'opensearch','port': args['port']}],
        hosts = [host_config],
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
        print("The following query will be submitted:\n\n", json.dumps(json.loads(x), indent=2))

    if(args['savequery']): ##Save Query if user asks.
        safe_dir = os.getcwd()
        if os.path.commonprefix((os.path.realpath(args['savequery']),safe_dir)) == safe_dir:
            squery = os.path.realpath(args['savequery'])
            # deepcode ignore PT: <Snyk bug: Path traversal checking implemented but not detected by snyk>
            with open(squery, "w") as outfile:
                outfile.write(x)
        else:
            print("Error: Saved query must be written to current working directory.")
            sys.exit(1)
        print("\nQuery saved to " + args['savequery'])

    print('\nSearching index: ')
    try:
        #scroll
        response = client.search(body=x, index=index_name, scroll='1m')
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
        sys.exit(1)

    if response['hits']['total']['value'] == 0:
        print("No results found for submitted query.")
        sys.exit(0)

    stdout = False
    if (not args['out-filename']):
        stdout = True
    else:
        # deepcode ignore PT: <Path traversal detection for out-filename already implemented on line 42>
        x = open(args['out-filename'], 'w', encoding='utf-8', newline='')
    
    MAX_ROWS=args['maxInt']
    row_count=0

    hitsList = [] ##Check to see if any fields in response matched user provided fields, collect matching fields
    pagination_id = response["_scroll_id"]
    for hit in response['hits']['hits']:
        try:
            hit['fields']['_id'] = hit['_id']
            hitsList.append(hit['fields'])
        except KeyError as e:
            continue
        row_count += 1
        if row_count >= MAX_ROWS:
            break
    while len(response['hits']['hits']) != 0 and row_count < MAX_ROWS:
        response = client.scroll(
            scroll='1m',
            scroll_id=pagination_id
        )
        pagination_id = response["_scroll_id"]
        for hit in response['hits']['hits']:
            try:
                hit['fields']['_id'] = hit['_id']
                hitsList.append(hit['fields'])
            except KeyError as e:
                continue
            row_count += 1
            if row_count >= MAX_ROWS:
                break
    try:
        client.clear_scroll(scroll_id=pagination_id)
    except Exception:
        pass

    for fieldDict in hitsList:
        for field in args['fields']:
            if not field in fieldDict.keys(): ##replaces empty fields with NULL values
                fieldDict[field] = "NULL"
            elif type(fieldDict[field]) == list: ##Converts lists into strings for proper output
                fieldDict[field] = ''.join(fieldDict[field])

    if (len(hitsList) == 0):
        print("No fields matched provided fieldnames. Please verify the field on OpenSearch Dashboards.\n")
        sys.exit(0)

    ##Output as proper filetype, JSON or CSV
    if("json" in args['format']): ##JSON formatter, uses json.dump to print to stdout or file
        if (not stdout):
            with x as outfile:
                # deepcode ignore PT: <Same as before, Path traversal for outfile is checked on line 42>
                json.dump(hitsList, outfile, sort_keys=True, indent=2)
            print("Search complete. Results printed to " + args['out-filename'])
        else:
            print("Search complete.")
            sys.stdout.write(json.dumps(hitsList, sort_keys=True, indent=2))

    elif("csv" in args['format']): ##CSV writer implemented using dictwriter
        args['fields'].append("_id")

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

if __name__ == "__main__":
    main()
