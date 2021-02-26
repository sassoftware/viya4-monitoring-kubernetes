#!/bin/bash


# Copyright © 20201, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0


cd "$(dirname $BASH_SOURCE)/../.."
CHECK_HELM=false
CHECK_KUBERNETES=false

# NOTE: sourcing top-level common.sh
#       NOT logging/bin/common.sh
source bin/common.sh

this_script=`basename "$0"`

default_output_vars="@timestamp, level, logsource, kube.namespace, kube.pod, kube.container, message"
VALID_OUTFMT="csv|json|jdbc|raw"
VALID_LEVELS="PANIC|FATAL|ERROR|WARNING|INFO|DEBUG|NONE"

function show_usage {
   log_info  ""
   log_info  "Usage: $this_script [QUERY PARAMETERS] [TIME PERIOD] [OUTPUT PARAMETERS] [CONNECTION PARAMETERS]"
   log_info  ""
   log_info  "Submits a query to Elasticsearch for log messages meeting the specified criteria and directs results to stdout or specified file."
   log_info  "By default, results are returned in CSV (comma-separated value) format.  In most case, parameters values are expected to be a single value."
   log_info  "NOTE: The NAMESPACE parameter (-ns|--namespace) is required."
   log_info  ""
   log_info  "     ** Query Parms **"
   log_info  "     -n,  --namespace         NAMESPACE - (Required) The Viya deployment/Kubernetes Namespace for which logs are sought"
   log_info  "     -p,  --pod               POD       - The pod(s) for which logs are sought"
   log_info  "     -px, --pod-exclude       POD       - The pod(s) for which logs should be excluded from the output"
   log_info  "     -c,  --container         CONTAINER - The container(s) for which logs are sought"
   log_info  "     -cx, --container-exclude CONTAINER - The container(s) from which logs should be excluded from the output"
   log_info  "     -s,  --logsource         LOGSOURCE - The logsource for which logs are sought"
   log_info  "     -sx, --logsource-exclude LOGSOURCE - The logsource for which logs should be excluded from the output"
   log_info  "     -l,  --level             INFO|etc  - The message level for which logs are sought. Valid values: $VALID_LEVELS"
   log_info  "     -lx, --level-exclude     INFO|etc  - The message level for which logs should be excluded from the output."
   log_info  "          --limit             integer   - The maximum number of log messsages to return (default: 10)"
   log_info  "          --count-only                  - Only return count of messages meeting criteria"
   log_info  "     -q,  --query-file        filename  - Name of file containing search query (all other query parms ignored)."
   log_info  '          NOTE: The POD, CONTAINER, LOGSOURCE and LEVEL parameters accept multiple, comma-separated, values (e.g. --level "INFO, NONE")'
   log_info  "     ** Output Info **"
   log_info  "          --out-vars          'var1,var2' - List (comma-separated) of fields to include in output (default: '$default_output_vars')."
   log_info  "          --format            csv|json|raw - Format of output (default: csv). Valid values: $VALID_OUTFMT"
   log_info  "     -o,  --out-file          filename  - Name of file to write results to (default: [stdout]). File should not exist already."
   log_info  "     ** Date/Time Range Info **"
   log_info  "     -s,  --start             datetime  - Datetime for start of period for which logs are sought (default: 1 hour ago)"
   log_info  "     -e,  --end               datetime  - Datetime for end of period for which logs are sought (default: now)"
#   log_info  "     -t,  --time             duration  - Length of time period for which logs are sought (default: -1 hour)"
   log_info  "     ** Connection Info **"
   log_info  '     -us, --user              USERNAME  - Username for connecting to Elasticsearch/Kibana (default: $ESUSER)'
   log_info  '     -pw, --password          PASSWORD  - Password for connecting to Elasticsearh/Kibana  (default: $ESPASSWD)'
   log_info  '     -ho, --host              hostname  - Hostname for connection to Elasticsearch/Kibana (default: $ESHOST)'
   log_info  '     -po, --port              port_num  - Port number for connection to Elasticsearch/Kibana (default: $ESPORT)'
   log_info  "          NOTE: Connection information can also be passed via environment vars (ESHOST, ESPORT, ESUSER and ESPASSWD)."
   log_info  "     ** Other **"
   log_info  "     -h,  --help                        - Display help information"
   log_info  "     -d,  --debug                       - Display additonal debug messages (inc. actual query submitted)  during execution"
   echo ""
}

POS_PARMS=""
log_debug "Number of Input Parms: $# Input Parms: $@"

