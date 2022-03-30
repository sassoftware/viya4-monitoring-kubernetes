# Copyright Â© 2022, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

# This script is NOT intended to be run directly
# It is sourced (as needed) during the deployment of OpenSearch

function get_odfe_pvcs {
  local namespace role
  namespace=$1
  role=$2

  kubectl -n $namespace get pvc -l role=$role -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.spec.volumeName}{"\t"}{.spec.resources.requests.storage}{"\n"}{end}' 
}

function patch_odfe_pvc {
   local somepvc newPVCName pvc pv size
   somepvc=$1
   newPVCName=$2

   pvcName=$(echo "$somepvc" | awk '{ print $1}')
   pvName=$(echo "$somepvc" | awk '{ print $2}')
   pvcSize=$(echo "$somepvc" | awk '{ print $3}')

   echo "PVC: $pvcName PV:$pvName SIZE:$pvcSize New PVC Name:$newPVCName"

   log_debug "Patching reclaimPolicy on PV [pvName:$pvName]";
   kubectl patch pv $pvName -p '{"spec":{"persistentVolumeReclaimPolicy":"Retain"}}';

   log_debug "Creating new PVC [$newPVCName]"
   printf "apiVersion: v1 \nkind: PersistentVolumeClaim \nmetadata:\n  name: $newPVCName\nspec:\n  accessModes:\n  - ReadWriteOnce\n  resources:\n    requests:\n      storage: $pvcSize\n  volumeName: $pvName" |kubectl -n logging apply -f -

   # delete ODFE pvc
   log_debug "Deleting existing ODFE PVC [$pvcName]"
   kubectl -n $LOG_NS delete pvc $pvcName

   ## remove link w/ODFE PVC from PV
   # kubectl patch pv pvc-504a2370-19ea-4e1e-8769-f136b10ce383  --type json -p '[{"op": "remove", "path": "/spec/claimRef"}]'
   log_debug "Removing obsolete link between PVC [$pvcName] and PV [$pvName]"
   kubectl patch pv $pvName  --type json -p '[{"op": "remove", "path": "/spec/claimRef"}]'

   # new OpenSearch PVC already includes link to this PV, so they are immediately bound

   # Reset policy so PV is deleted when PVC is deleted
   log_debug "Resetting reclaimPolicy on PV [pvName:$pvName]";
   kubectl patch pv $pvName -p '{"spec":{"persistentVolumeReclaimPolicy":"Delete"}}';
}


# get list of existing ODFE 'master' pvcs
IFS=$'\n' odfe_master_pvcs=($(get_odfe_pvcs $LOG_NS master))
odfe_master_pvc_count=${#odfe_master_pvcs[@]}
log_debug "Detected [$odfe_master_pvc_count] PVCs associated with role [master]"

# get list of existing ODFE 'data' pvcs
IFS=$'\n' odfe_data_pvcs=($(get_odfe_pvcs $LOG_NS data))
odfe_data_pvc_count=${#odfe_data_pvcs[@]}
log_debug "Detected [$odfe_data_pvc_count] PVCs associated with role [data]"


####################################
### DEBUG CODE - START - REMOVE ####
echo "MASTER"
   for (( i=0; i<${#odfe_master_pvcs[@]}; i++ )); do
      thispvc=(${odfe_master_pvcs[$i]})
      echo "$i $thispvc"
   done

echo "DATA"
   for (( i=0; i<${#odfe_data_pvcs[@]}; i++ )); do
      thispvc=(${odfe_data_pvcs[$i]})
      echo "$i $thispvc"
   done
echo "$odfe_data_pvcs"
### DEBUG CODE - END  - REMOVE #####
####################################


if [ "$odfe_master_pvc_count" -gt 0 ] && [ "$odfe_data_pvc_count" -eq 0 ]; then

   log_debug "Only ODFE 'master' PVCs detected"
   log_debug "The 'master' PVCs will be mapped to the primary OpenSearch PVCs"

   master_target="v4m-es-v4m-es-"          # map ODFE 'master' PVCs to primary OpenSearch PVCs
   deploy_temp_masters="false"             # do NOT deploy temporary 'master' nodes

elif [ "$odfe_master_pvc_count" -gt 0 ] && [ "$odfe_data_pvc_count" -gt 0 ]; then

   log_debug "A mix of ODFE 'master' and 'data' nodes detected."
   log_debug "The 'data' PVCs will be mapped to the primary OpenSearch PVCs and the 'master' PVCs to temporary PVCs to allow upgrade"

   data_target="v4m-es-v4m-es-"             # map ODFE 'data' PVCs to primary OpenSearch PVCs
   master_target="v4m-master-v4m-master-"   # map ODFE 'master' PVCs to temporary OpenSearch temp_master PVCs
   deploy_temp_masters="true"               # deploy temporary 'master' nodes

elif [ "$odfe_master_pvc_count" -eq 0 ] && [ "$odfe_data_pvc_count" -gt 0 ]; then

   # LOGGING_MIN use-case?

   log_debug "Only ODFE 'data' PVCs detected"
   log_debug "The 'data' PVCs will be mapped to the primary OpenSearch PVCs"

   master_target="v4m-es-v4m-es-"          # map ODFE 'master' PVCs to primary OpenSearch PVCs
   deploy_temp_masters="false"             # do NOT deploy temporary 'master' nodes

else
   log_warn "No existing ODFE PVCs detected; nothing to migrate."
   #error and exit?
   #warn and remove ODFE=>OpenSearch migration flag?
fi

#Handle ODFE Master PVCs
if [ -n "$master_target" ]; then
   for (( i=0; i<${#odfe_master_pvcs[@]}; i++ )); do
      thispvc=(${odfe_master_pvcs[$i]})
      patch_odfe_pvc "$thispvc" "$master_target$i"
   done
else
   log_debug "Doing nothing with the existing ODFE 'master' PVCs"
fi

#Handle ODFE Data PVCs
if [ -n "$data_target" ]; then
   for (( i=0; i<${#odfe_data_pvcs[@]}; i++ )); do
      thispvc=(${odfe_data_pvcs[$i]})
      patch_odfe_pvc "$thispvc" "$data_target$i"
   done
else
   log_debug "Doing nothing with the existing ODFE 'data' PVCs"
fi

