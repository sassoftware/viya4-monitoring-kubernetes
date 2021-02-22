#!/bin/bash


# Copyright © 20201, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0


cd "$(dirname $BASH_SOURCE)/../.."
CHECK_HELM=false
CHECK_KUBERNETES=false
source logging/bin/common.sh
this_script=`basename "$0"`

default_output_vars="@timestamp, level, logsource, kube.namespace, kube.pod, kube.container, message"

function show_usage {
   log_info  ""
   log_info  "Usage: $this_script [QUERY PARAMETERS] [TIME PERIOD] [OUTPUT PARAMETERS] [CONNECTION PARAMETERS]"
   log_info  ""
   log_info  "Submits a query to Elasticsearch for log messages meeting the specified criteria and directs results to stdout or specified file."
   log_info  "By default, results are returned in CSV (comma-separated value) format.  In most case, parameters values are expected to be a single value."
   log_info  "NOTE: The NAMESPACE parameter (-ns|--namespace) is required."
   log_info  ""
   log_info  "     ** Query Parms **"
   log_info  "     -ns, --namespace   NAMESPACE - (Required) The Viya deployment/Kubernetes Namespace for which logs are sought"
   log_info  "     -p,  --pod         POD       - The pod for which logs are sought"
   log_info  "     -c,  --container   CONTAINER - The container for which logs are sought"
   log_info  "     -s,  --logsource   LOGSOURCE - The logsource for which logs are sought"
   log_info  "     -l,  --level       INFO|etc  - The message level for which logs are sought (default: _all_)"
   log_info  "          --limit       integer   - The maximum number of log messsages to return (default: 10)"
   log_info  "          --count_only            - Only return count of messages meeting criteria"
   log_info  "     -q,  --query_file  filename  - Name of file containing search query (all other query parms ignored)."
   log_info  "     ** Output Info **"
   log_info  "          --out_vars    'var1,var2' - List (comma-separated) of fields to include in output (default: '$default_output_vars')."
   log_info  "          --format      csv|json|raw - Format of output (default: csv)."
   log_info  "     -o,  --out_file    filename  - Name of file to write results to (default: [stdout])."
   log_info  "     ** Date/Time Range Info **"
   log_info  "     -s,  --start       datetime  - Datetime for start of period for which logs are sought (default: 1 hour ago)"
   log_info  "     -e,  --end         datetime  - Datetime for end of period for which logs are sought (default: now)"
   log_info  "     -t,  --time        duration  - Length of time period for which logs are sought (default: -1 hour)"
   log_info  "     ** Connection Info **"
   log_info  "     -u,  --user        USERNAME  - Username for connecting to Elasticsearch/Kibana"
   log_info  "     -pw, --password    PASSWORD  - Password for connecting to Elasticsearh/Kibana"
   log_info  "     -ho, --host        hostname  - Hostname for connection to Elasticsearch/Kibana"
   log_info  "     -po, --port        port_num  - Port number for connection to Elasticsearch/Kibana"
   log_info  "          --conn_file   filename  - Name of file containing connection information."
   log_info  "     ** Other **"
   log_info  "     -h,  --help                  - Display help information"
   log_info  "     -d,  --debug                 - Display additonal debug messages during execution"
   echo ""
}

POS_PARMS=""

