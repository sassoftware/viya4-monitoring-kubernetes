#! /bin/bash

# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0


# This file is not marked as executable as it is intended to be sourced
# Current directory must be the root directory of the repo

function build_chart {

   chart_name=$1
   chart_file=$2

   baseDir=$(pwd)

   if [ ! -f "$TMP_DIR/$chart_file" ]; then
      cd $TMP_DIR

      #rm -rf $TMP_DIR/charts

      if [ ! -d "$TMP_DIR/charts" ]; then
         log_info "Cloning charts/stable repo"
         git clone https://github.com/helm/charts.git
      else
        log_debug "Directory [charts] already exists; no need to (re-)clone repo"
      fi

      #change into repo
      cd charts

      # build package
      log_info "Packaging Helm Chart for $chart_name"

      # change to chart directory
      cd stable/$chart_name
      helm package .

      # move .tgz file to $TMP_DIR
      mv $chart_file $TMP_DIR/$chart_file

      # return to working dir
      cd $baseDir

      # remove repo directories
      # rm -rf $TMP_DIR/charts
   else
      log_debug "Chart [$chart_name] appears to have been packaged already; using existing chart package [$chart_file]"
   fi
}
