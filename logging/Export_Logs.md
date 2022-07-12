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
script to enable HTTPS access to OpenSearch and to obtain the host and port values to use when specifying the connection options. See [Configure Access Via NodePorts](http://documentation.sas.com/doc/en/sasadmincdc/default/callogging/n0l4k3bz39cw2dn131zcbat7m4r1.htm). After this script is run, HTTPS access to OpenSearch remains enabled until one of the following occurs: 
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

