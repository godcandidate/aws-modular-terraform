# AWS Modular Terraform Infrastructure

This repository contains Terraform configurations for provisioning a complete AWS infrastructure including VPC, EC2, and EKS cluster.

## Project Structure

```
├── modules/
│   ├── vpc/                 # VPC, subnets, and networking components
│   ├── ec2/                 # EC2 instance configuration
│   ├── eks/                 # EKS cluster and worker nodes
│   └── security-groups/     # Security group definitions
├── main.tf                  # Root module configuration
├── variables.tf            # Input variables
├── outputs.tf              # Output definitions
├── providers.tf            # Provider configurations
└── backend.tf             # Remote state configuration
```

## Prerequisites

1. AWS CLI configured with appropriate credentials
2. Terraform >= 1.0.0
3. An existing SSH key pair in AWS
4. S3 bucket for remote state (will be created automatically)

## Usage

1. Initialize Terraform:
   ```bash
   terraform init
   ```

2. Review the planned changes:
   ```bash
   terraform plan
   ```

3. Apply the configuration:
   ```bash
   terraform apply
   ```

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| region | AWS region | string | us-east-1 |
| docker_image | Docker image to deploy | string | nginx:latest |
| instance_type | EC2 instance type | string | t3.medium |
| ssh_key_name | Name of existing SSH key pair | string | - |

## Outputs

| Name | Description |
|------|-------------|
| ec2_public_ip | Public IP of the EC2 instance |
| eks_endpoint | EKS cluster endpoint |
| vpc_id | ID of the created VPC |

## Notes

- The EC2 instance will automatically install Docker and run the specified container
- The EKS cluster will be configured with the EC2 instance as a self-managed node
- Remote state is stored in S3 with DynamoDB locking
