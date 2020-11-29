#!/bin/sh

set -v

if [ -z "$INPUT_CLOUDFORMATION_DIRECTORY" ]; then
  echo "environment variable CLOUDFORMATION_DIRECTORY is not set. Quitting."
  exit 1
fi

if [ ! -d "$INPUT_CLOUDFORMATION_DIRECTORY" ]; then
  echo "${CLOUDFORMATION_DIRECTORY} path not found. Quitting."
  exit 1
fi

if [ -z "$INPUT_SCANNER" ]; then
  echo "environment variable TEST is not set. Quitting."
  exit 1
fi

case $INPUT_SCANNER in

  "cfn-nag")
    echo -n "...scanning with only cfn-nag"
    sh -c "cfn_nag_scan --input-path ${INPUT_CLOUDFORMATION_DIRECTORY}"
    ;;

  "checkov")
    echo -n "...scanning with only checkov"
    sh -c "checkov -d ${INPUT_CLOUDFORMATION_DIRECTORY}"
    ;;

  "all")
    echo -n "...scanning with all tools"
    sh -c "cfn_nag_scan --input-path ${INPUT_CLOUDFORMATION_DIRECTORY} && checkov -d ${INPUT_CLOUDFORMATION_DIRECTORY}"
    ;;

  *)
    echo -n "unknown"
    exit 1
    ;;
esac
