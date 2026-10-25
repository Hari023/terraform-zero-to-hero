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
<<<<<<< HEAD

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
=======
6. terraform apply
7. terraform destroy

# Day 01 — Terraform Architecture

## 1. What is Terraform Architecture?

Terraform architecture describes how Terraform reads infrastructure configuration files, communicates with cloud providers, provisions resources, and maintains infrastructure state.

**Four main components:**
1. Terraform Core
2. Terraform Provider
3. Terraform Resource
4. Terraform State

### Terraform Workflow

```text
Terraform Configuration (.tf files)
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

Terraform also maintains state information to track the resources it manages.

---

## 2. Terraform Core

Terraform Core is the main engine responsible for processing Terraform configuration files and determining what infrastructure changes are required.

**Responsibilities:**
- Reads `.tf` configuration files.
- Evaluates variables and expressions.
- Determines dependencies between resources.
- Compares desired infrastructure with the current infrastructure.
- Generates execution plans.
- Coordinates resource creation, updates, and deletion through providers.

**Example:**

If Terraform configuration specifies three EC2 instances but only two are currently managed and present, Terraform can plan to create the missing instance.

**Interview answer:**

Terraform Core is the engine that evaluates infrastructure configuration, builds dependency graphs, generates execution plans, and coordinates infrastructure changes using providers.

---

## 3. Terraform Provider

A Terraform provider is a plugin that enables Terraform to interact with external platforms and services.

**Examples:**

| Provider | Purpose |
|---|---|
| AWS | Manage AWS infrastructure |
| AzureRM | Manage Microsoft Azure resources |
| Google | Manage Google Cloud resources |
| Kubernetes | Manage Kubernetes resources |
| GitHub | Manage GitHub resources |
>>>>>>> bbf14a2 (Complete Terraform Day 1 and Day 2 hands-on exercises)

### AWS Provider Example

```hcl
provider "aws" {
  region = "ap-south-1"
}
```

<<<<<<< HEAD
Explanation:
- provider: Configures a provider.
- aws: AWS provider name.
- region: AWS region setting.
- ap-south-1: AWS Mumbai region.

The AWS provider uses available credentials to authenticate AWS API requests.

## 6. Terraform Resource

A Terraform resource represents an infrastructure object that Terraform manages.

Examples include EC2 instances, S3 buckets, VPCs, security groups, and RDS databases.
=======
**Explanation:**
- `provider` — Declares provider configuration.
- `"aws"` — Specifies the AWS provider.
- `region` — Defines the AWS region.
- `ap-south-1` — AWS Mumbai region.

The provider uses configured AWS credentials to authenticate API requests.

**Interview answer:**

A Terraform provider is a plugin that allows Terraform to communicate with cloud platforms and other services through their APIs.

---

## 4. Terraform Resource

A resource is an infrastructure object managed by Terraform.

**Examples:**
- EC2 instance
- S3 bucket
- VPC
- Security group
- RDS database
>>>>>>> bbf14a2 (Complete Terraform Day 1 and Day 2 hands-on exercises)

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

<<<<<<< HEAD
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


## 9. Real-World AWS CloudOps Example

### Scenario
A CloudOps team needs five EC2 instances for an application environment.

### Manual Approach
An engineer creates and configures each EC2 instance through the AWS Console.

### Terraform Approach
=======
### Explanation

| Parameter | Meaning |
|---|---|
| `resource` | Declares a Terraform resource |
| `aws_instance` | AWS EC2 resource type |
| `web_server` | Local Terraform resource name |
| `ami` | Amazon Machine Image ID |
| `instance_type` | EC2 instance size |
| `tags` | Metadata assigned to the resource |

**Note:** Replace the placeholder AMI with a valid AMI for the selected AWS region before deployment.

**Interview answer:**

A Terraform resource represents an infrastructure component that Terraform can create, update, or delete through a provider.

---

## 5. Terraform State

Terraform state stores information about the infrastructure managed by Terraform.

By default, Terraform uses a local state file named:

`terraform.tfstate`

### Why Terraform State Is Important

1. Maps Terraform resources to actual cloud infrastructure.
2. Stores resource attributes and identifiers.
3. Helps Terraform calculate infrastructure changes.
4. Supports dependency tracking and resource management.
5. Enables teams to manage shared infrastructure using remote state.

### Example

Suppose Terraform creates an EC2 instance:

```text
Terraform Resource:
aws_instance.web_server

AWS Resource:
i-0123456789abcdef0
```

Terraform state maintains the association between the resource address and the AWS instance.

### Important Security Practices

- Never commit `terraform.tfstate` to GitHub.
- State files may contain sensitive information.
- Use remote state storage for team collaboration.
- Protect remote state using access controls and encryption.
- Use state locking to prevent conflicting concurrent operations.

**Interview answer:**

Terraform state tracks managed infrastructure and maps Terraform configuration resources to actual cloud resources. It is essential for planning and managing infrastructure changes.

---

## 6. Real-Time AWS CloudOps Example

**Scenario:** Your CloudOps team needs to deploy five EC2 instances.

**Manual approach:**

An engineer logs into AWS Console and creates each EC2 instance individually.

**Terraform approach:**
>>>>>>> bbf14a2 (Complete Terraform Day 1 and Day 2 hands-on exercises)

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

<<<<<<< HEAD
Terraform manages five EC2 instances using one resource block and the count meta-argument.

### Benefits
- Repeatable deployment
- Consistent configurations
- Easier scaling
- Version-controlled infrastructure
- Reduced manual work

Cost Warning: Five EC2 instances may incur charges. Do not deploy without checking AWS pricing and account eligibility.

=======
Terraform can manage five EC2 instances from a single resource configuration.

**Advantages:**
- Repeatable deployments.
- Reduced manual configuration.
- Infrastructure version control.
- Easier scaling.
- Consistent resource configuration.

**Cost precaution:** This example is for learning. Creating five EC2 instances may incur AWS charges. Do not apply it without checking pricing and eligibility.

---

## 7. Terraform Architecture — Interview Questions

**Q1. What is Terraform Core?**

Terraform Core is the main engine responsible for evaluating Terraform configurations, calculating changes, and coordinating infrastructure operations.

**Q2. What is a Terraform provider?**

A provider is a plugin that allows Terraform to communicate with external services such as AWS, Azure, and Kubernetes.

**Q3. What is a Terraform resource?**

A resource represents an infrastructure object managed by Terraform, such as an EC2 instance or S3 bucket.

**Q4. What is Terraform state?**

Terraform state stores information about managed infrastructure and maps Terraform resource addresses to real infrastructure objects.

**Q5. What happens when you execute `terraform plan`?**

Terraform evaluates the configuration and available state, refreshes managed resource information by default, and generates a plan showing proposed changes without applying them.

**Q6. What is the difference between Terraform Core and a provider?**

Terraform Core determines what changes are needed and coordinates execution. Providers communicate with external APIs to read and manage resources.

**Q7. Can Terraform manage infrastructure across multiple cloud providers?**

Yes. Terraform supports multiple providers, allowing infrastructure management across AWS, Azure, Google Cloud, and other platforms.
>>>>>>> bbf14a2 (Complete Terraform Day 1 and Day 2 hands-on exercises)
