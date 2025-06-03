#!/bin/bash

source $V4M_REPO/bin/colors-include.sh
source $V4M_REPO/bin/log-include.sh

export TMP_DIR=$(mktemp -d -t sas.mon.XXXXXXXX)
if [ ! -d "$TMP_DIR" ]; then
	log_error "Could not create temporary directory [$TMP_DIR]"
	exit 1
fi
log_debug "Temporary directory: [$TMP_DIR]"
echo "# This file intentionally empty" > $TMP_DIR/empty.yaml

# Delete the temp directory on exit
function cleanup {
	KEEP_TMP_DIR=${KEEP_TMP_DIR:-false}
	if [ "$KEEP_TMP_DIR" != "true" ]; then
	rm -rf "$TMP_DIR"
	log_debug "Deleted temporary directory: [$TMP_DIR]"
	else
	log_info "TMP_DIR [$TMP_DIR] was not removed"
	fi
}
trap cleanup EXIT

log_debug "SHOULD_NOT_BE_IN_OUTPUT"
log_info "INFO_1"
log_verbose "INFO_VERBOSE_1"
log_warn "WARN_1"
log_error "ERROR_1"
log_message "MESSAGE_1"

logDebug=true
log_debug "DEBUG_IS_ON"

logVerbose="false"
log_verbose "VERBOSE_SHOULD_BE_OFF"
logVerbose="${LOG_VERBOSE_ENABLE:-true}"

colorEnable=false
log_debug "DEBUG_COLOR_OFF"
log_info "INFO_COLOR_OFF"
log_warn "WARN_COLOR_OFF"
log_error "ERROR_COLOR_OFF"
log_message "MESSAGE_COLOR_OFF"

levelEnable=false
log_debug "DEBUG_2"
log_info "INFO_2"
log_info "WARN_2"
log_verbose "INFO_VERBOSE_2"
log_error "ERROR_2"
log_message "MESSAGE_2"

add_notice "NOTICE_1"
log_info "INFO_3"
add_notice "NOTICE_2"
log_info "INFO_4"
add_notice "NOTICE_3"
display_notices

logDebug=false