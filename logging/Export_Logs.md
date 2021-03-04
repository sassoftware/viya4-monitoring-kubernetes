# Export Logs

There might be instances when you need to collect a set of log messages in a file. For 
example, you might need to send log messages collected during a specific time period or for a specific pod to SAS Technical Support to help diagnose a problem. The `getlogs.sh` script enables you to obtain log messages from a specified time period and from specified sources and save those messages to a file.

To download the log messages, run the `getlogs.sh` script. This is the syntax for the script:

`getlogs.sh -ns | -- namespace` *`namespace`* `[Query Parameters] [Time Period Parameters] [Output Parameters] [Connection Parameters] [Other Options]`

The *`namespace`* parameter is required. This parameter specifies the Kubernetes namespace corresponding to the SAS Viya deployment for which you want to obtain log messages.

Each query is cancelled if it does not complete within three minutes. If the script generates multiple queries, each query must complete within three minutes.

For parameters than accept multiple values, the values must be in quotes and must be separated by commas. 

## Query Parameters

The query parameters specify the source of the log messages.

`-p|--pod` *`"pod_name[, pod_name]"`*
specifies the pod or pods for which you want to obtain log messages.

`-px|--pod-exclude` *`"pod_name[, pod_name]"`*
specifies the pod or pods that you want to exclude when obtaining log messages.

`-c|--container` *`"container_name[, container_name]"`*
specifies the container or containers for which you want to obtain log messages.

`-cx|--container-exclude` *`"container_name[, container_name]"`*
specifies the container or containers that you want to exclude when obtaining log messages.

`-s|--logsource` *`"log_source[, log_source]"`*
specifies the log source or sources for which you want to obtain log messages.

`-sx|--logsource-exclude` *`"log_source[, log_source]"`*
specifies the log source or sources that you want to exclude when obtaining log messages.

`-l|--level` *`"log_level[, log_level]"`*
specifies the level or levels of the log messages that you want to obtain. Valid values for 
*`"log_level"`* are PANIC,FATAL,ERROR,WARNING,INFO,DEBUG, and NONE.

`-lx|--level-exclude` *`"log_level[, log_level]"`*
specifies the level or levels of the log messages that you want to exclude from the messages that are obtained. Valid values for *`"log_level"`* are the same as for the `--level` option.

`--search` *`"search_text"`*
specifies that only messages containing the specified *`"search_text"`* are returned.

`-m|--maxrows` *`max_messages`*
specifies the maximum number of messages that are returned. The default value is 20. If the `--out-file` option is also specified, the default value is 500. If the commscriptand produces multiple queries, the value specified for `--maxrows` applies to each query. If the `--maxrows` value is reached before all queries have been submitted, the collected results are returned and the remaining queries are not run. For example, if you specify `--maxrows 100` and the script generates three queries, each query returns a maximum of 100 messages. If the first query returns 100 messages and the second query returns 90 messages, those 190 messages are returned and the third query does not run.

`-q|--query_file` *`query_filename`*
specifies a file that contains values for all of the query parameters. If this parameter 
is specified, all other query parameters are ignored.

## Time Period Parameters

The time period parameters specify the time period over which the log messages are returned.
You can specify *`start_time`* and *`end_time`* as either a date value (in the form "2021-03-17") or a datetime value (in the form "2021-03-17T01:23"). Times are assumed to be server local time unless you specify UTC time or a timezone offset. If you specify only a date value, the time is assumed to be midnight at the beginning of the specified date. If you specify only a time value, the date is assumed to be the current day. 

`-s|--start` *`start_time`*
specifies the datetime value for the beginning of the period over which the log messages are returned. The default value is one hour before the current time. 

`-e|--end` *`end_time`*
specifies the datetime value for the end of the period over which the log messages are returned. 
The default value is the current date and time.

## Output Parameters

The output parameters specify the format in which the log messages are returned.

`--out_vars` *`var1[,var2,...varN]`*
specifies the fields that are included in the output. Specify the fields as a comma-separated list. The 
fields that are returned by default are `@timestamp`, `level`, `logsource`, `kube.namespace`, 
`kube.pod`, `kube.container`, and `message`.

`-o|--out-file` *`output_filename`*
specifies a file to which the results are written. The default value is stdout. If the specified file exists, the script generates an error message and ends, unless you also specify the `--force` option.

`-f|--force`
overwrite the output file if it exists.

## Connection Parameters

The connection parameters specify the information needed to connect to Elasticsearch and Kibana.

If you are using ingress, the *`hostname`* and *`port_num`* are the host and port number for the ingress object.

If you are using nodeports, an administrator must run the `logging/bin/es_nodeport_enable.sh` 
script to enable HTTPS access to Elasticsearch and to obtain the host and port values. After this script is run, HTTPS access to Elasticsearch remains enabled until either the `logging/bin/es_nodeport_disable.sh` script is run or the logging components are redeployed.

`-us|--user` *`username`* 
specifies the user name to use to connect to Elasticsearch and Kibana in order to return the log messages.

`-pw|--password` *`password`*
specifies the password in order to connect to Elasticsearch and Kibana and return log messages.

`-h|--host` *`hostname`*
specifies the host name to use to connect to Elasticsearch and Kibana.

`-po|--port` *`port_num`*
specifies the port number to use when connecting to Elasticsearch and Kibana.

You can also specify these environment variables in order to provide connection information:
- `ESUSER=`*`username`*
- `ESPASSWD=`*`password`*
- `ESHOST=`*`hostname`*
- `ESPORT=`*`port_num`* 

## Other Options

`--show-query`
displays the query that is submitted to obtain log information. If the specified command generates multiple queries, only thr first query is displayed.

`-h|--help`
displays usage information for the script.

