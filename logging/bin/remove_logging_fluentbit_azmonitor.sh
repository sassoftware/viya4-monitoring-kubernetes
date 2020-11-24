#! /bin/bash

# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname $BASH_SOURCE)/../.."
source logging/bin/common.sh

this_script=`basename "$0"`

log_debug "Script [$this_script] has started [$(date)]"

# DEPRECATION NOTICE
log_notice "* This script [remove_logging_fluentbit_azmonitor.sh] is deprecated and will be removed in the future. *"
log_notice "* Moving forward, please use the [remove_fluentbit_azmonitor.sh] script to remove Fluent Bit instead.  *"
echo ""

log_info  "Calling the [remove_fluentbit_azmonitor.sh] script..."

# Call replacement script
logging/bin/remove_fluentbit_azmonitor.sh


log_debug "Script [$this_script] has completed [$(date)]"
echo ""
