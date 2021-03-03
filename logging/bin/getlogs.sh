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

default_maxrows=500
default_output_vars="@timestamp, level, logsource, kube.namespace, kube.pod, kube.container, message"
VALID_LEVELS="PANIC,FATAL,ERROR,WARNING,INFO,DEBUG,NONE"

function show_usage {
   log_info  ""
   log_info  "Usage: $this_script [QUERY PARAMETERS] [TIME PERIOD] [OUTPUT PARAMETERS] [CONNECTION PARAMETERS]"
   log_info  ""
   log_info  "Submits a query to Elasticsearch for log messages meeting the specified criteria and directs results to stdout or specified file."
   log_info  "Results are returned in CSV (comma-separated value) format.  In most case, option values are expected to be a single value (exceptions noted below)."
   log_info  "NOTE: The NAMESPACE parameter (-n|--namespace) is required.   Connection information is also required but may be provided via environment variables."
   log_info  ""
   log_info  "     ** Query Options **"
   log_info  "     -n,  --namespace         NAMESPACE - (Required) The Viya deployment/Kubernetes Namespace for which logs are sought"
   log_info  ""
   log_info  "     -p,  --pod               POD       - One or more pods for which logs are sought"
   log_info  "     -px, --pod-exclude       POD       - One or more pods for which logs should be excluded from the output"
   log_info  "     -c,  --container         CONTAINER - One or more containers for which logs are sought"
   log_info  "     -cx, --container-exclude CONTAINER - One or more containers from which logs should be excluded from the output"
   log_info  "     -s,  --logsource         LOGSOURCE - One or more logsource for which logs are sought"
   log_info  "     -sx, --logsource-exclude LOGSOURCE - One or more logsource for which logs should be excluded from the output"
   log_info  "     -l,  --level             INFO|etc  - One or more message levels for which logs are sought."
   log_info  "                                          Valid values for message level: $VALID_LEVELS"
   log_info  "     -lx, --level-exclude     INFO|etc  - One or more message levels for which logs should be excluded from the output."
   log_info  '          NOTE: The POD*, CONTAINER*, LOGSOURCE* and LEVEL* parameters accept multiple, comma-separated, values (e.g. --level "INFO, NONE")'
   log_info  ""
   log_info  '          --search            "joe smith"  - Word or phrase contained in log message.'
   log_info  ""
   log_info  "     -m,  --maxrows           integer   - The maximum number of log messsages to return (default: 20)"
   log_info  "          NOTE: If --out_file is also provided, default: $default_maxrows"
   log_info  ""
   log_info  "     -q,  --query-file        filename  - Name of file containing search query (ALL other query parmeters ignored)."
   log_info  ""
   log_info  "     ** Output Options **"
   log_info  "          --fields           'var1,var2' - List (comma-separated) of fields to include in output"
   log_info  "                                           (default: '$default_output_vars')."
   log_info  "     -o,  --out-file          filename  - Name of file to write results to (default: [stdout]). If file exists, use --force to overwrite."
   log_info  "     -f,  --force                       - Overwrite the output file if it already exists."
   log_info  ""
   log_info  "     ** Date/Time Range Options **"
   log_info  "     -s,  --start             datetime  - Datetime for start of period for which logs are sought (default: 1 hour ago)"
   log_info  "     -e,  --end               datetime  - Datetime for end of period for which logs are sought (default: now)"
   log_info  '          NOTE: START and END values can be provided as dates or datetime values in the form "2021-03-17" or "2021-03-17T01:23" respectively.'
   log_info  "                Times are interpreted as server local time unless a timezone offset (e.g. -0400) or Z (indicating time is UTC/GMT) is included."
   log_info  "                Date values without a time value are interpreted as referring to midnight on that date."
   log_info  ""
   log_info  "     ** Connection Options **"
   log_info  '     -us, --user              USERNAME  - Username for connecting to Elasticsearch/Kibana (default: $ESUSER)'
   log_info  '     -pw, --password          PASSWORD  - Password for connecting to Elasticsearh/Kibana  (default: $ESPASSWD)'
   log_info  '     -ho, --host              hostname  - Hostname for connection to Elasticsearch/Kibana (default: $ESHOST)'
   log_info  '     -po, --port              port_num  - Port number for connection to Elasticsearch/Kibana (default: $ESPORT)'
   log_info  "          NOTE: Connection information can also be passed via environment vars (ESHOST, ESPORT, ESUSER and ESPASSWD)."
   log_info  ""
   log_info  "     ** Other Options **"
   log_info  "     -h,  --help                        - Display this usage information"
   log_info  "          --show-query                  - Display example of actual query that will be submitted during execution"
   log_info  "          NOTE: The full request for logs will be executed and any results will be returned."
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
        log_error "Parameter [--namespace] has been specified but no value was provided." >&2
        show_usage
        exit 2
      fi
      ;;
    -p|--pod)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        POD=$2
        shift 2
      else
        log_error "Parameter [--pod] has been specified but no value was provided." >&2
        show_usage
        exit 2
      fi
      ;;
    -px|--pod-exclude|-xp)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        POD_EXCLUDE=$2
        shift 2
      else
        log_error "Parameter [--pod-exclude (Pods to Exclude)] has been specified but no value was provided." >&2
        show_usage
        exit 2
      fi
      ;;
    -c|--container)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        CONTAINER=$2
        shift 2
      else
        log_error "Parameter [--container] has been specified but no value was provided." >&2
        show_usage
        exit 2
      fi
      ;;
    -cx|--container-exclude|-xc)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        CONTAINER_EXCLUDE=$2
        shift 2
      else
        log_error "Parameter [--container-exclude (Containers to exclude)] has been specified but no value was provided." >&2
        show_usage
        exit 2
      fi
      ;;
    -s|--logsource)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        LOGSOURCE=$2
        shift 2
      else
        log_error "Parameter [--logsource] has been specified but no value was provided." >&2
        show_usage
        exit 2
      fi
      ;;
    -sx|--logsource-exclude|-xs)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        LOGSOURCE_EXCLUDE=$2
        shift 2
      else
        log_error "Parameter [--logsource-exclude (logsources to exclude)] has been specified but no value was provided." >&2
        show_usage
        exit 2
      fi
      ;;
    --search)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        SEARCH_STRING=$2
        shift 2
      else
        log_error "Parameter [--search (search string)] has been specified but no value was provided." >&2
        show_usage
        exit 2
      fi
      ;;
    -l|--level)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        LEVEL=$2
        shift 2
      else
        log_error "Parameter [--level (message level)] has been specified but no value was provided." >&2
        show_usage
        exit 2
      fi
      ;;
    -lx|--level-exclude|-xl)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        LEVEL_EXCLUDE=$2
        shift 2
      else
        log_error "Parameter [--level-exclude (message levels to exclude)] has been specified but no value was provided." >&2
        show_usage
        exit 2
      fi
      ;;
    -m|--max|--maxrows|--max-rows)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        MAXROWS=$2
        shift 2
      else
        log_error "Parameter [--maxrows (maximum number of rows returned)] has been specified but no value was provided." >&2
        show_usage
        exit 2
      fi
      ;;
    -q|--query-file)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        QUERY_FILE=$2
        shift 2
      else
        log_error "Parameter [--query-file] has been specified but no value was provided." >&2
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
        log_error "Parameter [--start] has been specified but no value was provided." >&2
        show_usage
        exit 2
      fi
      ;;
    -e|--end)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        END=$2
        shift 2
      else
        log_error "Parameter [--end] has been specified but no value was provided." >&2
        show_usage
        exit 2
      fi
      ;;

    # output parms
    -o|--out-file)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        OUT_FILE=$2
        shift 2
      else
        log_error "Parameter [--out-file] has been specified but no value was provided." >&2
        show_usage
        exit 2
      fi
      ;;
    -f|--force)
      OVERWRITE=true
      shift
      ;;
    --fields)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        OUTPUT_VARS=$2
        shift 2
      else
        log_error "Parameter [--fields] has been specified but no value was provided." >&2
        show_usage
        exit 2
      fi
      ;;

    # connection info parms
    -us|--user)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        USERNAME=$2
        shift 2
      else
        log_error "Parameter [--username] has been specified but no value was provided." >&2
        show_usage
      exit 2
      fi
      ;;
    -pw|--password)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        PASSWORD=$2
        shift 2
      else
        log_error "Parameter [--password] has been specified but no value was provided." >&2
        show_usage
        exit 2
      fi
      ;;
    -ho|--host)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        HOST=$2
        shift 2
      else
        log_error "Parameter [--host] has been specified but no value was provided." >&2
        show_usage
        exit 2
      fi
      ;;
    -po|--port)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        PORT=$2
        shift 2
      else
        log_error "Parameter [--port] has been specified but no value was provided." >&2
        show_usage
        exit 2
      fi
      ;;
    # misc parms
    --show-query)
      SHOWQUERY=true
      shift
      ;;
    -h|--help)
      SHOW_USAGE=1
      shift
      ;;
    -*|--*=) # unsupported flags
      log_error "Unsupported flag $1" >&2
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
    log_error "Unexpected additional arguments [$POS_PARMS] were found; exiting."
    show_usage
    exit 1
