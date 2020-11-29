#!/bin/sh

set -v

if [ -z "$CLOUDFORMATION_DIRECTORY" ]; then
  echo "environment variable CLOUDFORMATION_DIRECTORY is not set. Quitting."
  exit 1
fi

if [ ! -d "$CLOUDFORMATION_DIRECTORY" ]; then
  echo "${CLOUDFORMATION_DIRECTORY} path not found. Quitting."
  exit 1
fi

if [ -z "$TEST" ]; then
  echo "environment variable TEST is not set. Quitting."
  exit 1
fi

case $TEST in

  "cfn-nag")
    echo -n "...scanning with only cfn-nag"
    sh -c "cfn_nag_scan --input-path ${CLOUDFORMATION_DIRECTORY}"
    ;;

  "checkov")
    echo -n "...scanning with only checkov"
    sh -c "checkov -d ${CLOUDFORMATION_DIRECTORY}"
    ;;

  "all")
    echo -n "...scanning with all tools"
    sh -c "cfn_nag_scan --input-path ${CLOUDFORMATION_DIRECTORY} && checkov -d ${CLOUDFORMATION_DIRECTORY}"
    ;;

  *)
    echo -n "unknown"
    exit 1
    ;;
esac
