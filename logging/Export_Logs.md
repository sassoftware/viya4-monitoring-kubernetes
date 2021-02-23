# Export Logs

There might be instances when you need to download a set of log messages, for 
example, so you can send them to SAS Technical Support. 

To download the log messages, run the `getlogs.sh` script. This is the syntax for the script:

`getlogs.sh -ns | -- namespace` *`namespace`* `[Query Parameters] [Time Period Parameters] [Output Parameters] [Connection Parameters]`

The *`namespace`* parameter is required, and 
specifies the Kubernetes namespace corresponding to the SAS Viya deployment
for which you want to obtain log messages.

## Query Parameters

The query parameters specify the source of the log messages.

`-po|--pod` *`pod_name`*
specifies the pod for which you want to obtain log messages

`-c|--container` *`container_name`*
specifies the container for which you want to obtain log messages

`-s|--logsource` *`log_source`*
specifies the log source for which you want to obtain log messages

`-l|--limit` *`max_messages`*
specifies the maximum number of messages that are returned. The default value is 10.

`--count_only`
specifies that only the number of messages (rather than the text of the messages) are 
returned that meet the specified criteria.

`-q|--query_file` *`query_filename`*
specifies a file that contains values for all of the query parameters. If this parameter 
is specified, all other query parameters are ignored.

## Time Period Parameters

The time period parameters specify the time period over which the log messages are returned.

`-s|--start` *`start_time`*
specifies the datetime value for the beginning of the period over which the log messages are returned. 
The default value is one hour from the current time.

`-e|--end` *`end_time`*
specifies the datetime value for the end of the period over which the log messages are returned. 
The default value is the current date and time.

`-t|--time` *`time_period`*
specifies the length of the time period over which log messages are returned. The default value is one hour.

## Output Parameters

The output parameters specify the format in which the log messages are returned.

`--out_vars` *`var1(,var2...varN)`*
specifies the fields that are included in the output. Specify the fields as a comma-separated list. The 
fields that are returned by default are `@timestamp`, `level`, `logsource`, `kube.namespace`, 
`kube.pod`, `kube.container`, and `message`.

`--format csv|json|raw`
specifies the format in which the log messages are returned. The default value is csv.

## Connection Parameters

The connection parameters specify the information needed to connect to Elasticsearch and Kibana.

`-u|--user` *`username`* 
specifies the user name to use to connect to Elasticsearch in order to return the log messages.

`-pw|--password` *`password`*
specifies the password in order to connect to Elasticsearch and return log messages.

`-h|--host` *`hostname`*
specifies the host name to use to connect to Elasticsearch.

`-po|--port` *`port_num`*
specifies the port number to use when connecting to Elasticsearch.

`--conn_file` *`connection_filename`*
specifies a file that contains values for all of the connection parameters. If this parameter 
is specified, all other connection parameters are ignored.

