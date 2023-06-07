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

function silly_ors {
   # this function parses the input,
   # a field name and a comma
   # separated list of values, and
   # returns a WHERE sub-clause of the form:
   #  and (field = value or field = value2)
   # This is needed to get around a bug
   # which makes the "in" operator NOT
   # usable in ODFE 1.13.x

   local value field orstr
   field=$1
   shift
   IFS=', ' read -a arr <<<"$@"
   echo -n " and ("
   for value in "${arr[@]}"
   do
      echo -n "$orstr $field = '$value'";
      orstr=" OR "
   done;
   echo -n ") "
}
function silly_ands {
   # this function parses the input,
   # a field name and a comma
   # separated list of values, and
   # returns a WHERE sub-clause of the form:
   #  and (field != value and field != value2)
   # This is needed to get around a bug
   # which makes the "in" operator NOT
   # usable in ODFE 1.13.x

   local value field andstr
   field=$1
   shift
   IFS=', ' read -a arr <<<"$@"
   echo -n " and ("
   for value in "${arr[@]}"
   do
      echo -n "$andstr $field != '$value'";
      andstr=" AND "
   done;
   echo -n ") "
}

default_maxrows=500
default_output_vars="@timestamp, level, logsource,kube.namespace as namespace, kube.pod as pod, kube.container as container, message"
valid_levels="PANIC,FATAL,ERROR,WARNING,INFO,DEBUG,NONE"

function show_usage {
   log_info  ""
   log_info  "***Experimental - This script may be removed or undergo significant changes in the future***"
   log_info  ""
   log_info  "Usage: $this_script [QUERY OPTIONS] [TIME PERIOD] [OUTPUT OPTIONS] [CONNECTION OPTIONS]"
   log_info  ""
   log_info  "Submits a query to OpenSearch for log messages meeting the specified criteria and directs results to stdout or specified file."
   log_info  "Results are returned in CSV (comma-separated value) format.  In most case, option values are expected to be a single value (exceptions noted below)."
   log_info  "NOTE: Connection information is required but may be provided via environment variables."
   log_info  ""
   log_info  "     ** Query Options **"
   log_info  "     -n,  --namespace         NAMESPACE - One or more SAS Viya deployments/Kubernetes Namespace for which logs are sought"
   log_info  "     -nx, --namespace-exclude NAMESPACE - One or more namespaces for which logs should be excluded from the output"
   log_info  "     -p,  --pod               POD       - One or more pods for which logs are sought"
   log_info  "     -px, --pod-exclude       POD       - One or more pods for which logs should be excluded from the output"
   log_info  "     -c,  --container         CONTAINER - One or more containers for which logs are sought"
   log_info  "     -cx, --container-exclude CONTAINER - One or more containers from which logs should be excluded from the output"
   log_info  "     -s,  --logsource         LOGSOURCE - One or more logsource for which logs are sought"
   log_info  "     -sx, --logsource-exclude LOGSOURCE - One or more logsource for which logs should be excluded from the output"
   log_info  "     -l,  --level             INFO|etc  - One or more message levels for which logs are sought."
   log_info  "                                          Valid values for message level: $valid_levels"
   log_info  "     -lx, --level-exclude     INFO|etc  - One or more message levels for which logs should be excluded from the output."
   log_info  '          NOTE: The NAMESPACE*, POD*, CONTAINER*, LOGSOURCE* and LEVEL* options accept multiple, comma-separated, values (e.g. --level "INFO, NONE")'
   log_info  ""
   log_info  '          --search            "joe smith"  - Word or phrase contained in log message.'
   log_info  ""
   log_info  "     -m,  --maxrows           integer   - The maximum number of log messsages to return (default: 20)"
   log_info  "          NOTE: If --out_file is also provided, default: $default_maxrows"
   log_info  ""
   log_info  "     -q,  --query-file        filename  - Name of file containing search query (ALL other query parmeters ignored)."
   log_info  ""
   log_info  "          --show-query                  - Display example of actual query that will be submitted during execution"
   log_info  "          NOTE: The full request for logs will be executed and any results will be returned."
   log_info  ""
   log_info  "     ** Output Options **"
#                        --fields is an currently an experimental/undocumented feature
#   log_info  "          --fields           'var1,var2' - List (comma-separated) of fields to include in output"
#   log_info  "                                           (default: '$default_output_vars')."
   log_info  "     -o,  --out-file          filename  - Name of file to write results to (default: [stdout]). If file exists, use --force to overwrite."
   log_info  "     -f,  --force                       - Overwrite the output file if it already exists."
   log_info  ""
   log_info  "     ** Date/Time Range Options **"
   log_info  "     --start                  datetime  - Datetime for start of period for which logs are sought (default: 1 hour ago)"
   log_info  "     --end                    datetime  - Datetime for end of period for which logs are sought (default: now)"
   log_info  '          NOTE: START and END values can be provided as dates or datetime values in the form "2021-03-17" or "2021-03-17T01:23" respectively.'
   log_info  "                Times are interpreted as server local time unless a timezone offset (e.g. -0400) or Z (indicating time is UTC/GMT) is included."
   log_info  "                Date values without a time value are interpreted as referring to midnight on that date."
   log_info  ""
   log_info  "     ** Connection Options **"
   log_info  '     -us, --user              USERNAME  - Username for connecting to OpenSearch/OpenSearch Dashboards (default: $ESUSER)'
   log_info  '     -pw, --password          PASSWORD  - Password for connecting to OpenSearch/OpenSearch Dashboards (default: $ESPASSWD)'
   log_info  '     -ho, --host              hostname  - Hostname for connection to OpenSearch/OpenSearch Dashboards (default: $ESHOST)'
   log_info  '     -po, --port              port_num  - Port number for connection to OpenSearch/OpenSearch Dashboards (default: $ESPORT)'
   log_info  "     -pr, --protocol          https     - Protocol (https|http) for connection to OpenSearch (default: https)"
   log_info  "          NOTE: Connection information can also be passed via environment vars (ESHOST, ESPORT, ESPROTOCOL, ESUSER and ESPASSWD)."
   log_info  ""
   log_info  "     ** Other Options **"
   log_info  "     -h,  --help                        - Display this usage information"
   echo ""
}

