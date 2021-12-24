# cfn-security

> **Note:** as of `v2`, the cfn-security image is using AWS ECR for the image registry. cfn-security `v1` will remain on docker hub unchanged; however, the docker hub rate limits could impact utilization. It is recommended to move to `v2`.

A simple `GitHub Action` for AWS CloudFormation static code analysis to improve infrastructure-as-code security.

***The Action does not require AWS credentials!***

cfn-security supports the following linting and security tools:

- [cfn-lint](https://github.com/aws-cloudformation/cfn-python-lint) *a.k.a.* cfn-python-lint
- [cfn-nag](https://github.com/stelligent/cfn_nag)
- [checkov](https://github.com/bridgecrewio/checkov)

## Inputs

### `cloudformation_directory`

The directory of the repo to scan the cloudformation templates.

### `scanner`

The scanner used to run security test. Options are `cfn-lint`, `cfn-nag`, `checkov`, or `all`

## Usage

To get started simply add a workflow `.yml` file (name it whatever you would like) to your `.github/workflows` folder. [Refer to the documentation on workflow YAML syntax here.](https://help.github.com/en/articles/workflow-syntax-for-github-actions).

For examples GitHub Actions workflow files check out the [example workflow templates](https://github.com/grolston/cfn-security/tree/master/workflow-examples). If you still do not know where to start, just use the [all-security-scans.yml](workflow-examples/all-security-scans.yml) template which will create two security scan jobs. Update the template input vars as necessary.

## Example cfn-lint Test

The following example tests CloudFormation with cfn-lint:

```yaml
name: cfn-lint Scan

on: [push]

jobs:
  ## cfn-lint scan
  sast-cfn-lint:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - uses: grolston/cfn-security@v2
      with:
        cloudformation_directory: './cloudformation/' ## change to your template directory
        scanner: "cfn-lint"
```

The cfn-lint scan will result in a pipeline failure for any identified rule violations. To suppress cfn-lint rules within your cloudformation template you can add in cfn-lint `Metadata` to the impacted resource. Example:

```yaml
Resources:
  myInstance:
    Type: AWS::EC2::Instance
    Metadata:
      cfn-lint:
        config:
          ignore_checks:
            - E3030
    Properties:
      InstanceType: nt.x4superlarge
      ImageId: ami-abc1234
```

### Example cfn-nag Test

The following example tests CloudFormation with cfn-nag:

```yaml
name: cfn-nag Security Scan

on: [push]

jobs:
  ## cfn-nag security scan
  sast-cfn-nag:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - uses: grolston/cfn-security@v2
      with:
        cloudformation_directory: './cloudformation/' ## change to your template directory
        scanner: "cfn-nag"
```
The cfn-nag scan will result in a pipeline failure for any identified rule violations. To suppress cfn-nag rules within your cloudformation template you can add in cfn-nag `Metadata` to the impacted resource. Example:

```yaml
# Partial template
PublicAlbSecurityGroup:
  Properties:
    GroupDescription: 'Security group for a public Application Load Balancer'
    VpcId:
      Ref: vpc
  Type: AWS::EC2::SecurityGroup
  Metadata:
    cfn_nag:
      rules_to_suppress:
        - id: W9
          reason: "This is a public facing ELB and ingress from the internet should be permitted."
        - id: W2
          reason: "This is a public facing ELB and ingress from the internet should be permitted."
PublicAlbSecurityGroupHttpIngress:
  Properties:
    CidrIp: 0.0.0.0/0
    FromPort: 80
    GroupId:
      Ref: PublicAlbSecurityGroup
    IpProtocol: tcp
    ToPort: 80
  Type: AWS::EC2::SecurityGroupIngress
```

### Example checkov Test

The following example tests CloudFormation with checkov:

```yaml
name: checkov Security Scan

on: [push]

jobs:
  ## checkov security scan
  sast-checkov:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - uses: grolston/cfn-security@v2
      with:
        cloudformation_directory: './cloudformation/' ## change to your template directory
        scanner: "checkov"
```
The checkov scan will result in a pipeline failure for any identified rule violations. To suppress checkov rules within your cloudformation template place a `# checkov:skip=[Rule To Skip]` within the impacted resource. Example:

```yaml
Resources:
  MyDB:
    Type: 'AWS::RDS::DBInstance'
    # Test case for check skip via comment
    # checkov:skip=CKV_AWS_16:Ensure all data stored in the RDS is securely encrypted at rest
    Properties:
      DBName: 'mydb'
      DBInstanceClass: 'db.t3.micro'
      Engine: 'mysql'
      MasterUsername: 'master'
      MasterUserPassword: 'password'
```

> **Note:** it is possible to simple combine the two examples above into a single file which will run all tests as individual jobs. Reference [all-security-scans.yml](workflow-examples/all-security-scans.yml)

## License

This project is distributed under the [MIT license](LICENSE.md).
