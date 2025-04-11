# AWS Modular Terraform Infrastructure

This repository contains modular Terraform configurations for deploying infrastructure on AWS. It provides two main deployment options: EC2-based and EKS-based deployments, both following infrastructure-as-code best practices and modular design principles.

## Overview

The repository is organized into two main deployment configurations:

- **EC2 Deployment**: Single EC2 instance deployment with necessary networking and security configurations
- **EKS Deployment**: Kubernetes cluster deployment with worker nodes and application deployment capabilities

## Repository Structure

```
├── ec2-deployment/           # EC2-based infrastructure
│   ├── modules/             # EC2 specific modules
│   │   ├── vpc/            # VPC configuration
│   │   ├── security-groups/ # Security group rules
│   │   └── ec2/            # EC2 instance configuration
│   └── README.md           # EC2 deployment documentation
│
├── eks-deployment/           # EKS-based infrastructure
│   ├── modules/             # EKS specific modules
│   │   ├── vpc/            # VPC configuration
│   │   ├── security-groups/ # Security group rules
│   │   ├── iam/            # IAM roles and policies
│   │   └── eks/            # EKS cluster configuration
│   └── README.md           # EKS deployment documentation
│
└── README.md               # Main documentation
```

## Common Features

- **Modular Design**: Each component is organized into reusable modules
- **State Management**: S3 backend with DynamoDB locking
- **Security**: Proper IAM roles and security group configurations
- **Network Isolation**: VPC with public/private subnets

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform v1.0.0 or later
- Basic understanding of AWS services and Terraform

## Getting Started

1. Clone this repository
2. Choose your deployment type (EC2 or EKS)
3. Navigate to the respective deployment directory
4. Follow the deployment-specific README instructions

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

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
