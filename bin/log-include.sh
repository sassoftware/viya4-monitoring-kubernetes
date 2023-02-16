# Copyright © 2021, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

# Logging helper functions

LOG_COLOR_ENABLE=${LOG_COLOR_ENABLE:-true}
LOG_LEVEL_ENABLE=${LOG_LEVEL_ENABLE:-true}
LOG_DEBUG_ENABLE=${LOG_DEBUG_ENABLE:-false}
LOG_VERBOSE_ENABLE=${LOG_VERBOSE_ENABLE:-true}

# This must be run without 'set -e' being set
# So it has to be done up here and not within log_notice
if [ -z "$TERM" ] || ! tput cols >/dev/null 2>&1 ; then
  # Non-interactive shell
  LOG_COLOR_ENABLE=false
  noticeColWidth=${LOG_NOTICE_COL_WIDTH:-100}
else
  # Terminal width should be accessible
  noticeColWidth=${LOG_NOTICE_COL_WIDTH:-$(tput cols)}
  if [ "$noticeColWidth" == "" ]; then
    noticeColWidth=100
  fi
fi

if [ "$LOG_VERBOSE_ENABLE" != "true" ]; then
  # Send stdout to /dev/null
  # All non-error command output (kubectl, helm, etc.) will be suppressed
  # for non-verbose mode. log_* calls will funtion normally since they are
  # sent to &3, which is a copy of stdout
  exec 1>/dev/null
fi

function add_notice {
  echo $* >> $TMP_DIR/notices.txt
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
  width=$noticeColWidth
  n=$(($width - $(echo "$1" | wc -c)))
  if [ $n -lt 0 ]; then
     n=0
  fi
  # Fill remaining characters with spaces
  text="$*$(printf %$(eval 'echo $n')s |tr ' ' ' ')"

  if [ "$LOG_COLOR_ENABLE" = "true" ]; then
    whiteb "${bluebg}$text"
  else
    echo "$text" >&3
  fi
}

function log_message {
    echo "$*"  >&3
}

function log_debug {
  if [ "$LOG_DEBUG_ENABLE" = "true" ]; then
    if [ "$LOG_LEVEL_ENABLE" = "true" ]; then
        level="DEBUG "
    else
        level=""
    fi
    if [ "$LOG_COLOR_ENABLE" = "true" ]; then
        echo -e "${whiteb}${level}${white}$*${end}" >&3
    else
        echo "${level}$*" >&3
    fi
  fi
}

function log_info {
  if [ "$LOG_LEVEL_ENABLE" = "true" ]; then
    level="INFO "
  else
    level=""
  fi
  if [ "$LOG_COLOR_ENABLE" = "true" ]; then
    echo -e "${greenb}${level}${whiteb}$*${end}" >&3
  else
    echo "${level}$*" >&3
  fi
}

# Verbose messages are basically optional, more detailed INFO messages
# The value of LOG_VERBOSE_ENABLE determines whether they are displayed
function log_verbose {
  if [ "$LOG_VERBOSE_ENABLE" == "true" ]; then
		log_info $* >&3
  fi
}

function log_warn {
  if [ "$LOG_LEVEL_ENABLE" = "true" ]; then
    level="WARN "
  else
    level=""
  fi
  if [ "$LOG_COLOR_ENABLE" = "true" ]; then
    echo -e "${black}${yellowbg}${level}$*${end}" >&3
  else
    echo "${level}$*" >&3
  fi
}

function log_error {
  if [ "$LOG_LEVEL_ENABLE" = "true" ]; then
    level="ERROR "
  else
    level=""
  fi
  if [ "$LOG_COLOR_ENABLE" = "true" ]; then
    echo -e "${whiteb}${redbg}${level}$*${end}" >&3
  else
    echo "${level}$*" >&3
  fi
}

export -f log_notice log_message log_debug log_info log_warn log_error add_notice display_notices log_verbose
export LOG_COLOR_ENABLE LOG_LEVEL_ENABLE LOG_DEBUG_ENABLE noticeColWidth LOG_DEBUG_ENABLE
