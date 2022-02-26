# Overview
Starter repo for the AWS environment deployer (https://github.com/leonjohan3/aws-deploy-env-starter.git)

# Notes
- 3 repo's are required
  - starter repo (this) to bootstrap/install the env deploy (but not start)
  - repo that does the actual deployment of the env (mainly bash)
  - repo that contains the configuration of the env (mainly Cloudformation config)
- use AWS region us-east-2 (Ohio)
- maybe execute from cloud shell
- to install venv `apt-get install python3.8-venv`
- to activate venv `python3 -m venv .venv` and `source .venv/bin/activate`
- to install jinja2-cli and cfn-lint on Ubuntu on venv: `pip3 install jinja2-cli` and `pip3 install cfn-lint`
- to run jinja2 `jinja2 --format json create-s3.tmpl create-s3.json`

# MVP
- deploy VPC (might include subnets)

# Final config
- VPC, subnets, 1 public, 2 private
- API Gateway
- Spring Boot app deployed to ECS fargate
- RDS postgress DB

# Resources
- [CloudFormation](<https://docs.aws.amazon.com/cloudformation/index.html>)
- [S3](<https://docs.aws.amazon.com/s3/index.html>)
- [VPC](<https://docs.aws.amazon.com/vpc/index.html>)
- [API Gateway](<https://docs.aws.amazon.com/apigateway/index.html>)
- [Cognito](<https://docs.aws.amazon.com/cognito/index.html>)
- [Make](<https://www.gnu.org/software/make/manual/html_node/index.html>)
- [VPC Private Link](<https://docs.aws.amazon.com/vpc/latest/privatelink/endpoint-services-overview.html>)
- [Jinja2 Templates](<https://jinja2docs.readthedocs.io/en/stable/templates.html>)
