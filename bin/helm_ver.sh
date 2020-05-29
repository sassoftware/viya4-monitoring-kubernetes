#!/bin/bash

# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

if [ ! $(which helm) ]; then
  echo "helm not found on the current PATH"
  exit 1
fi

helmVer=$(helm version 2>/dev/null)
if [[ "$helmVer" =~ 'Version:"v3.' ]]; then
  HELM_VER_MAJOR=3
  HELM_VER_FULL=$(helm version --short)
elif [[ "$helmVer" =~ 'SemVer:"v2.' ]]; then
  HELM_VER_MAJOR=2
  HELM_VER_FULL=$(helm version --short --client --template '{{ .Client.SemVer }}')
  HELM_SERVER_VER_FULL=$(helm version --short --template '{{ .Server.SemVer }}')
else
  echo "Error: Unable to determine helm version from [$(which helm) -version]: [$helmVer]"
  exit 1
fi

export HELM_VER_MAJOR HELM_VER_FULL HELM_SERVER_VER_FULL
