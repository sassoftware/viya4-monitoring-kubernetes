# Copyright © 2021, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

# This script is not intended to be run directly
# Assumes bin/common.sh has been sourced

if [ ! $(which oc) ]; then
  echo "OpenShift 'oc' not found on the current PATH"
  exit 1
fi

log_debug "oc version info:"
log_debug "$(oc version)"
