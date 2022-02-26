# Overview
Starter repo for the AWS environment deployer

# Notes
- 3 repo's are required
  - starter repo (this) to bootstrap/install the env deploy (but not start)
  - repo that does the actual deployment of the env (mainly bash)
  - repo that contains the configuration of the env (mainly Cloudformation config)
- use AWS region us-east-2 (Ohio)
- maybe execute from cloud shell

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
