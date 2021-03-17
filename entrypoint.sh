#!/bin/sh

if [ -z "$INPUT_CLOUDFORMATION_DIRECTORY" ]; then
  echo "environment variable CLOUDFORMATION_DIRECTORY is not set. Quitting."
  exit 1
fi

if [ ! -d "$INPUT_CLOUDFORMATION_DIRECTORY" ]; then
  echo "${INPUT_CLOUDFORMATION_DIRECTORY} path not found. Quitting."
  exit 1
fi

if [ -z "$INPUT_SCANNER" ]; then
  echo "environment variable TEST is not set. Quitting."
  exit 1
fi

case $INPUT_SCANNER in

  "cfn-lint")
    echo -n "...scanning with only cfn-lint yaml files"
    sh -c 'cfn-lint ${INPUT_CLOUDFORMATION_DIRECTORY}*.yaml'
    echo -n "...scanning with only cfn-lint yml files"
    sh -c 'cfn-lint ${INPUT_CLOUDFORMATION_DIRECTORY}*.yml'
    echo -n "...scanning with only cfn-lint json files"
    sh -c 'cfn-lint ${INPUT_CLOUDFORMATION_DIRECTORY}*.json'
    ;;

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
    echo -n "...scanning with cfn-lint yaml files"
    sh -c "cfn-lint ${INPUT_CLOUDFORMATION_DIRECTORY}*.yaml"
    echo -n "...scanning with cfn-lint yml files"
    sh -c "cfn-lint ${INPUT_CLOUDFORMATION_DIRECTORY}*.yml"
    echo -n "...scanning with cfn-lint json files"
    sh -c "cfn-lint ${INPUT_CLOUDFORMATION_DIRECTORY}*.json"
    sh -c "cfn_nag_scan --input-path ${INPUT_CLOUDFORMATION_DIRECTORY} && checkov -d ${INPUT_CLOUDFORMATION_DIRECTORY}"
    ;;

  *)
    echo -n "unknown"
    exit 1
    ;;
esac
