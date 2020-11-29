# cfn-security - GitHub Action

A simple GitHub Action for static code analysis of AWS CloudFormation to improve infrastructure as code security.

> **Note:** The Action *does not require* AWS credentials!

## Usage

### `securityscan.yml` Example

To get started you will more than likely want security scans to happen on all branches. Simply add `securityscan.yml` file (or whatever you would like to name it in your `.github/workflows` folder. [Refer to the documentation on workflow YAML syntax here.](https://help.github.com/en/articles/workflow-syntax-for-github-actions)

#### Example cfn-nag Test

The following example tests CloudFormation with cfn-nag:

```yaml
name: Security Scan

on: [push]

jobs:
  security-scan-nag:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v1
    - uses: grolston/cfn-security@master
      env:
        CLOUDFORMATION_DIRECTORY: "./cloudformation/"
        TEST: "cfn-nag"
```

#### Example checkov Test

The following example tests CloudFormation with checkov:

```yaml
name: Security Scan

on: [push]

jobs:
  security-scan-checkov:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v1
    - uses: grolston/cfn-security@master
      env:
        CLOUDFORMATION_DIRECTORY: "./cloudformation/"
        TEST: "checkov"
```

#### Example all Tests

The following example tests CloudFormation with all scanning tools.

> **Note:** it is possible to simple combine the two examples above into a single file which will run all tests as individual jobs.

The following runs all tests within one job:

```yaml
name: Security Scan

on: [push]

jobs:
  security-scan-all:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v1
    - uses: grolston/cfn-security@master
      env:
        CLOUDFORMATION_DIRECTORY: "./cloudformation/"
        TEST: "all"
```

### Configuration

The following settings must be passed as environment variables as shown in the example. Sensitive information should be [set as encrypted secrets](https://help.github.com/en/articles/virtual-environments-for-github-actions#creating-and-using-secrets-encrypted-variables) — otherwise, they'll be public to anyone browsing your repository's source code and CI logs.

> **Disclaimer:** No sensitive information is needed to conduct testing.

| Env Variable | Description| Suggested Type | Required | Default |
| ------------- | ------------- | ------------- | ------------- | ------------- |
| `CLOUDFORMATION_DIRECTORY` | Directory within your git repository which contains cloudformation templates files | `./cloudformation` | **Yes** | N/A |
| `TEST` | The security test to perform | `cfn-nag` , `checkov`, `all` | **Yes** | N/A |

## License

This project is distributed under the [MIT license](LICENSE.md).
