#! /bin/bash

cd "$(dirname $BASH_SOURCE)/../.."
source logging/bin/common.sh

source logging/bin/apiaccess-include.sh
source logging/bin/secrets-include.sh
source logging/bin/rbac-include.sh

this_script=`basename "$0"`

# get admin credentials
export ES_ADMIN_USER=$(kubectl -n $LOG_NS get secret internal-user-admin -o=jsonpath="{.data.username}" |base64 --decode)
export ES_ADMIN_PASSWD=$(kubectl -n $LOG_NS get secret internal-user-admin -o=jsonpath="{.data.password}" |base64 --decode)

# Get Security API URL
get_sec_api_url

namespace=$1
tenant=$2

# Convert namespace and tenant to all lower-case
namespace=$(echo "$namespace"| tr '[:upper:]' '[:lower:]')
tenant=$(echo "$tenant"| tr '[:upper:]' '[:lower:]')


if [ -z "$namespace" ] && [ -z "$tenant" ]; then
   cluster="true"
elif [ -n "$tenant" ]; then
   nst="${namespace}_${tenant}"
else
   nst="$namespace"
fi



if [ "$cluster" == "true" ]; then
   grfds_user="V4M_ALL_grafana_ds"
else
   grfds_user="${nst}_grafana_ds"
fi

if user_exists "$grfds_user"; then
   log_verbose "Removing the existing [$grfds_user] utility account."
   delete_user $grfds_user
fi

grfds_passwd="$(randomPassword)"

log_info "Cluster: $cluster NS: $namespace T: $tenant NST: $nst PWD: $grfds_passwd"


if [ "$cluster" == "true" ]; then
   ./logging/bin/user.sh CREATE -ns _all_ -t _all_ -u $grfds_user -p "$grfds_passwd" -g
elif [ -z "$tenant" ]; then
   ./logging/bin/user.sh CREATE -ns $namespace  -u $grfds_user -p "$grfds_passwd" -g
else
   ./logging/bin/user.sh CREATE -ns $namespace -t $tenant -u $grfds_user -p "$grfds_passwd" -g
fi