fi

# set default values
SHOWQUERY=${SHOWQUERY:-false}
OVERWRITE=${OVERWRITE:-false}
HOST=${HOST:-${ESHOST}}
PORT=${PORT:-${ESPORT}}
USERNAME=${USERNAME:-${ESUSER}}
PASSWORD=${PASSWORD:-${ESPASSWD}}
FORMAT="csv"  # Only format supported at this time


# validate values
if [ ! -z "$QUERY_FILE" ] && [ ! -f "$QUERY_FILE" ]; then
   log_error "Specified query file [$QUERY_FILE] does not exist; exiting"
   exit 1
fi

if [ ! -z "$OUT_FILE" ]; then

   dir=$(dirname $OUT_FILE)
   if [ ! -d "$dir" ]; then
      log_error "The directory [$dir] specified for the output file does not exist"
      exit 1
   fi

   if [ -f "$OUT_FILE" ] && [ "$OVERWRITE" != "true" ]; then
      log_error "Specified output file [$OUT_FILE] already exists."
      log_error "Delete the file, use the --force option or specify an different output file and re-run this command."
      exit 1
   else
      echo -n "" > $OUT_FILE
   fi
fi

if [ ! -z "$MAXROWS" ] && [[ ! "$MAXROWS" =~ ^[0-9]+$ ]]; then
   log_error "The specified value for --maxrows parameter [$MAXROWS] is not a valid integer."
   exit 1
