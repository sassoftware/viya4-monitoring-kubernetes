# Copyright Â© 2022, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

# This script is NOT intended to be run directly
# It is sourced (as needed) during the deployment of OpenSearch

function get_odfe_pvcs {
  local namespace role
  namespace=$1
  role=$2

  kubectl -n $namespace get pvc -l role=$role -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.spec.volumeName}{"\t"}{.spec.resources.requests.storage}{"\t"}{.spec.storageClassName}{"\n"}{end}' 
}

function patch_odfe_pvc {
   local somepvc newPVCName pvc pv size storageClass
   somepvc=$1
   newPVCName=$2

   pvcName=$(echo "$somepvc" | awk '{ print $1}')
   pvName=$(echo "$somepvc" | awk '{ print $2}')
   pvcSize=$(echo "$somepvc" | awk '{ print $3}')
   storageClass=$(echo "$somepvc" | awk '{ print $4}')

   log_debug "PVC: $pvcName PV:$pvName SIZE:$pvcSize StorageClass: $storageClass New PVC Name:$newPVCName"

   log_debug "Patching reclaimPolicy on PV [pvName:$pvName]";
   kubectl patch pv $pvName -p '{"spec":{"persistentVolumeReclaimPolicy":"Retain"}}';

   log_debug "Creating new PVC [$newPVCName]"
   printf "apiVersion: v1 \nkind: PersistentVolumeClaim \nmetadata:\n  name: $newPVCName\nspec:\n  accessModes:\n  - ReadWriteOnce\n  storageClassName: $storageClass\n  resources:\n    requests:\n      storage: $pvcSize\n  volumeName: $pvName" |kubectl -n $LOG_NS apply -f -

   # delete ODFE pvc
   log_debug "Deleting existing ODFE PVC [$pvcName]"
   kubectl -n $LOG_NS delete pvc $pvcName

   # remove link w/ODFE PVC from PV
   log_debug "Removing obsolete link between PVC [$pvcName] and PV [$pvName]"
   kubectl patch pv $pvName  --type json -p '[{"op": "remove", "path": "/spec/claimRef"}]'

   # link PV to new PVC
   log_debug "Explicitly linking PV [$pvName] to new PVC [$newPVCName]"
   kubectl patch pv $pvName -p '{"spec": {"claimRef": {"kind": "PersistentVolumeClaim", "namespace": "'$LOG_NS'", "name": "'$newPVCName'"}}}'

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


if [ "$LOG_DEBUG_ENABLE" == "true" ]; then
   log_debug "List of MASTER PVCs found"
   for (( i=0; i<${#odfe_master_pvcs[@]}; i++ )); do
      thispvc=(${odfe_master_pvcs[$i]})
      log_debug "\t $i $thispvc"
   done

   log_debug "List of DATA PVCs found"
   for (( i=0; i<${#odfe_data_pvcs[@]}; i++ )); do
      thispvc=(${odfe_data_pvcs[$i]})
      log_debug "\t $i $thispvc"
   done
fi


if [ "$odfe_master_pvc_count" -gt 0 ] && [ "$odfe_data_pvc_count" -eq 0 ]; then

   log_debug "Only ODFE 'master' PVCs detected"
   log_debug "The 'master' PVCs will be mapped to the primary OpenSearch PVCs"

   master_target="v4m-search-v4m-search-"  # map ODFE 'master' PVCs to primary OpenSearch PVCs
   deploy_temp_masters="false"             # do NOT deploy temporary 'master' nodes

elif [ "$odfe_master_pvc_count" -eq 1 ] && [ "$odfe_data_pvc_count" -eq 1 ]; then
   # min-logging sample configuration
   log_error "The current ODFE configuration (likely based on the min-logging sample) can NOT be migrated to OpenSearch"
   log_info "You may be able to redeploy using an earlier release of SAS Viya Monitoring for Kubernetes to restore the current ODFE."
   log_info "However, the underlying Open Distro for Elasticsearch technology is no longer actively maintained and doing so will make you vulnerable."
   log_info ""
   log_info "Or, you can re-run the deployment script and deploy an entirely new OpenSearch-based deployment of SAS Viya Monitoring for Kubernetes"
   log_info "You can delete the existing PVCs that cannot be migrated and free up storage space by submitting a command:"
   log_info "      kubectl -n $LOG_NS delete pvc -l 'app=v4m-es, release=odfe'  " 
   log_info "Note: any previously captured log messages will no longer be available."

   # Remove OpenSearch-specific configMap
   kubectl -n $LOG_NS delete configmap run-securityadmin.sh --ignore-not-found

   exit 1

elif [ "$odfe_master_pvc_count" -gt 0 ] && [ "$odfe_data_pvc_count" -gt 0 ]; then

   log_debug "A mix of ODFE 'master' and 'data' nodes detected."
   log_debug "The 'data' PVCs will be mapped to the primary OpenSearch PVCs and the 'master' PVCs to temporary PVCs to allow upgrade"

   data_target="v4m-search-v4m-search-"     # map ODFE 'data' PVCs to primary OpenSearch PVCs
   master_target="v4m-master-v4m-master-"   # map ODFE 'master' PVCs to temporary OpenSearch temp_master PVCs
   deploy_temp_masters="true"               # deploy temporary 'master' nodes

elif [ "$odfe_master_pvc_count" -eq 0 ] && [ "$odfe_data_pvc_count" -gt 0 ]; then

   log_debug "Only ODFE 'data' PVCs detected"
   log_debug "The 'data' PVCs will be mapped to the primary OpenSearch PVCs"

   master_target="v4m-search-v4m-search-"  # map ODFE 'master' PVCs to primary OpenSearch PVCs
   deploy_temp_masters="false"             # do NOT deploy temporary 'master' nodes

else
   log_warn "No existing ODFE PVCs detected; nothing to migrate."
   existingODFE=false
   existingSearch="false"
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