while (( "$#" )); do
  case "$1" in
    # basic query parms
    -ns|--namespace)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        NAMESPACE=$2
        shift 2
      else
        log_error "Error: A value for parameter [Namespace] has not been provided." >&2
        show_usage
        exit 2
      fi
      ;;
    -p|--pod)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        POD=$2
        shift 2
      else
        log_error "Error: A value for parameter [Pod] has not been provided." >&2
        show_usage
        exit 2
      fi
      ;;
    -c|--container)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        CONTAINER=$2
        shift 2
      else
        log_error "Error: A value for parameter [Container] has not been provided." >&2
        show_usage
        exit 2
      fi
      ;;
    -s|--logsource)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        LOGSOURCE=$2
        shift 2
      else
        log_error "Error: A value for parameter [Logsource] has not been provided." >&2
        show_usage
        exit 2
      fi
      ;;
    --search)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        SEARCH_STRING=$2
        shift 2
      else
        log_error "Error: A value for parameter [Search] has not been provided." >&2
        show_usage
        exit 2
      fi
      ;;
    -l|--level)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        LEVEL=$2
        shift 2
      else
        log_error "Error: A value for parameter [Level] has not been provided." >&2
        show_usage
        exit 2
      fi
      ;;
    --limit)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        LIMIT=$2
        shift 2
      else
        log_error "Error: A value for parameter [Limit] has not been provided." >&2
        show_usage
        exit 2
      fi
      ;;
    --count_only)
      COUNTONLY_FLAG="true"
      shift
      ;;
    # datetime parms
    -s|--start)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        START=$2
        shift 2
      else
        log_error "Error: A value for parameter [Start] has not been provided." >&2
        show_usage
        exit 2
      fi
      ;;
    -e|--end)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        END=$2
        shift 2
      else
        log_error "Error: A value for parameter [End] has not been provided." >&2
        show_usage
        exit 2
      fi
      ;;
    -t|--time)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        TIME=$2
        shift 2
      else
        log_error "Error: A value for parameter [Time] has not been provided." >&2
        show_usage
        exit 2
      fi
      ;;

    # output parms
    -fo|--format)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        FORMAT=$2
        shift 2
      else
        log_error "Error: A value for parameter [Format] has not been provided." >&2
        show_usage
        exit 2
      fi
      ;;
    -o|--out_file)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        OUT_FILE=$2
        shift 2
      else
        log_error "Error: A value for parameter [Output File] has not been provided." >&2
        show_usage
        exit 2
      fi
      ;;
    --out_vars)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        OUTPUT_VARS=$2
        shift 2
      else
        log_error "Error: A value for parameter [Output variables] has not been provided." >&2
        show_usage
        exit 2
      fi
      ;;

    # connection info parms
    -u|--username)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        USERNAME=$2
        shift 2
      else
        log_error "Error: A value for parameter [Username] has not been provided." >&2
        show_usage
      exit 2
      fi
      ;;
    -pw|--password)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        PASSWORD=$2
        shift 2
      else
        log_error "Error: A value for parameter [Password] has not been provided." >&2
        show_usage
        exit 2
      fi
      ;;
    -ho|--host)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        HOST=$2
        shift 2
      else
        log_error "Error: A value for parameter [Host] has not been provided." >&2
        show_usage
        exit 2
      fi
      ;;
    -po|--port)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        PORT=$2
        shift 2
      else
        log_error "Error: A value for parameter [Port] has not been provided." >&2
        show_usage
        exit 2
      fi
      ;;
    --conn_file)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        CONN_FILE=$2
        shift 2
      else
        log_error "Error: A value for parameter [Connection File] has not been provided." >&2
        show_usage
        exit 2
      fi
      ;;

    # misc parms
    -q|--query_file)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        query_file=$2
        shift 2
      else
        log_error "Error: A value for parameter [Query File] has not been provided." >&2
        show_usage
        exit 2
      fi
      ;;
    -d|--debug)
      DEBUG=true
      shift
      ;;
    -h|--help)
      SHOW_USAGE=1
      shift
      ;;
    -*|--*=) # unsupported flags
      log_error "Error: Unsupported flag $1" >&2
      show_usage
      exit 2
      ;;
    *) # preserve positional arguments
      POS_PARMS="$POS_PARMS $1"
      shift
      ;;
  esac
done

# set positional arguments in their proper place
eval set -- "$POS_PARMS"


if [ "$SHOW_USAGE" == "1" ]; then
   show_usage
   exit
fi

# No positional parameters are supported
if [ "$#" -ge 1 ]; then
    log_error "Unexpected additional arguments were found; exiting."
    show_usage
    exit 1
fi


log_debug "POS_PARMS: $POS_PARMS"


log_debug "NAMESPACE: $NAMESPACE POD: $POD CONTAINER: $CONTAINER LIMIT: $LIMIT COUNTONLY_FLAG: $COUNTONLY_FLAG"
log_debug "QUERYFILE=$QUERY_FILE"
log_debug "USERNAME: $USERNAME PASSWORD: $PASSWORD"

DEBUG=${DEBUG:-false}
HOST=${HOST}
PORT=${PORT}
USER=${USERNAME}
PASSWORD=${PASSWORD}
LIMIT=${LIMIT:-10}
FORMAT=${FORMAT:-csv}

#default output to screen?
#OUT_FILE={$OUT_FILE:-mylogs.csv}
if [ ! -z "$OUT_FILE" ]; then
   output_txt="-s -o $OUT_FILE"
