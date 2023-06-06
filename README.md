# Wordpress setup in AWS

## References

Some references for setting up wordpress in AWS, and best practices.

- [AWS reference architecture](https://aws.amazon.com/quickstart/architecture/wordpress/)
- [AWS Wordpress best practices](https://aws.amazon.com/blogs/architecture/wordpress-best-practices-on-aws/)
- [AWS reference achitecture - github](https://github.com/aws-samples/aws-refarch-wordpress)
- [Running WordPress on ECS/Fargate/EFS](https://aws.amazon.com/blogs/containers/running-wordpress-amazon-ecs-fargate-ecs/) A cloudformation example.

## Phases

### Phase 1: Basic ✅

I'm going to start with a basic docker setup of wordpress locally. I'll use docker-compose to setup the wordpress and miria containers. Using the official wordpress and miria images from docker hub to start.

- miriadb
- wordpress
  - should learn what wordpress volumes are needed to be 'shared' between containers
  - setting up volume for entire wp dir is easiest for now

### Phase 2: terraform AWS ✅

I'll use terraform to setup the AWS infrastructure. I'll start with a basic VPC, public and private subnets, and a bastion host. I'll use the AWS reference architecture as a guide.

A basic terraform setup will be used, with a `main.tf` file for the main configuration, and a `variables.tf` file for the variables.

All inputs will be stored in a `main.auto.tfvars` file, which will be gitignored. See the `main.auto.tfvars.example` file for an example.

> Pre-requisites: create a ssh key pair using `ssh-keygen -f bastion.key`

- Create a VPC
- Create a public subnet
- Create a private subnet
- Create a bastion host (just in case 🤷‍♂️)
- Create RDS MiriaDB instance
  - allow ssh forwarding to connect to RDS

### Phase 3: Setup ECS ✅

- Create EFS volume (single for entire wordpress dir)
  - choosing bitnami image for wordpress because it uses seperate /bitnami
    folder allowing for a single volume mount to be used
- Create ECS cluster (fargate)
- Create ECS task definition
- Create ECS service
- Create ALB
  - just http for now
- Create memchased cluster

### Phase 4: Setup performance services

- Create Route53 record (bonus)
- Setup caching manually via UI
  - there is a permission issue on the W3-cache plugin
- Create CDN
- Tweak EFS settings for cost/performance
- Tweak ECS settings for cost/performance