POS_PARMS=""
log_debug "Number of Input Parms: $# Input Parms: $@"

while (( "$#" )); do
  case "$1" in
    # basic query parms
    -n|--namespace)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        namespace=$2
        shift 2
      else
        log_error "Option [--namespace] has been specified but no value was provided." >&2
        show_usage
        exit 2
      fi
      ;;

    -nx|--namespace-exclude|-xn)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        namespace_exclude=$2
        shift 2
      else
        log_error "Option [--namespace-exclude (Namespaces to Exclude)] has been specified but no value was provided." >&2
        show_usage
        exit 2
      fi
      ;;


    -p|--pod)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        pod=$2
        shift 2
      else
        log_error "Option [--pod] has been specified but no value was provided." >&2
        show_usage
        exit 2
      fi
      ;;
    -px|--pod-exclude|-xp)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        pod_exclude=$2
        shift 2
      else
        log_error "Option [--pod-exclude (Pods to Exclude)] has been specified but no value was provided." >&2
        show_usage
        exit 2
      fi
      ;;
    -c|--container)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        container=$2
        shift 2
      else
        log_error "Option [--container] has been specified but no value was provided." >&2
        show_usage
        exit 2
      fi
      ;;
    -cx|--container-exclude|-xc)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        container_exclude=$2
        shift 2
      else
        log_error "Option [--container-exclude (Containers to exclude)] has been specified but no value was provided." >&2
        show_usage
        exit 2
      fi
      ;;
    -s|--logsource)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        logsource=$2
        shift 2
      else
        log_error "Option [--logsource] has been specified but no value was provided." >&2
        show_usage
        exit 2
      fi
      ;;
    -sx|--logsource-exclude|-xs)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        logsource_exclude=$2
        shift 2
      else
        log_error "Option [--logsource-exclude (logsources to exclude)] has been specified but no value was provided." >&2
        show_usage
        exit 2
      fi
      ;;
    --search)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        search_string=$2
        shift 2
      else
        log_error "Option [--search (search string)] has been specified but no value was provided." >&2
        show_usage
        exit 2
      fi
      ;;
    -l|--level)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        msglevel=$2
        shift 2
      else
        log_error "Option [--level (message level)] has been specified but no value was provided." >&2
        show_usage
        exit 2
      fi
      ;;
    -lx|--level-exclude|-xl)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        level_exclude=$2
        shift 2
      else
        log_error "Option [--level-exclude (message levels to exclude)] has been specified but no value was provided." >&2
        show_usage
        exit 2
      fi
      ;;
    -m|--max|--maxrows|--max-rows)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        maxrows=$2
        shift 2
      else
        log_error "Option [--maxrows (maximum number of rows returned)] has been specified but no value was provided." >&2
        show_usage
        exit 2
      fi
      ;;
    -q|--query-file)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        query_file=$2
        shift 2
      else
        log_error "Option [--query-file] has been specified but no value was provided." >&2
        show_usage
        exit 2
      fi
      ;;
    # datetime parms
    --start)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        start_dt=$2
        shift 2
      else
        log_error "Option [--start] has been specified but no value was provided." >&2
        show_usage
        exit 2
      fi
      ;;
    --end)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        end_dt=$2
        shift 2
      else
        log_error "Option [--end] has been specified but no value was provided." >&2
        show_usage
        exit 2
      fi
      ;;

    # output parms
    -o|--out-file)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        target_file=$2
        shift 2
      else
        log_error "Option [--out-file] has been specified but no value was provided." >&2
        show_usage
        exit 2
      fi
      ;;
    -f|--force)
      overwrite=true
      shift
      ;;
    --fields)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        output_vars=$2
        shift 2
      else
        log_error "Option [--fields] has been specified but no value was provided." >&2
        show_usage
        exit 2
      fi
      ;;

    # connection info parms
    -us|--user)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        username=$2
        shift 2
      else
        log_error "Option [--username] has been specified but no value was provided." >&2
        show_usage
      exit 2
      fi
      ;;
    -pw|--password)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        password=$2
        shift 2
      else
        log_error "Option [--password] has been specified but no value was provided." >&2
        show_usage
        exit 2
      fi
      ;;
    -ho|--host)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        host=$2
        shift 2
      else
        log_error "Option [--host] has been specified but no value was provided." >&2
        show_usage
        exit 2
      fi
      ;;
    -po|--port)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        port=$2
        shift 2
      else
        log_error "Option [--port] has been specified but no value was provided." >&2
        show_usage
        exit 2
      fi
      ;;
    -pr|--protocol)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        protocol=$2
        shift 2
      else
        log_error "Option [--protocol] has been specified but no value was provided." >&2
        show_usage
        exit 2
      fi
      ;;
    --show-query)
      showquery=true
      shift
      ;;
    -h|--help)
      show_usage=1
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

