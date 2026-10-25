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

# Day 01 — Terraform Fundamentals and Architecture

## 1. What is Infrastructure as Code (IaC)?

Infrastructure as Code (IaC) is the practice of provisioning and managing infrastructure using code instead of manually configuring resources through a cloud console.

### Benefits of IaC
- Automation: Reduces repetitive manual tasks.
- Consistency: Creates infrastructure using repeatable configurations.
- Version Control: Infrastructure changes can be tracked using Git.
- Scalability: Resources can be created and modified efficiently.
- Reduced Human Error: Minimizes manual configuration mistakes.
- Reusability: The same configuration can be used across environments.

### AWS CloudOps Example
Instead of manually launching EC2 instances from the AWS Console, a CloudOps engineer can define the required EC2 instances in Terraform configuration files.

## 2. What is Terraform?

Terraform is an Infrastructure as Code (IaC) tool developed by HashiCorp. It allows engineers to define, provision, modify, and manage infrastructure using declarative configuration files.

Terraform uses HashiCorp Configuration Language (HCL).

### Key Features
- Declarative infrastructure management
- Multi-cloud support
- Reusable configurations and modules
- Infrastructure state management
- Execution plans before deployment
- Automation and Git integration

### Declarative vs Imperative
Declarative means defining the desired end state of infrastructure rather than writing every step required to create it.

Terraform determines the necessary operations to reach that desired state.

## 3. Terraform Architecture

Terraform architecture involves four key concepts:
1. Terraform Core
2. Terraform Providers
3. Terraform Resources
4. Terraform State

### Architecture Flow

```text
Terraform Configuration (.tf)
          |
          v
     Terraform Core
          |
          v
     AWS Provider
          |
          v
        AWS APIs
          |
          v
   AWS Infrastructure
   (EC2, VPC, S3, RDS)
```

Terraform state tracks managed infrastructure separately from the configuration.

## 4. Terraform Core

Terraform Core is the main engine responsible for reading Terraform configuration files, evaluating expressions, building dependency relationships, generating execution plans, and coordinating infrastructure changes.

### Responsibilities
- Reads and evaluates Terraform configuration.
- Processes variables and expressions.
- Builds a resource dependency graph.
- Compares desired infrastructure with managed infrastructure.
- Generates execution plans.
- Coordinates changes through providers.

### Example
If the desired configuration specifies three EC2 instances but only two currently exist, Terraform can plan to create the missing instance.

## 5. Terraform Provider

A Terraform provider is a plugin that enables Terraform to communicate with external services and their APIs.

### Examples

| Provider | Purpose |
|---|---|
| AWS | AWS infrastructure |
| AzureRM | Microsoft Azure infrastructure |
| Google | Google Cloud infrastructure |
| Kubernetes | Kubernetes resources |
| GitHub | GitHub resources |

### AWS Provider Example

```hcl
provider "aws" {
  region = "ap-south-1"
}
```

Explanation:
- provider: Configures a provider.
- aws: AWS provider name.
- region: AWS region setting.
- ap-south-1: AWS Mumbai region.

The AWS provider uses available credentials to authenticate AWS API requests.

## 6. Terraform Resource

A Terraform resource represents an infrastructure object that Terraform manages.

Examples include EC2 instances, S3 buckets, VPCs, security groups, and RDS databases.

### EC2 Resource Example

```hcl
resource "aws_instance" "web_server" {
  ami           = "ami-xxxxxxxx"
  instance_type = "t3.micro"

  tags = {
    Name = "CloudOps-Demo"
  }
}
```

### Resource Parameters

| Parameter | Description |
|---|---|
| resource | Declares a managed resource |
| aws_instance | AWS EC2 resource type |
| web_server | Terraform local resource name |
| ami | Amazon Machine Image ID |
| instance_type | EC2 instance size |
| tags | Resource metadata |

Note: The AMI above is a placeholder. Use a valid regional AMI before deployment.

## 7. Terraform State

Terraform state tracks the infrastructure managed by Terraform.

By default, Terraform stores local state in a file named `terraform.tfstate`.

### Why State Is Important
- Maps Terraform resource addresses to actual cloud resources.
- Stores resource attributes and identifiers.
- Helps calculate planned infrastructure changes.
- Supports resource dependency management.
- Enables shared infrastructure management when using a remote backend.

### Example

```text
Terraform resource:
aws_instance.web_server

AWS EC2 instance:
i-0123456789abcdef0
```

Terraform state maintains the association between the Terraform resource and the real AWS instance.

### State Security Best Practices
- Never commit Terraform state files to GitHub.
- Use appropriate encryption and access controls.
- Use remote state storage for team collaboration.
- Enable state locking where supported.
- Restrict access to sensitive state information.

## 8. Basic Terraform Workflow

```text
Write Terraform Configuration
             |
             v
       terraform init
             |
             v
       terraform fmt
             |
             v
     terraform validate
             |
             v
       terraform plan
             |
             v
       terraform apply
             |
             v
      AWS Infrastructure
```

### Basic Commands

| Command | Purpose |
|---|---|
| terraform init | Initializes the working directory and installs required providers |
| terraform fmt | Formats Terraform configuration |
| terraform validate | Checks configuration validity |
| terraform plan | Previews proposed infrastructure changes |
| terraform apply | Applies infrastructure changes |
| terraform destroy | Plans and destroys managed infrastructure |

Detailed lifecycle commands and practical examples will be covered in the next topic.

## 9. Real-World AWS CloudOps Example

### Scenario
A CloudOps team needs five EC2 instances for an application environment.

### Manual Approach
An engineer creates and configures each EC2 instance through the AWS Console.

### Terraform Approach

```hcl
resource "aws_instance" "cloudops_servers" {
  count         = 5
  ami           = "ami-xxxxxxxx"
  instance_type = "t3.micro"

  tags = {
    Name = "CloudOps-Server-${count.index + 1}"
  }
}
```

Terraform manages five EC2 instances using one resource block and the count meta-argument.

### Benefits
- Repeatable deployment
- Consistent configurations
- Easier scaling
- Version-controlled infrastructure
- Reduced manual work

Cost Warning: Five EC2 instances may incur charges. Do not deploy without checking AWS pricing and account eligibility.