while (( "$#" )); do
  case "$1" in
    # basic query parms
    -n|--namespace)
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
    -px|--pod-exclude|-xp)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        POD_EXCLUDE=$2
        shift 2
      else
        log_error "Error: A value for parameter [--pod-exclude (Pods to Exclude)] has not been provided." >&2
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
    -cx|--container-exclude|-xc)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        CONTAINER_EXCLUDE=$2
        shift 2
      else
        log_error "Error: A value for parameter [--container-exclude (Containers to exclude)] has not been provided." >&2
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
    -sx|--logsource-exclude|-xs)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        LOGSOURCE_EXCLUDE=$2
        shift 2
      else
        log_error "Error: A value for parameter [--logsource-exclude (Logsources to exclude)] has not been provided." >&2
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
    -lx|--level-exclude|-xl)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        LEVEL_EXCLUDE=$2
        shift 2
      else
        log_error "Error: A value for parameter [--level-exclude (message levels to exclude)] has not been provided." >&2
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
    --count-only)
      COUNTONLY_FLAG="true"
      shift
      ;;
    -q|--query-file)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        QUERY_FILE=$2
        shift 2
      else
        log_error "Error: A value for parameter [Query File] has not been provided." >&2
        show_usage
        exit 2
      fi
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
    -o|--out-file)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        OUT_FILE=$2
        shift 2
      else
        log_error "Error: A value for parameter [Output File] has not been provided." >&2
        show_usage
        exit 2
      fi
      ;;
    --out-vars)
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
    # misc parms
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

echo "GREG: $SHOW_USAGE"
if [ "$SHOW_USAGE" == "1" ]; then
   show_usage
   exit
fi

# No positional parameters are supported
if [ "$#" -ge 1 ]; then
    log_error "Unexpected additional arguments [$POS_PARMS] were found; exiting."
    show_usage
    exit 1
fi

# set default values
DEBUG=${DEBUG:-false}
HOST=${HOST:-${ESHOST}}
PORT=${PORT:-${ESPORT}}
USERNAME=${USERNAME:-${ESUSER}}
PASSWORD=${PASSWORD:-${ESPASSWD}}
LIMIT=${LIMIT:-10}
FORMAT=${FORMAT:-csv}


# validate values
if [ ! -z "$QUERY_FILE" ] && [ ! -f "$QUERY_FILE" ]; then
   log_error "Specified query file [$QUERY_FILE] does not exist; exiting"
   exit 1
fi

if [ ! -z "$OUT_FILE" ] && [ -f "$OUT_FILE" ]; then
   log_error "Specified output file [$OUT_FILE] already exists."
   log_error "Delete the file (or specify an different output file) and re-run this command."
   exit 1
fi

if [ ! -z "$LIMIT" ] && [[ ! "$LIMIT" =~ ^[0-9]+$ ]]; then
   log_error "The specified value for --limit parameter [$LIMIT] is not a valid integer."
   exit 1
fi

if [ -z "$HOST" ]; then
   log_error "The REQUIRED field [HOST] has not been specified."
   exit 1
fi

if [ -z "$PORT" ]; then
   log_error "The REQUIRED field [PORT] has not been specified."
   exit 1
fi



# TO DO: Validate LEVEL?
# TO DO: Validate OUT_FORMAT


if [ ! -z "$OUT_FILE" ]; then
   output_file_specified="true"
else
   OUT_FILE="$TMP_DIR/query_results.txt"
   output_file_specified="false"
fi

# Set default list of output variables
OUTPUT_VARS=${OUTPUT_VARS:-$default_output_vars}

#TO DO: Invert logic...
#       if NOT submitting a query file,
#          loop through days,creating a query file for each
#          add query_file name to an array of query_files to submit
#       if user provided a query file,
#          the query_files array has only a single element
#
#       Wrap curl command submission and output processing in a loop that loops through
#       the query_files array, submitting each in turn and appending the results to the target output file
#
#

# use QUERY_FILE
if [[ !  -z "$QUERY_FILE" ]]; then
   log_info "Submitting query from file [$QUERY_FILE] for processing."
   query_file=$QUERY_FILE
else

   # Date processing:
   #  if none provided, use last hour
   START=${START:-$(date -d '1 hour ago'  +"%Y-%m-%dT%H:%M:%SZ")}
   END=${END:-$(date +"%Y-%m-%dT%H:%M:%SZ")}

   # TO DO: Exit on invalid date values

   # ensure local timezone is added
   start_tz=$(date -d "$START" +"%Y-%m-%dT%H:%M:%S%Z")
   end_tz=$(date -d "$END" +"%Y-%m-%dT%H:%M:%S%Z")

   # convert to UTC/GMT
   start_date=$(date -u -d "$start_tz" +"%Y-%m-%dT%H:%M:%SZ")
   end_date=$(date -u -d "$end_tz" +"%Y-%m-%dT%H:%M:%SZ")


   query_file="$TMP_DIR/query.json"
   #initialize query file
   echo -n "" > $query_file

   #TODO: loop through days b/w start_date and end_date
   #      generate and submit query for each

   #start JSON
   echo -n '{"query":"' >> $query_file

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

      if [ -z "$NAMESPACE" ]; then
         log_error "The REQUIRED field [NAMESPACE] has not been specified."
         exit 1
      fi

      index_date=$(date -d "$end_date"  +"%Y-%m-%d")
      index_name="viya_logs-$NAMESPACE-$index_date";
   fi

   echo -n " from $index_name "  >> $query_file

   #WHERE clauses
   echo  -n " where 1 = 1 " >> $query_file  # dummy always true

   if [ ! -z "$NAMESPACE" ];  then echo -n ' and kube.namespace =\"'"$NAMESPACE"'\"' >> $query_file; fi;