fi

# Date processing:
#  if none provided, use last hour
START=${START:-$(date -d '1 hour ago'  +"%Y-%m-%dT%H:%M:%SZ")}
END=${END:-$(date +"%Y-%m-%dT%H:%M:%SZ")}

# ensure local timezone is added
start_tz=$(date -d "$START" +"%Y-%m-%dT%H:%M:%S%Z")
end_tz=$(date -d "$END" +"%Y-%m-%dT%H:%M:%S%Z")

# convert to UTC/GMT
start_date=$(date -u -d "$start_tz" +"%Y-%m-%dT%H:%M:%SZ")
end_date=$(date -u -d "$end_tz" +"%Y-%m-%dT%H:%M:%SZ")



# Set default list of output variables
OUTPUT_VARS=${OUTPUT_VARS:-$default_output_vars}

#if LOGSOURCE then write LOGSOURCE clause to query file
# use QUERY_FILE
if [[ !  -z "$query_file" ]]; then
   log_info "Submitting query from file [$query_file] for processing."
else
   query_file="$TMP_DIR/query.json"

   #start JSON
   echo -n '{"query":"' > $query_file

   #build SELECT clause
   if [[ "$COUNTONLY_FLAG" == "true" ]]; then
      echo -n "select count(*) " >> $query_file
   else
      echo -n "select $OUTPUT_VARS " >> $query_file
   fi

   # TO DO: base index_date off of end_date
   # TO DO: if date range spans multiple days, need to loop
   if [ "$OPS_INDEX" == "true" ]; then
      index_date=$(date -d "$end_date"  +"%Y.%m.%d")
      index_name="viya_ops-$index_date";
   else
      index_date=$(date -d "$end_date"  +"%Y-%m-%d")
      index_name="viya_logs-$NAMESPACE-$index_date";
   fi

   echo -n " from $index_name "  >> $query_file

   #WHERE clauses
   echo  -n " where 1 = 1 " >> $query_file  # dummy always true

   if [ ! -z "$NAMESPACE" ];  then echo -n ' and kube.namespace =\"'"$NAMESPACE"'\"' >> $query_file; fi;
   if [ ! -z "$LOGSOURCE" ];  then echo -n ' and logsource =\"'"$LOGSOURCE"'\"' >> $query_file; fi;
   if [ ! -z "$POD"       ];  then echo -n ' and kube.pod =\"'"$POD"'\"'              >> $query_file; fi;
   if [ ! -z "$CONTAINER" ];  then echo -n ' and kube.container =\"'"$CONTAINERE"'\"'>> $query_file; fi;
   if [ ! -z "$LEVEL"     ];  then echo -n ' and level =\"'"$LEVEL"'\"'              >> $query_file; fi;

   if [ ! -z "$SEARCH_STRING" ];  then echo -n ' and multi_match(\"'"$SEARCH_STRING"'\")'>> $query_file; fi;

   if [ ! -z "$start_date" ]; then echo -n ' and @timestamp >=\"'"$start_date"'\"' >> $query_file; fi;
   if [ ! -z "$end_date" ];   then echo -n ' and @timestamp < \"'"$end_date"'\"'    >> $query_file; fi;

   #TO DO: Add support for search string

   echo "order by @timestamp DESC" >> $query_file; 

   if [ ! -z "$LIMIT" ];      then echo -n " limit $LIMIT" >> $query_file ; fi;

   echo -n '"}'>> $query_file  #close json
   echo '' >> $query_file

fi

if [ "$DEBUG" == "true" ]; then
   log_info "Query:"
   cat $query_file
fi

# curl -XPOST "https://myserver.example.com:30295/_opendistro/_sql?format=csv" \
#      -d '{"query": "select count(*)from viya_logs-d27885-2021-02-16 where logsource = \"database\"  and @timestamp between \"2021-02-16T01:00:00.000Z\" and \"2021-02-16T02:00:00.000Z\""}
#' -k --user admin:admin -H 'Content-Type: application/json'

 curl -XPOST "https://$HOST:$PORT/_opendistro/_sql?format=$FORMAT" \
      -H 'Content-Type: application/json' \
      -d @$query_file  $output_txt\
      --user $USERNAME:$PASSWORD -k

echo "" # add line break after any output



