# cfn-security - all tools

A simple `GitHub Action` for AWS CloudFormation static code analysis to improve infrastructure-as-code security.

> **Note:** The `all-tools` branch supports cfn-guard which added some size to the docker image. Only use this branch if needing all tools.

***The Action does not require AWS credentials!***

## Inputs

### `cloudformation_directory`

The directory of the repo to scan the cloudformation templates.

### `scanner`

The scanner used to run security test. Options are `cfn-nag`, `cfn-guard`,  `checkov`, or `all`

## Usage

To get started simply add a workflow `.yml` file (name it whatever you would like) to your `.github/workflows` folder. [Refer to the documentation on workflow YAML syntax here.](https://help.github.com/en/articles/workflow-syntax-for-github-actions).

For examples GitHub Actions workflow files check out the [example workflow templates](https://github.com/grolston/cfn-security/tree/master/workflow-examples). If you still do not know where to start, just use the [all-security-scans.yml](workflow-examples/all-security-scans.yml) template which will create two security scan jobs. Update the template input vars as necessary.

### Example cfn-nag Test

The following example tests CloudFormation with cfn-nag:

```yaml
name: CFN-NAG Security Scan

on: [push]

jobs:
  ## cfn-nag security scan
  security-scan-nag:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - uses: grolston/cfn-security@all-tools
      with:
        cloudformation_directory: './cloudformation/' ## change to your template directory
        scanner: "cfn-nag"
```

### Example checkov Test

The following example tests CloudFormation with checkov:

```yaml
name: Checkov Security Scan

on: [push]

jobs:
  ## checkov security scan
  security-scan-checkov:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - uses: grolston/cfn-security@all-tools
      with:
        cloudformation_directory: './cloudformation/' ## change to your template directory
        scanner: "checkov"
```

### Example cfn-guard test

The following example tests CloudFormation

```yaml
name: Checkov Security Scan

on: [push]

jobs:
  ## checkov security scan
  security-scan-cfn-guard:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - uses: grolston/cfn-security@all-tools
      with:
        cloudformation_directory: './cloudformation/' ## change to your template directory
        scanner: "cfn-guard"
```

> **Note:** it is possible to simple combine the two examples above into a single file which will run all tests as individual jobs. Reference [all-security-scans.yml](workflow-examples/all-security-scans.yml)

## License

This project is distributed under the [MIT license](LICENSE.md).
