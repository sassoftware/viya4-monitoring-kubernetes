# Copyright © 2025, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

# This file is not marked as executable as it is intended to be sourced
# Current directory must be the root directory of the repo


function checkYqVersion {
   # confirm yq installed and correct version
   local goodver yq_version
   goodver="yq \(.+mikefarah.+\) version (v)?(4\.(4[5-9]|[5-9][0-9])\..+)"
   yq_version=$(yq --version)
   if [ "$?" == "1" ]; then
      log_error "Required component [yq] not available."
      return 1
   elif [[ ! $yq_version =~ $goodver ]]; then
      log_error "Incorrect version [$yq_version] found; version 4.45.1+ required."
      return 1
   else
      log_debug "A valid version [$yq_version] of yq detected"
      return 0
   fi
}

export -f checkYqVersion

AUTOGENERATE_INGRESS="${AUTOGENERATE_INGRESS:-false}"

if [ "$AUTOGENERATE_INGRESS" != "true" ]; then
   log_debug "Autogeneration of ingresss definitions is NOT enabled"
   export AUTOINGRESS_SOURCED="NotNeeded"
fi

if [ -z "$AUTOINGRESS_SOURCED" ]; then

   checkYqVersion

   # Confirm NOT on OpenShift
   if [ "$OPENSHIFT_CLUSTER" == "true" ]; then
      log_warn "Setting AUTOGENERATE_INGRESS to 'true' is not valid on OpenShift clusters; ignoring option."
      log_warn "Web applications will be made accessible via OpenShift routes instead (if enabled)."
   fi

   #validate required inputs
   BASE_DOMAIN="${BASE_DOMAIN}"
   if [ -z "$BASE_DOMAIN" ]; then
      log_error "Required parameter [BASE_DOMAIN] not provided"
      exit
   fi

   ##TO DO: Validate various *FQDN env vars here?
   ##TO DO: Validate various *PATH env vars here?

   log_debug "Autogeneration of Ingress definitions has been enabled"

   routing="${ROUTING:-host}"

   #copy appropriate ingress sample into TMP_DIR
   mkdir $TMP_DIR/ingress
   cp -r samples/ingress/${routing}-based-ingress/* $TMP_DIR/ingress

   export AUTOINGRESS_SOURCED="true"

else
   log_debug "autoingress-include.sh was already sourced [$AUTOINGRESS_SOURCED]"
fi


function generateIngressPromOperator {

   if [ "$AUTOGENERATE_INGRESS" != "true" ]; then
      log_debug "Autogeneration of ingresss NOT enabled; exiting generateIngressPromOperator"
      return
   fi

   PROM_OPERATOR_INGRESS_YAML="$TMP_DIR/ingress/monitoring/user-values-prom-operator.yaml"

   ALERTMANAGER_INGRESS_ENABLED="${ALERTMANAGER_INGRESS_ENABLED:-false}"
   ALERTMANAGER_FQDN="${ALERTMANAGER_FQDN}"
   ALERTMANAGER_PATH="${ALERTMANAGER_PATH:-alertmanager}"
   if [ -z "$ALERTMANAGER_FQDN"  ]; then
      if [ "$routing" == "host" ]; then
         ALERTMANAGER_FQDN="$ALERTMANAGER_PATH.$BASE_DOMAIN"
      else
         ALERTMANAGER_FQDN="$BASE_DOMAIN/$ALERTMANAGER_PATH"
      fi
   fi

   GRAFANA_INGRESS_ENABLED="${GRAFANA_INGRESS_ENABLED:-true}"
   GRAFANA_FQDN="${GRAFANA_FQDN}"
   GRAFANA_PATH="${GRAFANA_PATH:-grafana}"
   if [ -z "$GRAFANA_FQDN" ]; then
      if [ "$routing" == "host" ]; then
         GRAFANA_FQDN="$GRAFANA_PATH.$BASE_DOMAIN"
      else
         GRAFANA_FQDN="$BASE_DOMAIN/$GRAFANA_PATH"
      fi
   fi

   PROMETHEUS_INGRESS_ENABLED="${PROMETHEUS_INGRESS_ENABLED:-false}"
   PROMETHEUS_FQDN="${PROMETHEUS_FQDN}"
   PROMETHEUS_PATH="${PROMETHEUS_PATH:-prometheus}"
   if [ -z "$PROMETHEUS_FQDN" ]; then
      if [ "$routing" == "host" ]; then
         PROMETHEUS_FQDN="$PROMETHEUS_PATH.$BASE_DOMAIN"
      else
         PROMETHEUS_FQDN="$BASE_DOMAIN/$PROMETHEUS_PATH"
      fi
   fi

   log_debug "ALERTMANAGER_INGRESS_ENABLED [$ALERTMANAGER_INGRESS_ENABLED] ALERTMANAGER_FQDN [$ALERTMANAGER_FQDN] ALERTMANAGER_PATH [$ALERTMANAGER_PATH]"
   log_debug "GRAFANA_INGRESS_ENABLED      [$GRAFANA_INGRESS_ENABLED]      GRAFANA_FQDN      [$GRAFANA_FQDN]      GRAFANA_PATH      [$GRAFANA_PATH]"
   log_debug "PROMETHEUS_INGRESS_ENABLED   [$PROMETHEUS_INGRESS_ENABLED]   PROMETHEUS_FQDN   [$PROMETHEUS_FQDN]   PROMETHEUS_PATH   [$PROMETHEUS_PATH]"

   export PROM_OPERATOR_INGRESS_YAML
   export ALERTMANAGER_INGRESS_ENABLED ALERTMANAGER_FQDN ALERTMANAGER_PATH
   export GRAFANA_INGRESS_ENABLED GRAFANA_FQDN GRAFANA_PATH
   export PROMETHEUS_INGRESS_ENABLED PROMETHEUS_FQDN PROMETHEUS_PATH

   ###enable/disable ingress for each app
   yq -i '.alertmanager.ingress.enabled=env(ALERTMANAGER_INGRESS_ENABLED)'    $PROM_OPERATOR_INGRESS_YAML
   yq -i '.grafana.ingress.enabled=env(GRAFANA_INGRESS_ENABLED)'              $PROM_OPERATOR_INGRESS_YAML
   yq -i '.prometheus.ingress.enabled=env(PROMETHEUS_INGRESS_ENABLED)'        $PROM_OPERATOR_INGRESS_YAML

   ###hosts, paths and fqdn
   if [ "$routing" == "host" ]; then
      yq -i '.alertmanager.ingress.hosts.[0]=env(ALERTMANAGER_FQDN)'          $PROM_OPERATOR_INGRESS_YAML
      yq -i '.alertmanager.ingress.tls.[0].hosts.[0]=env(ALERTMANAGER_FQDN)'  $PROM_OPERATOR_INGRESS_YAML
      exturl="https://$ALERTMANAGER_FQDN" yq -i '.alertmanager.alertmanagerSpec.externalUrl=env(exturl)'  $PROM_OPERATOR_INGRESS_YAML

      yq -i '.grafana.ingress.hosts.[0]=env(GRAFANA_FQDN)'                    $PROM_OPERATOR_INGRESS_YAML
      yq -i '.grafana.ingress.tls.[0].hosts.[0]=env(GRAFANA_FQDN)'            $PROM_OPERATOR_INGRESS_YAML
      yq -i '.grafana."grafana.ini".server.domain=env(BASE_DOMAIN)'           $PROM_OPERATOR_INGRESS_YAML
      rooturl="https://$GRAFANA_FQDN" yq -i '.grafana."grafana.ini".server.root_url=env(rooturl)'         $PROM_OPERATOR_INGRESS_YAML

      yq -i '.prometheus.ingress.hosts.[0]=env(PROMETHEUS_FQDN)'              $PROM_OPERATOR_INGRESS_YAML
      yq -i '.prometheus.ingress.tls.[0].hosts.[0]=env(PROMETHEUS_FQDN)'      $PROM_OPERATOR_INGRESS_YAML
      exturl="https://$PROMETHEUS_FQDN" yq -i '.prometheus.prometheusSpec.externalUrl=env(exturl)'        $PROM_OPERATOR_INGRESS_YAML
   else
      yq -i '.alertmanager.ingress.hosts.[0]=env(BASE_DOMAIN)'                $PROM_OPERATOR_INGRESS_YAML
      yq -i '.alertmanager.ingress.tls.[0].hosts=env(BASE_DOMAIN)'            $PROM_OPERATOR_INGRESS_YAML
      slashpath="/$ALERTMANAGER_PATH" yq -i '.alertmanager.ingress.path=env(slashpath)'                   $PROM_OPERATOR_INGRESS_YAML

      yq -i '.grafana.ingress.hosts.[0]=env(BASE_DOMAIN)'                     $PROM_OPERATOR_INGRESS_YAML
      yq -i '.grafana.ingress.tls.[0].hosts=env(BASE_DOMAIN)'                 $PROM_OPERATOR_INGRESS_YAML
      slashpath="/$GRAFANA_PATH" yq -i '.grafana.ingress.path=env(slashpath)' $PROM_OPERATOR_INGRESS_YAML

      yq -i '.prometheus.ingress.hosts.[0]=env(BASE_DOMAIN)'                  $PROM_OPERATOR_INGRESS_YAML
      yq -i '.prometheus.ingress.tls.[0].hosts=env(BASE_DOMAIN)'              $PROM_OPERATOR_INGRESS_YAML
      slashpath="/$PROMETHEUS_PATH" yq -i '.prometheus.ingress.path=env(slashpath)'                       $PROM_OPERATOR_INGRESS_YAML
   fi
}

function generateIngressOpenSearch {

   if [ "$AUTOGENERATE_INGRESS" != "true" ]; then
      log_debug "Autogeneration of ingresss NOT enabled; exiting generateIngressOpenSearch"
      return
   fi

   OPENSEARCH_INGRESS_YAML="$TMP_DIR/ingress/logging/user-values-opensearch.yaml"

   OPENSEARCH_INGRESS_ENABLED="${OPENSEARCH_INGRESS_ENABLED:-false}"
   OPENSEARCH_FQDN="${OPENSEARCH_FQDN}"     #TODO: NEEDED?
   OPENSEARCH_PATH="${OPENSEARCH_PATH:-search}"
   if [ -z "$OPENSEARCH_FQDN" ]; then
      if [ "$routing" == "host" ]; then
         OPENSEARCH_FQDN="$OPENSEARCH_PATH.$BASE_DOMAIN"
      else
         OPENSEARCH_FQDN="$BASE_DOMAIN/$OPENSEARCH_PATH"
      fi
   fi

   log_debug "OPENSEARCH_INGRESS_ENABLED [$OPENSEARCH_INGRESS_ENABLED] OPENSEARCH_FQDN [$OPENSEARCH_FQDN] OPENSEARCH_PATH [$OPENSEARCH_PATH]"

   export OPENSEARCH_INGRESS_YAML OPENSEARCH_INGRESS_ENABLED OPENSEARCH_FQDN OPENSEARCH_PATH

   yq -i '.ingress.enabled= env(OPENSEARCH_INGRESS_ENABLED)'             $OPENSEARCH_INGRESS_YAML

   if [ "$routing" == "host" ]; then
      yq -i '.ingress.hosts.[0]=env(OPENSEARCH_FQDN)'                    $OPENSEARCH_INGRESS_YAML
      yq -i '.ingress.tls.[0].hosts.[0]=env(OPENSEARCH_FQDN)'            $OPENSEARCH_INGRESS_YAML
   else
      slashpath="/$OPENSEARCH_PATH" yq -i '.ingress.path=env(slashpath)' $OPENSEARCH_INGRESS_YAML
      yq -i '.ingress.hosts.[0]=env(BASE_DOMAIN)'                        $OPENSEARCH_INGRESS_YAML

      yq -i '.ingress.tls.[0].hosts.[0]=env(BASE_DOMAIN)'                $OPENSEARCH_INGRESS_YAML
      slashpath="/$OPENSEARCH_PATH" yq -i '.ingress.annotations["nginx.ingress.kubernetes.io/rewrite-target"]=env(slashpath)' $OPENSEARCH_INGRESS_YAML

      # Need to use printf to preserve newlines
      printf -v snippet "rewrite (?i)/$OPENSEARCH_PATH/(.*) /\$1 break;\nrewrite (?i)/${OPENSEARCH_PATH}$ / break;"  ;
      snippet="$snippet"    yq -i '.ingress.annotations["nginx.ingress.kubernetes.io/configuration-snippet"]=strenv(snippet)'  $OPENSEARCH_INGRESS_YAML

   fi

}

function generateIngressOSD {

   if [ "$AUTOGENERATE_INGRESS" != "true" ]; then
      log_debug "Autogeneration of ingresss NOT enabled; exiting generateIngressOSD"
      return
   fi

   OSD_INGRESS_YAML="$TMP_DIR/ingress/logging/user-values-osd.yaml"

   OSD_INGRESS_ENABLED="${OSD_INGRESS_ENABLED:-true}"
   OSD_FQDN="${OSD_FQDN}"    #TODO: NEEDED?
   OSD_PATH="${OSD_PATH:-dashboards}"
   if [ -z "$OSD_FQDN" ]; then
      if [ "$routing" == "host" ]; then
         OSD_FQDN="$OSD_PATH.$BASE_DOMAIN"
      else
         OSD_FQDN="$BASE_DOMAIN/$OSD_PATH"
      fi
   fi

   log_debug "OSD_INGRESS_ENABLED [$OSD_INGRESS_ENABLED] OSD_FQDN [$OSD_FQDN] OSD_PATH [$OSD_PATH]"

   export OSD_INGRESS_YAML OSD_INGRESS_ENABLED OSD_FQDN OSD_PATH

   yq -i '.ingress.enabled=env(OSD_INGRESS_ENABLED)'           $OSD_INGRESS_YAML
   if [ "$routing" == "host" ]; then
      yq -i '.ingress.hosts.[0].host=env(OSD_FQDN)'            $OSD_INGRESS_YAML
      yq -i '.ingress.tls.[0].hosts.[0]=env(OSD_FQDN)'         $OSD_INGRESS_YAML
   else

      export slashpath="/$OSD_PATH"

      yq -i '(.extraEnvs.[] | select(has("name")) | select(.name == "SERVER_BASEPATH")).value=env(slashpath)' $OSD_INGRESS_YAML

      yq -i '.ingress.hosts.[0].host=env(BASE_DOMAIN)'         $OSD_INGRESS_YAML
      yq -i '.ingress.hosts.[0].paths.[0].path=env(slashpath)' $OSD_INGRESS_YAML
      yq -i '.ingress.tls.[0].hosts.[0]=env(BASE_DOMAIN)'      $OSD_INGRESS_YAML
      yq -i '.ingress.annotations["nginx.ingress.kubernetes.io/rewrite-target"]=env(slashpath)'               $OSD_INGRESS_YAML

      # Need to use printf to preserve newlines
      printf -v snippet "rewrite (?i)/$OSD_PATH/(.*) /\$1 break;\nrewrite (?i)/${OSD_PATH}$ / break;"  ;
      snippet="$snippet"    yq -i '.ingress.annotations["nginx.ingress.kubernetes.io/configuration-snippet"]=strenv(snippet)'  $OSD_INGRESS_YAML

      unset slashpath
   fi

}

export -f generateIngressPromOperator generateIngressOpenSearch generateIngressOSD

