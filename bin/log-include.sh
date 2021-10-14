# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

# Logging helper functions

colorEnable=${LOG_COLOR_ENABLE:-true}
levelEnable=${LOG_LEVEL_ENABLE:-true}
logDebug=${LOG_DEBUG_ENABLE:-false}
logVerbose=${LOG_VERBOSE_ENABLE:-true}

if [ "$logVerbose" != "true" ]; then
  exec >/dev/null
fi

function add_notice {
  echo "$*"  >> $TMP_DIR/notices.txt
}

function display_notices {
  if [ -f "$TMP_DIR/notices.txt" ]; then
     IFS=''
     cat $TMP_DIR/notices.txt | while read line || [[ -n "$line" ]];
     do
       log_notice "$line"
     done
 fi
}

function log_notice {
  if [ "$colorEnable" = "true" ]; then
    whiteb "${bluebg}$*"
  else
    echo $* >&3
  fi
}

function log_message {
    echo $*  >&3
}

function log_debug {
  if [ "$logDebug" = "true" ]; then
    if [ "$levelEnable" = "true" ]; then
        level="DEBUG "
    else
        level=""
    fi
    if [ "$colorEnable" = "true" ]; then
        echo -e "${whiteb}${level}${white}$*${end}" >&3
    else
        echo $* >&3
    fi
  fi
}

function log_info {
  if [ "$levelEnable" = "true" ]; then
    level="INFO "
  else
    level=""
  fi
  if [ "$colorEnable" = "true" ]; then
    echo -e "${greenb}${level}${whiteb}$*${end}" >&3
  else
    echo $* >&3
  fi
}

function log_verbose {
  if [ "$logVerbose" == "true" ]; then
		log_info $*
  fi
}

function log_warn {
  if [ "$levelEnable" = "true" ]; then
    level="WARN "
  else
    level=""
  fi
  if [ "$colorEnable" = "true" ]; then
    echo -e "${black}${yellowbg}${level}$*${end}" >&3
  else
    echo $* >&3
  fi
}

function log_error {
  if [ "$levelEnable" = "true" ]; then
    level="ERROR "
  else
    level=""
  fi
  if [ "$colorEnable" = "true" ]; then
    echo -e "${whiteb}${redbg}${level}$*${end}" >&3
  else
    echo $* >&3
  fi
}

export -f log_notice log_message log_debug log_info log_warn log_error add_notice display_notices log_verbose
export colorEnable levelEnable logDebug
