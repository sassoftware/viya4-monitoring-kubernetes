#!/bin/bash

export USER_DIR=$TEST_REPO/tests/monitoring/mon-user-dir3

source $V4M_REPO/monitoring/bin/common.sh

echo "MON_NS=$MON_NS"
echo "MON_TLS_ENABLE=$MON_TLS_ENABLE"
echo "TLS_ENABLE=$TLS_ENABLE"