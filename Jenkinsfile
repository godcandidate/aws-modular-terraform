pipeline {
    agent any

    environment {
        TERRAFORM_DIR = 'ec2-deployment'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/godcandidate/aws-modular-terraform.git'
            }
        }

        stage('Terraform Version') {
            steps {
                dir("${env.TERRAFORM_DIR}") {
                    sh 'terraform -version'
                }
            }
        }

        stage('Terraform Init') {
            steps {
                dir("${env.TERRAFORM_DIR}") {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                withAWS(credentials: 'qr-aws-cred', region: "${AWS_REGION}") {
                dir("${env.TERRAFORM_DIR}") {
                    sh 'terraform plan'
                }
            }
                
            }
        }

        stage('Terraform apply') {
            steps {
                withAWS(credentials: 'qr-aws-cred', region: "${AWS_REGION}") {
                dir("${env.TERRAFORM_DIR}") {
                    sh 'terraform apply -auto-approve'
                }
            }
            }
        }
        stage('Terraform destroy') {
            steps {
                withAWS(credentials: 'qr-aws-cred', region: "${AWS_REGION}") {
                dir("${env.TERRAFORM_DIR}") {
                    sh 'terraform destroy -auto-approve'
                }
            }
            }
        }
    }
}
