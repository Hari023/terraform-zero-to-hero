# Day 01 - Terraform Fundamentals

## 1. Infrastructure as Code (IaC)

Infrastructure as Code is the practice of managing
and provisioning infrastructure using code instead
of manual configuration.

### Benefits
- Automation
- Consistency
- Version control
- Repeatability
- Reduced manual errors

### AWS CloudOps Example
Terraform can provision EC2 instances, VPCs,
security groups, and other AWS resources.

## 2. What is Terraform?

Terraform is an Infrastructure as Code tool
developed by HashiCorp.

It uses HCL (HashiCorp Configuration Language)
to define and manage infrastructure.

### Basic Terraform Workflow
1. Write configuration
2. terraform init
3. terraform fmt
4. terraform validate
5. terraform plan

## 3. Terraform Architecture

### 1. Terraform Core

Terraform Core is the main engine that reads your
configuration, determines dependencies, compares
desired and current infrastructure, and creates
an execution plan.

### 2. Terraform Provider

A provider is a plugin that allows Terraform to
communicate with AWS, Azure, or Google Cloud.

Example:

```hcl
provider "aws" {
  region = "ap-south-1"
}


####3. Terraform Resource
A resource represents infrastructure managed
by Terraform.
resource "aws_instance" "web_server" {
  ami           = "ami-xxxxxxxx"
  instance_type = "t3.micro"

  tags = {
    Name = "CloudOps-Demo"
  }
}


- aws_instance: Resource type
- web_server: Local resource name
- ami: Amazon Machine Image ID
- instance_type: EC2 instance size
Note: The AMI ID is a placeholder.
4. Terraform State
Terraform maintains a state file named
terraform.tfstate by default.

It tracks managed resources and helps Terraform
determine infrastructure changes.

Important: Never commit state files containing
sensitive information to GitHub.
6. terraform apply
7. terraform destroy