fi

if [ -z "$HOST" ]; then
   log_error "REQUIRED connection information [HOST] is missing; please provide it via the --host option or via the ESHOST environment variable."
   exit 1
fi

if [ -z "$PORT" ]; then
   log_error "REQUIRED connection information [PORT] is missing; please provide it via the --port option or via the ESPORT environment variable."
   exit 1
fi

if [ -z "$USERNAME" ]; then
   log_error "REQUIRED connection information [USER] is missing; please provide it via the --user option or via the ESUSER environment variable."
   exit 1
fi

if [ -z "$PASSWORD" ]; then
   log_error "The REQUIRED field [PASSWORD] is missing; please provide it via the --password option or via the ESPASSWD environment variable."
   exit 1
fi

# Validate Connection information
response=$(curl -m 60 -s -o /dev/null  -w "%{http_code}"  -XGET "https://$HOST:$PORT/"  --user $USERNAME:$PASSWORD -k)
rc=$?
if [[ $response != 2* ]]; then

   if [[ "$rc" == "28" ]]; then
      log_error "Unable to validate connection to Elasticsearch within [60] seconds."
      exit 1
   elif [ "$response" == "401" ]; then
      log_error "Unable to validate connection credentials. [$response] rc:[$rc]"
      exit 1
   elif [ "$response" == "403" ]; then
      log_debug "Validation of connection information not completely successful; specified user may have limited permissions. [$response] rc:[$rc]"
   else
      log_error "Unable to validate connection to Elasticsearch. [$response] rc:[$rc]"
      exit 1
   fi
else
   log_debug "Validation of connection information succeeded  [$response] rc:[$rc]"
fi


# TO DO: Validate LEVEL?

if [ ! -z "$OUT_FILE" ]; then
   output_file_specified="true"
   MAXROWS=${MAXROWS:-$default_maxrows}
else
   OUT_FILE="$TMP_DIR/query_results.txt"
   output_file_specified="false"
   MAXROWS=${MAXROWS:-20}
fi

# Set default list of output variables
OUTPUT_VARS=${OUTPUT_VARS:-$default_output_vars}

if [[ ! -z "$QUERY_FILE" ]]; then
   query_count=1
   log_info "Submitting query from file [$QUERY_FILE] for processing."
   listofqueries[0]=$QUERY_FILE
