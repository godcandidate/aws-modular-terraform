# EC2 Deployment

This directory contains Terraform configurations for deploying a single EC2 instance with all necessary networking and security components.

## Architecture

[Insert EC2 Architecture Diagram Here]

## Components

### VPC Module
- Creates a VPC with public subnets
- Sets up Internet Gateway and route tables
- Configures CIDR blocks and availability zones

### Security Groups Module
- Defines inbound/outbound rules for EC2 instance
- Allows HTTP/HTTPS traffic for web access
- Permits SSH access for management

### EC2 Module
- Launches EC2 instance with specified AMI
- Configures user data for Docker installation
- Sets up instance profile and security groups

## Configuration

### Required Variables
```hcl
region         = "eu-west-1"    # AWS region
environment    = "production"    # Environment name
vpc_cidr       = "10.0.0.0/16"  # VPC CIDR block
ami_id         = "ami-xxxxx"    # Amazon Linux 2 AMI ID
instance_type  = "t2.micro"     # Instance type
ssh_key_name   = "my-key"       # SSH key name
docker_image   = "my-app:latest" # Docker image to deploy
```

## Deployment

1. Initialize Terraform:
   ```bash
   terraform init
   ```

2. Review the plan:
   ```bash
   terraform plan
   ```

3. Apply the configuration:
   ```bash
   terraform apply
   ```

## Outputs

- `instance_public_ip`: Public IP of the EC2 instance
- `instance_id`: ID of the created EC2 instance
- `vpc_id`: ID of the created VPC

## State Management

The state is stored in an S3 bucket with DynamoDB locking to prevent concurrent modifications.
