# Export Logs

>Note: This script is experimental, and might be significantly changed, replaced, or removed in later releases. Feedback is welcomed about the functionality represented by this script, including requirements, usage scenarios, and required options. 

There might be instances when you need to collect a set of log messages in a file. For 
example, you might need to send log messages collected during a specific time period or for a specific pod to SAS Technical Support to help diagnose a problem. The `getlogs.sh` script enables you to obtain log messages from a specified time period and from specified sources and save those messages to a file. 

Required Depenencies:
* Python 3
* OpenSearch library (`pip install opensearch-py`)

This program generates OpenSearch DSL Queries from user specified parameters, and submits them to OpenSearch to retrieve logs. The arguments below provide specifications for your query, and can be placed in any order. 
    -Connection settings are required in order to run the program. 
    -The NAMESPACE*, POD*, CONTAINER*, LOGSOURCE* and LEVEL* options accept multiple, space-separated, values (e.g. --level INFO NONE). 
    -All generated files are placed in the directory where the program is run.
    -Use -sq to save generated queries, -q to run previously saved queries.
    -The expected time format is Y-M-D H:M:S. Ex: 1999-02-07 10:00:00

optional arguments:
  -h, --help            show this help message and exit
  -n [NAMESPACE ...], --namespace [NAMESPACE ...]
                        
                        One or more Viya deployments/Kubernetes namespaces for which logs are sought
                        
  -nx [NAMESPACE ...], --namespace-exclude [NAMESPACE ...]
                        
                        One or more namespaces for which logs should be excluded from the output
                        
  -p [POD ...], --pod [POD ...]
                        
                        One or more pods for which logs are sought
                        
  -px [POD ...], --pod-exclude [POD ...]
                        
                        One or more pods for which logs should be excluded from the output
                        
  -c [CONTAINER ...], --container [CONTAINER ...]
                        
                        One or more containers for which logs are sought
                        
  -cx [CONTAINER ...], --container-exclude [CONTAINER ...]
                        
                        One or more containers from which logs should be excluded from the output
                        
  -s [LOGSOURCE ...], --logsource [LOGSOURCE ...]
                        
                        One or more logsource for which logs are sought
                        
  -sx [LOGSOURCE ...], --logsource-exclude [LOGSOURCE ...]
                        
                        One or more logsource for which logs should be excluded from the output
                        
  -l [LEVEL ...], --level [LEVEL ...]
                        
                        One or more message levels for which logs are sought
                        
  -lx [LEVEL ...], --level-exclude [LEVEL ...]
                        
                        One or more message levels for which logs should be excluded from the output.
                        
  -se [MESSAGE ...], --search [MESSAGE ...]
                        
                        Word or phrase contained in log message.
                        
  -m INTEGER, --maxrows INTEGER
                        
                        The maximum number of log messsages to return (default: 10 max:10,000).
                        
  -q FILENAME.*, --query-file  FILENAME.*
                        
                        Name of file containing search query (Including filetype) at end. Program will submit query from file, ALL other query parmeters ignored. Supported filetypes: .txt, .json
                        
  -sh, --show-query     
                         Display example of actual query that will be submitted during execution.
                        
  -sq [FILENAME ...], --save-query [FILENAME ...]
                        
                         Specify a file name (WITHOUT filetype) in which to save the generated query. If no file is specified, the query will not be saved. Query is saved in JSON format. 
                        
  -o [FILENAME.* ...], --out-file [FILENAME.* ...]
                        
                        Name of file to write results to (default: [stdout]). 
                        
  -fo {csv,json,txt}, --format {csv,json,txt}
                        
                         Specify the output format for the results file.  
                        
  -f, --force           
                         If this option is provided, the output results file will be overwritten if it already exists.
                        
  -fi [FIELDS ...], --fields [FIELDS ...]
                        
                         Specify output columns (CSV file only) 
                        
  -st [DATETIME ...], --start [DATETIME ...]
                        
                        Datetime for start of period for which logs are sought (default: 1 hour ago).
                        
  -en [DATETIME ...], --end [DATETIME ...]
                        
                        Datetime for end of period for which logs are sought (default: now). 
                        
  -i INDEX, --index INDEX
                        
                        Determine which index to perform the search in. Default: viya-logs-*
                        
  -us USERNAME, --user USERNAME
                        
                        Username for connecting to OpenSearch (default: $ESUSER)
                        
  -pw PASSWORD, --password PASSWORD
                        
                        Password for connecting to OpenSearch  (default: $ESPASSWD)
                        
  -ho HOST, --host HOST
                        
                        Hostname for connection to OpenSearch (default: $ESHOST)
                        
  -po PORT, --port PORT
                        
                        Port number for connection to OpenSearch (default: $ESPORT)
                        
  -ss, --disable-ssl    
                         If this option is provided, SSL will not be used to connect to the database.
                        