#   if [ ! -z "$LOGSOURCE" ];  then echo -n ' and logsource =\"'"$LOGSOURCE"'\"' >> $query_file; fi;
#   if [ ! -z "$POD"       ];  then echo -n ' and kube.pod =\"'"$POD"'\"'              >> $query_file; fi;
#   if [ ! -z "$CONTAINER" ];  then echo -n ' and kube.container =\"'"$CONTAINER"'\"'>> $query_file; fi;
#   if [ ! -z "$LEVEL"     ];  then echo -n ' and level =\"'"$LEVEL"'\"'              >> $query_file; fi;

function csvlist {
   # this function parses the input
   # (a comma separated list of values)
   # and returns a comma separated
   # list of escaped quoted values
   # enclosed in parens.
   local rawvalue values outvalue
   rawvalue=$1
   IFS=, read -a arr <<<"$rawvalue"
   printf -v values ',\\"%s\\"' "${arr[@]}"
   outvalue="(${values:1})"
   echo "$outvalue"
}

   if [ ! -z "$LOGSOURCE" ];          then echo -n ' and logsource          in '"$(csvlist $LOGSOURCE)"         >> $query_file; fi;
   if [ ! -z "$LOGSOURCE_EXCLUDE" ];  then echo -n ' and logsource      NOT in '"$(csvlist $LOGSOURCE_EXCLUDE)" >> $query_file; fi;
   if [ ! -z "$POD" ];                then echo -n ' and kube.pod           in '"$(csvlist $POD)"               >> $query_file; fi;
   if [ ! -z "$POD_EXCLUDE" ];        then echo -n ' and kube.pod       NOT in '"$(csvlist $POD_EXCLUDE)"       >> $query_file; fi;
   if [ ! -z "$CONTAINER" ];          then echo -n ' and kube.container  in '"$(csvlist $CONTAINER)"            >> $query_file; fi;
   if [ ! -z "$CONTAINER_EXCLUDE" ];  then echo -n ' and kube.container NOT in '"$(csvlist $CONTAINER_EXCLUDE)" >> $query_file; fi;
   if [ ! -z "$LEVEL" ];              then echo -n ' and level              in '"$(csvlist $LEVEL)"             >> $query_file; fi;
   if [ ! -z "$LEVEL_EXCLUDE" ];      then echo -n ' and level          NOT in '"$(csvlist $LEVEL_EXCLUDE)"     >> $query_file; fi;

   if [ ! -z "$SEARCH_STRING" ];  then echo -n ' and multi_match(\"'"$SEARCH_STRING"'\")'>> $query_file; fi;

   if [ ! -z "$start_date" ]; then echo -n ' and @timestamp >=\"'"$start_date"'\"' >> $query_file; fi;
   if [ ! -z "$end_date" ];   then echo -n ' and @timestamp < \"'"$end_date"'\"'    >> $query_file; fi;

   echo "order by @timestamp DESC" >> $query_file; 

   if [ ! -z "$LIMIT" ];      then echo -n " limit $LIMIT" >> $query_file ; fi;

   echo -n '"}'>> $query_file  #close json
   echo '' >> $query_file

fi

if [ "$DEBUG" == "true" ]; then
   log_info "The following query will be submitted:"
   cat $query_file
fi

maxtime=${ESQUERY_MAXTIME:-180}

log_info "Submitting query now... $(date)"
response=$(curl -m $maxtime -s  -o $OUT_FILE -w "%{http_code}"  -XPOST "https://$HOST:$PORT/_opendistro/_sql?format=$FORMAT" -H 'Content-Type: application/json' -d @$query_file  $output_txt  --user $USERNAME:$PASSWORD -k)
log_debug "curl command response: [$response]"

if [[ "$response" == "000" ]]; then
   log_error "The request for log messages did not complete within the permitted time [$maxtime] seconds."
   log_error "If you provided an output destination, you may want check to see if partial results were returned."
   exit 1
elif [[ $response != 2* ]]; then
   log_error "There was an issue getting the requested log messages; the REST call returned an unexpected response code: [$response]."
   log_error "Response returned following message(s):"
   cat $OUT_FILE
   echo "" # add line break after any output
   exit 1
fi

if [ "$output_file_specified" == "true" ]; then
   log_info "Output results written to requested output file [$OUT_FILE]"
else
   cat $OUT_FILE
   echo "" # add line break after any output
fi
