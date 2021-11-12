#! /bin/bash

# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname $BASH_SOURCE)/../.."
source logging/bin/common.sh

set -e

export SVC=v4m-es-client-service

log_info "Removing NodePort for Elasticsearch instance [$SVC] in [$LOG_NS]"

if [[ $KUBE_SERVER_VER =~ v1.18 ]]; then
   kubectl -n "$LOG_NS" patch svc "$SVC" --type='json' -p '[{"op":"replace","path":"/spec/type","value":"ClusterIP"},{"op":"remove","path":"/spec/ports/0/nodePort"},{"op":"remove","path":"/spec/ports/1/nodePort"},{"op":"remove","path":"/spec/ports/2/nodePort"}]' 
elif [[ $KUBE_SERVER_VER =~ v1.19 ]]; then
   kubectl -n "$LOG_NS" patch svc "$SVC" --type='json' -p '[{"op":"replace","path":"/spec/type","value":"ClusterIP"},{"op":"remove","path":"/spec/ports/0/nodePort"},{"op":"remove","path":"/spec/ports/1/nodePort"},{"op":"remove","path":"/spec/ports/2/nodePort"},{"op":"remove","path":"/spec/ports/3/nodePort"}]' 
else
   kubectl -n "$LOG_NS" patch svc "$SVC" --type='json' -p '[{"op":"replace","path":"/spec/type","value":"ClusterIP"}]'
fi