if [ "$show_usage" == "1" ]; then
   show_usage
   exit
fi

# No positional parameters are supported
if [ "$#" -ge 1 ]; then
    log_error "Unexpected additional options [$POS_PARMS] were found; exiting."
    show_usage
    exit 1
fi


# set default values
showquery=${showquery:-false}
overwrite=${overwrite:-false}
protocol=${protocol:-${ESPROTOCOL}}
host=${host:-${ESHOST}}
port=${port:-${ESPORT}}
username=${username:-${ESUSER}}
password=${password:-${ESPASSWD}}
format="csv"  # Only format supported at this time


# validate values
if [ ! -z "$query_file" ] && [ ! -f "$query_file" ]; then
   log_error "Specified query file [$query_file] does not exist; exiting"
   exit 1
fi

if [ ! -z "$target_file" ]; then

   dir=$(dirname $target_file)
   if [ ! -d "$dir" ]; then
      log_error "The directory [$dir] specified for the output file does not exist"
      exit 1
   fi

   if [ -f "$target_file" ] && [ "$overwrite" != "true" ]; then
      log_error "Specified output file [$target_file] already exists."
      log_error "Delete the file, use the --force option or specify an different output file and re-run this command."
      exit 1
   else
      echo -n "" > $target_file
   fi
fi

if [ ! -z "$maxrows" ] && [[ ! "$maxrows" =~ ^[0-9]+$ ]]; then
   log_error "The specified value for --maxrows option [$maxrows] is not a valid integer."
   exit 1
fi

if [ -z "$host" ]; then
   log_error "REQUIRED connection information [HOST] is missing; please provide it via the --host option or via the ESHOST environment variable."
   exit 1
fi

if [ -z "$port" ]; then
   log_error "REQUIRED connection information [PORT] is missing; please provide it via the --port option or via the ESPORT environment variable."
   exit 1
fi

if [ -z "$username" ]; then
   log_error "REQUIRED connection information [USER] is missing; please provide it via the --user option or via the ESUSER environment variable."
   exit 1
fi

