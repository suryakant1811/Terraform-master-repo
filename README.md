# Reusable AWS Terraform modules

This repository contains reusable Terraform child modules. Keep AWS credentials,
provider configuration, remote state, and environment-specific values in the
separate infrastructure repository that consumes these modules.

## Repository structure

```text
.
├── aws-vpc/                 # VPC, subnets, routes, internet/NAT gateways
├── aws-rds/                 # RDS instance, subnet group, security group
├── aws-ecr/                 # Multiple ECR repositories
├── aws-eks/                 # EKS cluster, managed nodes, IAM roles
├── aws-ec2/                 # EC2 instance and optional security group
└── examples/
    └── production/          # Root-module example that connects everything
```

The `aws-ec2` module is available for future standalone EC2 workloads. It is
not called by the production example because the original configuration did
not contain an independent EC2 instance. EKS-managed workers remain in
`aws-eks`.

## How values flow

Terraform does not automatically fetch values from a "master variable file."
The consuming repository declares root variables, loads values from its own
`terraform.tfvars`, passes those values to modules, and passes module outputs to
other modules:

```text
consumer terraform.tfvars
        ↓
consumer root variables
        ↓
module inputs
        ↓
module resources and outputs
        ↓
inputs of dependent modules
```

For example, the root module passes `module.vpc.vpc_id` and
`module.vpc.private_subnet_ids` to the RDS and EKS modules.

## Use from another Git repository

Push this repository to GitHub, GitLab, or another Git server and create a
version tag such as `v1.0.0`. In the consuming repository, reference the folder
after the double slash:

```hcl
module "vpc" {
  source = "git::https://github.com/YOUR_ORG/terraform-aws-modules.git//aws-vpc?ref=v1.0.0"

  name            = "paywave-prod-vpc"
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}
```

Use the same pattern for the other modules:

```hcl
module "rds" {
  source = "git::https://github.com/YOUR_ORG/terraform-aws-modules.git//aws-rds?ref=v1.0.0"

  name                = "paywave-prod-mysql"
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = values(module.vpc.private_subnet_ids)
  allowed_cidr_blocks = values(module.vpc.private_subnet_cidrs)
  database_name       = var.database_name
  username            = var.database_username
  password            = var.database_password
}

module "ecr" {
  source = "git::https://github.com/YOUR_ORG/terraform-aws-modules.git//aws-ecr?ref=v1.0.0"

  repository_names = var.ecr_repository_names
}

module "eks" {
  source = "git::https://github.com/YOUR_ORG/terraform-aws-modules.git//aws-eks?ref=v1.0.0"

  cluster_name = "paywave-prod-eks"
  subnet_ids   = values(module.vpc.private_subnet_ids)
}

module "ec2" {
  source = "git::https://github.com/YOUR_ORG/terraform-aws-modules.git//aws-ec2?ref=v1.0.0"

  name      = "paywave-prod-app"
  ami_id    = var.ec2_ami_id
  subnet_id = module.vpc.private_subnet_ids["private-01"]
  vpc_id    = module.vpc.vpc_id

  ingress_rules = [{
    description = "SSH from the administrator address"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["203.0.113.10/32"]
  }]
}
```

Pin `ref` to a release tag or commit. Do not use a moving branch such as
`main` for production infrastructure.

## Run the included example

The example uses local module paths so it can be validated before this
repository is pushed:

```bash
cd examples/production
cp terraform.tfvars.example terraform.tfvars
export TF_VAR_database_password='replace-with-a-strong-secret'
terraform init
terraform plan
```

Before running it, confirm the S3 backend bucket in `versions.tf` exists and
that your AWS identity can access both the backend region (`ap-south-1`) and the
deployment region (`us-east-1`). Backend configuration cannot use normal
Terraform variables.

## Security and cost notes

- Never commit database passwords or real `terraform.tfvars` files. Sensitive
  values are still stored in Terraform state, so protect the S3 state bucket.
- The old open SSH rule was omitted because it was unused and exposed port 22
  to the whole internet.
- Restrict the EKS public endpoint to fixed `/32` administrator addresses, or
  leave its CIDR list empty to disable public access.
- NAT gateways, EKS, and RDS incur AWS charges even in a learning environment.
- Production RDS defaults enable deletion protection, backups, encrypted
  storage, and a final snapshot.