else
   query_max_days=100

   # Date processing:
   #  if none provided, use last hour
   END=${END:-$(date +"%Y-%m-%dT%H:%M:%S%z")}
   START=${START:-$(date -d "$END -1 hour"  +"%Y-%m-%dT%H:%M:%S%z")}

   # ensure local timezone is added
   start_tz=$(date -d "$START" +"%Y-%m-%dT%H:%M:%S%z")
   end_tz=$(date -d "$END" +"%Y-%m-%dT%H:%M:%S%z")

   # convert to UTC/GMT
   start_date=$(date -u -d "$start_tz" +"%Y-%m-%dT%H:%M:%SZ")
   end_date=$(date -u -d "$end_tz" +"%Y-%m-%dT%H:%M:%SZ")

   # format dates as epoch to allow validation/comparison
   start_date_epoch=$(date -d "$start_date" +"%s")
   end_date_epoch=$(date -d "$end_date" +"%s")

   # Validate provided date range
   if [[ "$end_date_epoch" -lt "$start_date_epoch" ]]; then
      log_error "The end date provided [$END/$end_date] appears to before the start date provided [$START/$start_date]."
      exit 2
   fi

   # Extract day and reformat to allow string comparison
   start_day=$(date -d "$start_date" +"%Y%m%d")
   end_day=$(date -d "$end_date" +"%Y%m%d")

   today=$(date +"%Y%m%d")

   if [[ "$end_day" -le "$today" ]]; then
      prevday="$end_day"
   else
      prevday="$today"
   fi

   query_count=0

   while [[ "$start_day" -le  "$prevday" ]]           # Loop in reverse data to get most recent data first
   do
      pdayfmt=$(date -d "$prevday" +"%Y-%m-%d")       # format used for index names
      listofdays[query_count]="$pdayfmt"              # add to list of dates

      prevday=$(date -d "$prevday - 1 day" +"%Y%m%d") # decrement by 1 day

      ((query_count++))
      if [[ $query_count -ge $query_max_days ]]; then
         log_error "Number of days requested exceeds expected maximum; your query will be limited to maximum [$query_max_days] days"
         break
      fi
   done
   log_debug "Query Count:$query_count  List of Days: ${listofdays[@]}"

   for ((i=0; i < $query_count; i++));
   do   # construct queries

      query_file="$TMP_DIR/query.$i.json"
      listofqueries[i]="$query_file"

      #initialize query file
      echo -n "" > $query_file

      #start JSON
      echo -n '{"query":"' >> $query_file

      #build SELECT clause
      echo -n "select $OUTPUT_VARS " >> $query_file

      if [ "$OPS_INDEX" == "true" ]; then
         index_date=$(date -d "$end_date"  +"%Y.%m.%d")  # TO DO: convert '-' to '.'
         index_name="viya_ops-$index_date";
      else
         # getting viya_logs
         if [ -z "$NAMESPACE" ]; then
            log_error "The REQUIRED field [NAMESPACE] has not been specified."
            exit 1
         fi

         index_name="viya_logs-$NAMESPACE-${listofdays[i]}";
      fi

      echo -n " from $index_name "  >> $query_file

      #WHERE clauses
      echo  -n " where 1 = 1 " >> $query_file  # dummy always true

      if [ ! -z "$NAMESPACE" ];  then echo -n ' and kube.namespace =\"'"$NAMESPACE"'\"' >> $query_file; fi;

      if [ ! -z "$LOGSOURCE" ];          then echo -n ' and logsource          in '"$(csvlist $LOGSOURCE)"         >> $query_file; fi;
      if [ ! -z "$LOGSOURCE_EXCLUDE" ];  then echo -n ' and logsource      NOT in '"$(csvlist $LOGSOURCE_EXCLUDE)" >> $query_file; fi;
      if [ ! -z "$POD" ];                then echo -n ' and kube.pod           in '"$(csvlist $POD)"               >> $query_file; fi;
      if [ ! -z "$POD_EXCLUDE" ];        then echo -n ' and kube.pod       NOT in '"$(csvlist $POD_EXCLUDE)"       >> $query_file; fi;
      if [ ! -z "$CONTAINER" ];          then echo -n ' and kube.container     in '"$(csvlist $CONTAINER)"         >> $query_file; fi;
      if [ ! -z "$CONTAINER_EXCLUDE" ];  then echo -n ' and kube.container NOT in '"$(csvlist $CONTAINER_EXCLUDE)" >> $query_file; fi;
      if [ ! -z "$LEVEL" ];              then echo -n ' and level              in '"$(csvlist $LEVEL)"             >> $query_file; fi;
      if [ ! -z "$LEVEL_EXCLUDE" ];      then echo -n ' and level          NOT in '"$(csvlist $LEVEL_EXCLUDE)"     >> $query_file; fi;

      if [ ! -z "$SEARCH_STRING" ];  then echo -n ' and multi_match(\"'"$SEARCH_STRING"'\")'>> $query_file; fi;

      if [ ! -z "$start_date" ]; then echo -n ' and @timestamp >=\"'"$start_date"'\"' >> $query_file; fi;
      if [ ! -z "$end_date" ];   then echo -n ' and @timestamp < \"'"$end_date"'\"'    >> $query_file; fi;

      echo "order by @timestamp DESC" >> $query_file;

      if [ ! -z "$MAXROWS" ];      then echo -n " limit $MAXROWS" >> $query_file ; fi;

      echo -n '"}'>> $query_file  #close json
      echo '' >> $query_file

   done # construct queries