if [ -z "$password" ]; then
   log_error "The REQUIRED field [PASSWORD] is missing; please provide it via the --password option or via the ESPASSWD environment variable."
   exit 1
fi

if [ -z "$protocol" ]; then
   protocol="https"
elif [ "$protocol" != "http" ] && [ "$protocol" != "https" ]; then
   log_error "An invalid value [$protocol] was provided for the --protocol option; allowed values are \"https\" or \"http\""
   exit 1
fi

log_debug "Connection options PROTOCOL: $protocol HOST: $host PORT: $port  USERNAME: $username"

# Validate Connection information
response=$(curl -m 60 -s -o /dev/null  -w "%{http_code}"  -XGET "$protocol://$host:$port/"  --user $username:$password -k)
rc=$?
if [[ $response != 2* ]]; then

   if [[ "$rc" == "28" ]]; then
      log_error "Unable to validate connection to OpenSearch within [60] seconds."
      exit 1
   elif [ "$response" == "401" ]; then
      log_error "Unable to validate connection credentials. [$response] rc:[$rc]"
      exit 1
   elif [ "$response" == "403" ]; then
      log_debug "Validation of connection information not completely successful; specified user may have limited permissions. [$response] rc:[$rc]"
   else
      log_error "Unable to validate connection to OpenSearch. [$response] rc:[$rc]"
      exit 1
   fi
else
   log_debug "Validation of connection information succeeded  [$response] rc:[$rc]"
fi

# TO DO: Validate msglevel?

if [ ! -z "$target_file" ]; then
   output_file_specified="true"
   maxrows=${maxrows:-$default_maxrows}
else
   target_file="$TMP_DIR/query_results.txt"
   output_file_specified="false"
   maxrows=${maxrows:-20}
fi

# Set default list of output variables
output_vars=${output_vars:-$default_output_vars}

if [[ ! -z "$query_file" ]]; then
   log_info "Submitting query from file [$query_file] for processing."
else

   # Date processing:
   #  if none provided, use last hour
   if [ -z "$end_dt" ]; then
      end_dt=$(date +"%Y-%m-%dT%H:%M:%S%z")
   fi

   if [ -z "$start_dt" ]; then
      start_dt=$(date -d "$end_dt -1 hour"  +"%Y-%m-%dT%H:%M:%S%z")
   fi

   # ensure local timezone is added
   start_tz=$(date -d "$start_dt" +"%Y-%m-%dT%H:%M:%S%z")
   end_tz=$(date -d "$end_dt" +"%Y-%m-%dT%H:%M:%S%z")

   # convert to UTC/GMT
   start_date=$(date -u -d "$start_tz" +"%Y-%m-%d %H:%M:%S")
   end_date=$(date -u -d "$end_tz" +"%Y-%m-%d %H:%M:%S")

   # format dates as epoch to allow validation/comparison
   start_date_epoch=$(date -d "$start_date" +"%s")
   end_date_epoch=$(date -d "$end_date" +"%s")

   log_debug "start_dt:$start_dt start_tz:$start_tz start_date:$start_date start_date_epoch:$start_date_epoch"  #REMOVE?

   # Validate provided date range
   if [[ "$end_date_epoch" -lt "$start_date_epoch" ]]; then
      log_error "The end date provided [$end_dt/$end_date] appears to before the start date provided [$start_dt/$start_date]."
      exit 2
   fi

   query_file="$TMP_DIR/query.json"

   #initialize query file
   echo -n "" > $query_file

   #start JSON
   echo -n '{"query":"' >> $query_file

   #build SELECT clause
   echo -n "select $output_vars " >> $query_file

   if [ "$OPS_INDEX" == "true" ]; then
      index_name="viya_ops-*";
   else
      index_name="viya_logs-*"
   fi

   echo -n " from $index_name "  >> $query_file

   #WHERE clauses
   echo  -n " where 1 = 1 " >> $query_file  # dummy always true

   if [ ! -z "$namespace" ];          then echo -n " $(silly_ors  kube.namespace $namespace) "          >> $query_file; fi;
   if [ ! -z "$namespace_exclude" ];  then echo -n " $(silly_ands kube.namespace $namespace_exclude) "  >> $query_file; fi;
   if [ ! -z "$logsource" ];          then echo -n " $(silly_ors  logsource      $logsource)"           >> $query_file; fi;
   if [ ! -z "$logsource_exclude" ];  then echo -n " $(silly_ands logsource      $logsource_exclude)"   >> $query_file; fi;
   if [ ! -z "$pod" ];                then echo -n " $(silly_ors  kube.pod       $pod)"                 >> $query_file; fi;
   if [ ! -z "$pod_exclude" ];        then echo -n " $(silly_ands kube.podt      $pod_exclude)"         >> $query_file; fi;
   if [ ! -z "$container" ];          then echo -n " $(silly_ors  kube.container $container)"           >> $query_file; fi;
   if [ ! -z "$container_exclude" ];  then echo -n " $(silly_ands kube.container $container_exclude)"   >> $query_file; fi;
   if [ ! -z "$msglevel" ];           then echo -n " $(silly_ors  level          $msglevel)"            >> $query_file; fi;
   if [ ! -z "$level_exclude" ];      then echo -n " $(silly_ands level          $level_exclude)"       >> $query_file; fi;

   if [ ! -z "$search_string" ];  then echo -n " and multi_match('$search_string')">> $query_file; fi;

   if [ ! -z "$start_date" ]; then echo -n " and @timestamp >= timestamp('$start_date')" >> $query_file; fi;
   if [ ! -z "$end_date" ];   then echo -n " and @timestamp <  timestamp('$end_date')"   >> $query_file; fi;

   echo -n " order by @timestamp DESC " >> $query_file;

   if [ ! -z "$maxrows" ];      then echo -n " limit $maxrows" >> $query_file ; fi;

   echo -n ';"}' >> $query_file  #close json
   echo '' >> $query_file
