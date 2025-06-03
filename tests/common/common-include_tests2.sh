#!/bin/bash

export USER_DIR=$TEST_REPO/tests/common/test-user-dir

cwd=$(pwd)
cd $V4M_REPO    #change dir so paths w/in common.sh resolve 
source bin/common.sh
cd $cwd

##disable colorized log messages to ensure
##assert statements in robot scripts match
LOG_COLOR_ENABLE=false

##Required: cleanup function *only* emits DEBUG message
LOG_DEBUG_ENABLE=true

# Force Exit-on-Error processing by
# submitting an obviously invalid command
set -e
kubectl get foo bar baz 2>/dev/null