fi

if [ "$SHOWQUERY" == "true" ]; then
   log_info "The following query is an example of the queries that will be submitted."
   log_info "More than one query may be submitted depending on the specified time range."
   cat ${listofqueries[0]}
fi

maxtime=${ESQUERY_MAXTIME:-180}

total_lines=0

log_info "Search for matching log messages started... $(date)"

for ((i=0; i < $query_count; i++));
do # submit queries

   query_file=${listofqueries[i]}
   out_file="$TMP_DIR/query_results.$i.txt"

   log_debug "Query [$(($i+1))] of [$query_count] $(date)"
   response=$(curl -m $maxtime -s  -o $out_file -w "%{http_code}"  -XPOST "https://$HOST:$PORT/_opendistro/_sql?format=$FORMAT" -H 'Content-Type: application/json' -d @$query_file  $output_txt  --user $USERNAME:$PASSWORD -k)
   rc=$?
   log_debug "curl command response: [$response] rc:[$rc]"


   if [[ $response != 2* ]]; then

      listofoutputs[i]="bad response"    # remove out_file from list of files to return to user

      if [[ "$rc" == "28" ]]; then
         log_warn "Query [$(($i+1))] did not complete within the permitted time [$maxtime] seconds."
         log_warn "This may indicate you do not have the right permissions to access this data.  Or, if you do have access, this may result in you having fewer results than you should."
      elif [ "$response" == "000" ]; then
         log_error "The curl command failed while attempting to submit query [$(($i+1))]; script exiting."
         exit 2
      else
         # IndexNotFoundException should return 404 but doesn't
         if [ $(grep -c "IndexNotFoundException" $out_file) -gt 0 ]; then
            log_debug "IndexNotFoundException found in file [$out_file]"
         else
            # problem is something more than no index found, keep output to show user
            listofbadouts+=("$out_file")
         fi # IndexNotFoundException
      fi  # handle non-200 responses
   else   # handle 2** response
      listofoutputs[i]="$out_file"

      lines_returned=$(cat $out_file|wc -l)
      lines_returned=$((lines_returned-1))  # ignore header line
      total_lines=$((total_lines+lines_returned));
      log_debug "Query [$(($i+1))] returned [$lines_returned] lines; total lines returned so far [$total_lines]."

      if [[ $total_lines -ge $MAXROWS ]]; then
         log_debug "Total number of lines returned [$lines_returned] is equal to or greater than the maximum requested (--maxrows) [$MAXROWS]; skipping remaining queries"
         query_count=$(($i+1));
         break
      fi
   fi
done  # submit queries

log_debug "Approximately [$total_lines] log messages found"

starting_row=1
for ((i=0; i < $query_count; i++));
do  # process output files

   if [ ${#listofbadouts[@]} -ge $query_count ]; then
      log_warn "None of the queries submitted to retrieve log messages completed successfully."
      log_warn "This may only mean there were no log messages collected during the specified time period; or"
      log_warn "this may indicate there were some other problems.  "
      log_warn "The responses received will be displayed below; review them to determine if there is a problem."
      break
   elif [ -z "${listofoutputs[i]}" ]; then
      continue
   elif [ "${listofoutputs[i]}" == "bad response" ];then
      log_debug "Output for query [$i] omitted since request exited with bad response code"
   elif [ "$output_file_specified" == "true" ]; then
      tail -n +$starting_row ${listofoutputs[i]} >> $OUT_FILE
      starting_row=2 # for subsequent files, skip first (header) row
   else
      tail -n +$starting_row ${listofoutputs[i]}
      starting_row=2 # for subsequent files, skip first (header) row
   fi

done # process output files

if [ ${#listofbadouts[@]} -gt 0 ]; then
   log_warn "There were issues getting the requested log messages; one or more queries returned an unexpected response code."
   log_warn "These unexpected responses returned the following message(s):"

   for file in ${listofbadouts[@]}
   do
      cat  $file
      echo ""
   done
fi

if [ $total_lines -eq 0 ]; then
   log_info "No log messages meeting the specified criteria were found."
   exit
else
   # at least one good response
   if [ "$output_file_specified" == "true" ]; then
      log_info "Output results (approx. $total_lines) written to requested output file [$OUT_FILE]"
   else
      echo "" # add line break after any output
   fi
fi