fi

if [ "$showquery" == "true" ]; then
   log_info "The following query will be submitted."
   cat $query_file
fi

maxtime=${ESQUERY_MAXTIME:-180}

total_lines=0

log_info "Search for matching log messages started... $(date)"

qresults_file="$TMP_DIR/query_results.txt"

# ES_PLUGINS_DIR is set in logging/common.sh
# but that file is NOT sourced by this script;
# so we are explicitly setting it here.
LOG_SEARCH_BACKEND="${LOG_SEARCH_BACKEND:-OPENSEARCH}"
if [ "$LOG_SEARCH_BACKEND" == "OPENSEARCH" ]; then
   ES_PLUGINS_DIR=_plugins
else
   ES_PLUGINS_DIR=_opendistro
fi

response=$(curl -m $maxtime -s  -o $qresults_file -w "%{http_code}"  -XPOST "$protocol://$host:$port/$ES_PLUGINS_DIR/_sql?format=$format" -H 'Content-Type: application/json' -d @$query_file  $output_txt  --user $username:$password -k)
rc=$?

log_debug "curl (query submission) command response: [$response] rc:[$rc]"

if [[ $response != 2* ]]; then

   if [[ "$rc" == "28" ]]; then
      log_warn "Query did not complete within the permitted time [$maxtime] seconds."
      log_warn "This may indicate you do not have the right permissions to access this data."
   elif [ "$response" == "000" ]; then
      log_error "The curl command failed while attempting to submit query; script exiting."
      exit 2
   else
      # IndexNotFoundException should return 404 but doesn't
      if [ $(grep -c "IndexNotFoundException" $qresults_file) -gt 0 ]; then
         log_debug "IndexNotFoundException found in query response"
         queryfailed="true"
      else
         # problem is something more than no index found, keep output to show user
         queryfailed="true"
         log_debug "A problem other than 'no index found' was encountered"  ##TO DO: DO WHAT HERE?
      fi # IndexNotFoundException
   fi
else   # handle 2** response
   lines_returned=$(cat $qresults_file|wc -l)
   queryfailed="false"
fi

log_debug "Approximately [$lines_returned] log messages found"

if [ "$queryfailed" == "true" ]; then
   log_warn "There were issues getting the requested log messages; the query returned an unexpected response code."
   log_warn "These unexpected response returned the following message(s):"

   cat  $qresults_file
else
   # query did not fail

   if [ $lines_returned -eq 0 ]; then
      log_info "No log messages meeting the specified criteria were found."
      exit 0
   else
      # at least one good response

      if [ "$output_file_specified" == "true" ]; then
         log_info "Output results (approx. $lines_returned) written to requested output file [$target_file]"
         tail -n +1 ${qresults_file} >> $target_file
      else
         tail -n +1 ${qresults_file}
         echo "" # add line break after any output
      fi
   fi
fi
