#! /bin/sh

# Copyright Ã‚Â© 2024, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

newFilename="${NEW_FILENAME:-v4m_fb.db}"
newDir="${NEW_DIR:-/var/log/v4m-fb-storage}"
oldFile="${OLD_FILE:-/var/log/sas_viya_flb.db}"
newFile="$newDir/$newFilename"

if [ ! -f "$newFile" ]; then
   echo "INFO No existing instance of [$newFile] found"
   if [ -f "$oldFile" ]; then
      echo "INFO Migrating [$oldFile] to [$newFile]"
      cp $oldFile $newFile
    else
       echo "INFO No previous instance found"
   fi
else
   echo "INFO An existing instance of [$newFile] found"
fi

chown -R 3301:3301 $newDir

