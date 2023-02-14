# Export Logs

>Note: This script is experimental, and might be significantly changed, replaced, or removed in later releases. Feedback is welcomed about the functionality represented by this script, including requirements, usage scenarios, and required options. 

There might be instances when you need to collect a set of log messages in a file. For 
example, you might need to send log messages collected during a specific time period or for a specific pod to SAS Technical Support to help diagnose a problem. The `getlogs.sh` script enables you to obtain log messages from a specified time period and from specified sources and save those messages to a file. 

When you submit the script, it requests a batch of log messages. Each request then generates a query that are submitted to OpenSearch.

To download the log messages, run the `getlogs.sh` script. This is the syntax for the script:

`getlogs.sh `[query options] [time period options] [output options] [connection options] [other options]`

NOTE: prior to release 1.1.0 of this project, the `-- namespace` *`namespace`* option was required. This option is no longer required.

A query is cancelled if it does not complete within three minutes.

For options than accept multiple values, the values must be in quotes and must be separated by commas. 

If you are using nodeports, an administrator must run the `configure_nodeport.sh` 
script to enable HTTPS access to OpenSearch and to obtain the host and port values to use when specifying the connection options. See [Configure Access to OpenSearch](https://documentation.sas.com/?cdcId=obsrvcdc&cdcVersion=default&docsetId=obsrvdply&docsetTarget=n0l4k3bz39cw2dn131zcbat7m4r1.htm). After this script is run, HTTPS access to OpenSearch remains enabled until one of the following occurs: 
- the `configure_nodeport.sh` script with the `disable` option is run.
- the logging components are redeployed. 

## Query Options

The query options specify the source of the log messages.

`-n|--namespace` *`"namespace-name[, namespace-name]"`*
specifies the Kubernetes namespace or namespaces for which you want to obtain log messages.

`-nx|--namespace-exclude` *`"namespace-name[, namespace-name]"`*
specifies the namespaces that you want to exclude when obtaining log messages.

`-p|--pod` *`"pod-name[, pod-name]"`*
specifies the pod or pods for which you want to obtain log messages.

`-px|--pod-exclude` *`"pod-name[, pod-name]"`*
specifies the pod or pods that you want to exclude when obtaining log messages.

`-c|--container` *`"container-name[, container-name]"`*
specifies the container or containers for which you want to obtain log messages.

`-cx|--container-exclude` *`"container-name[, container-name]"`*
specifies the container or containers that you want to exclude when obtaining log messages.

`-s|--logsource` *`"log-source[, log-source]"`*
specifies the log source or sources for which you want to obtain log messages.

`-sx|--logsource-exclude` *`"log-source[, log-source]"`*
specifies the log source or sources that you want to exclude when obtaining log messages.

`-l|--level` *`"log-level[, log-level]"`*
specifies the level or levels of the log messages that you want to obtain. Valid values for 
*`"log-level"`* are PANIC, FATAL, ERROR, WARNING, INFO, DEBUG, and NONE.

`-lx|--level-exclude` *`"log-level[, log-level]"`*
specifies the level or levels of the log messages that you want to exclude from the messages that are obtained. Valid values for *`"log_level"`* are the same as for the `--level` option.

`--search` *`"search-text"`*
specifies that only messages containing the specified *`"search-text"`* are returned.

`-m|--maxrows` *`max-messages`*
specifies the maximum number of messages that are returned. The default value is 20. If the `--out-file` option is also specified, the default value is 500.

`-q|--query-file` *`query-filename`*
specifies a file that contains values for all of the query and time period options. If this option is specified, all other query and time period options are ignored.

`--show-query`
displays the query that is submitted to obtain log information. If the specified command generates multiple queries, only the first query is displayed.

## Time Period Options

The time period options specify the time period over which the log messages are returned.
You can specify *`start-time`* and *`end-time`* as either a date value (in the form "2021-03-17") or a datetime value (in the form "2021-03-17T01:23"). Times are assumed to be server local time unless you specify UTC time or a timezone offset. If you specify only a date value, the time is assumed to be midnight at the beginning of the specified date. If you specify only a time value, the date is assumed to be the current day. 

`--start` *`start-time`*
specifies the datetime value for the beginning of the period over which the log messages are returned. The default value is one hour before the current time. 

`--end` *`end-time`*
specifies the datetime value for the end of the period over which the log messages are returned. 
The default value is the current date and time.

## Output Options

The output options specify the format in which the log messages are returned.

`-o|--out-file` *`output-filename`*
specifies a file to which the results are written. The default value is stdout. If the specified file exists, the script generates an error message and ends, unless you also specify the `--force` option.

`-f|--force`
overwrites the output file if it exists.

## Connection Options

The connection options specify the information needed to connect to OpenSearch.

If you are using ingress, the *`hostname`* and *`port-num`* are the host and port number for the ingress object.

`-us|--user` *`username`* 
specifies the user name to use to connect to OpenSearch in order to return the log messages.

`-pw|--password` *`password`*
specifies the password to use to connect to OpenSearch in order to return log messages.

`-h|--host` *`hostname`*
specifies the host name to use to connect to OpenSearch. If you are using ingress, the *`hostname`* is the host for the ingress object.

`-po|--port` *`port-num`*
specifies the port number to use when connecting to OpenSearch. If you are using ingress, the *`port-num`* is the port number for the ingress object.

`-pr|--protocol` `https | http`
specifies whether to use HTTPS or HTTP to connect to OpenSearch. The default value is `https`.

You can also specify these environment variables in order to provide connection information:
- `ESUSER=`*`username`*
- `ESPASSWD=`*`password`*
- `ESHOST=`*`hostname`*
- `ESPORT=`*`port-num`* 
- `ESPROTOCOL=https | http`

## Other Options

`-h|--help`
displays usage information for the script.

# Export Logs Python Script - Experimental

>Note: This script is experimental, and might be significantly changed, replaced, or removed in later releases. Feedback is welcomed about the functionality represented by this script, including requirements, usage scenarios, and required options. 

Similar to the bash script described above this python script can be used to collect a set of log messages and save them to this file. 

Required Depenencies:
* Python 3
* Opensearch library (`pip install opensearch-py`)

Usage from within Docker Container:
1. Build Docker Image:
* Make sure to copy auth file into `user_dir/`
2. Run with `--auth-file=/opt/v4m/user_dir/auth-file`:
* `docker run v4m python logging/bin/getlogs.py --auth-file=/opt/v4m/user_dir/auth-file`

This program generates OpenSearch DSL Queries from user specified parameters, and submits them to a database to retrieve logs. The flags below provide specifications for your Query, and can be placed in any order. 
    -Connection settings are required in order to run the program. You can create config files to autofill this using -cf, and call them using -af
    -The NAMESPACE*, POD*, CONTAINER*, LOGSOURCE* and LEVEL* options accept multiple, space-separated, values (e.g. --level INFO NONE). 
    -All Generated Program files are placed in the directory where the program is run.
    -Use -sq to save generated queries, -q to run saved queries, and -o to output results to a supported file-format.
    -Correct time format is Y-M-D H:M:S. Ex: 1999-02-07 10:00:00

optional arguments:
  -h, --help            show this help message and exit
  -n [NAMESPACE ...], --namespace [NAMESPACE ...]
                        
                        One or more Viya deployments/Kubernetes Namespace for which logs are sought
                        
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
                        
                        The maximum number of log messsages to return.
                        
  -q FILENAME.*, --query-file  FILENAME.*
                        
                        Name of file containing search query (Including filetype) at end. Program will submit query from file, ALL other query parmeters ignored. Supported filetypes: .txt, .json
                        
  -sh, --show-query     
                         Display example of actual query that will be submitted during execution.
                        
  -sq [FILENAME ...], --save-query [FILENAME ...]
                        
                         Specify a file name (WITHOUT filetype) in which to save the generated query. If no file is specified, the query will not be saved. Query is saved in JSON format. 
                        
  -o [FILENAME.* ...], --out-file [FILENAME.* ...]
                        
                        Name of file to write results to (default: [stdout]). Filetype can be included at the end, or specified using -format. Supported filetypes: .csv, .json, .txt
                        
  -fo {csv,json,txt}, --format {csv,json,txt}
                        
                         Specify the output format for the results file. Filename is taken from out-filename. Overwrites the filetype for out-filename. 
                        
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
                        
                        Username for connecting to OpenSearch/Kibana (default: $ESUSER)
                        
  -pw PASSWORD, --password PASSWORD
                        
                        Password for connecting to OpenSearch/Kibana  (default: $ESPASSWD)
                        
  -ho HOST, --host HOST
                        
                        Hostname for connection to OpenSearch/Kibana (default: $ESHOST)
                        
  -po PORT, --port PORT
                        
                        Port number for connection to OpenSearch/Kibana (default: $ESPORT)
                        
  -ss, --disable-ssl    
                         If this option is provided, SSL will not be used to connect to the database.
                        
  -af [FILENAME.* ...], --auth-file [FILENAME.* ...]
                        
                         The program will read the connection information from this file (include filetype).
                        
  -cf [FILENAME.* ...], --create-auth [FILENAME.* ...]
                        
                         Creates a template authentication file (include filetype) under the specified file name. Connection information can be entered here.
