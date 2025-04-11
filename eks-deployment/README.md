# EKS Deployment

This directory contains Terraform configurations for deploying an Amazon EKS cluster with all necessary networking, security, and IAM components.

## Architecture

[Insert EKS Architecture Diagram Here]

## Components

### VPC Module
- Creates a VPC with public subnets
- Sets up Internet Gateway and route tables
- Configures CIDR blocks and availability zones
- Adds required EKS tags for auto-discovery

### Security Groups Module
- Defines cluster and node group security rules
- Configures control plane to worker node communication
- Sets up worker node intercommunication

### IAM Module
- Creates EKS cluster service role
- Sets up node group IAM role
- Attaches required AWS managed policies

### EKS Module
- Deploys EKS cluster with specified version
- Creates managed node group
- Configures Kubernetes deployment
- Sets up LoadBalancer service

## Configuration

### Required Variables
```hcl
region             = "eu-west-1"     # AWS region
environment        = "eks-app"       # Environment name
vpc_cidr           = "10.1.0.0/16"   # VPC CIDR block
cluster_name       = "eks-demo"      # EKS cluster name
kubernetes_version = "1.32"          # Kubernetes version
instance_type      = "t2.micro"      # Node instance type
desired_size       = 1               # Desired node count
max_size           = 2               # Maximum node count
min_size           = 1               # Minimum node count
docker_image       = "my-app:latest" # Application image
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

4. Configure kubectl (after successful deployment):
   ```bash
   aws eks update-kubeconfig --region <region> --name <cluster_name>
   ```

## Outputs

- `cluster_endpoint`: EKS cluster endpoint
- `cluster_name`: Name of the EKS cluster
- `kubeconfig_command`: Command to configure kubectl
- `app_load_balancer`: Application load balancer hostname

## State Management

The state is stored in an S3 bucket with DynamoDB locking to prevent concurrent modifications.

## Accessing the Application

After deployment, the application will be accessible via the load balancer hostname provided in the outputs. The service is exposed on port 80.
