# Day 02 — Terraform Variables and Outputs

## 1. Introduction

Terraform variables make Infrastructure as Code (IaC) configurations reusable, flexible, and easier to maintain.

Instead of hardcoding infrastructure settings such as AWS regions, EC2 instance types, environments, or resource tags, we can define variables and supply different values for development, testing, and production.

### Why are variables important?

- Avoid hardcoding infrastructure configuration.
- Reuse the same Terraform code across multiple environments.
- Improve maintainability and readability.
- Standardize resource configurations.
- Support automation through CI/CD pipelines.

**CloudOps example:** A development environment might use a `t3.micro` EC2 instance, while production might require a `t3.medium`. Variables allow us to use the same Terraform configuration with different instance types.

---

## 2. Terraform Input Variables

Input variables allow external values to be passed into Terraform configurations.

### Syntax

```hcl
variable "variable_name" {
  description = "Description of the variable"
  type        = string
  default     = "default-value"
}
```

### Example: EC2 Instance Type

```hcl
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}
```

Reference the variable using:

```hcl
instance_type = var.instance_type
```

### Important variable arguments

| Argument | Purpose |
|---|---|
| `description` | Explains the variable |
| `type` | Defines the accepted data type |
| `default` | Provides a value when no override is supplied |
| `sensitive` | Redacts the value from most CLI output |
| `nullable` | Controls whether `null` is accepted |
| `validation` | Defines custom validation rules |

If a variable has no default value, Terraform normally requires a value to be supplied.

---

## 3. Terraform Variable Data Types

Terraform supports primitive and complex data types.

### 3.1 String

Stores text values.

```hcl
variable "project_name" {
  type    = string
  default = "terraform-cloudops"
}
```

Reference:

```hcl
var.project_name
```

### 3.2 Number

Stores numeric values.

```hcl
variable "instance_count" {
  type    = number
  default = 1
}
```

Common uses include instance counts, disk sizes, and application ports.

### 3.3 Boolean

Stores `true` or `false`.

```hcl
variable "enable_monitoring" {
  type    = bool
  default = false
}
```

CloudOps use case: Enable or disable detailed EC2 monitoring.

### 3.4 List

Stores an ordered collection of values.

```hcl
variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}
```

Access individual elements:

```hcl
var.availability_zones[0]
```

Result:

```text
us-east-1a
```

### 3.5 Map

Stores key-value pairs whose values have a common type.

```hcl
variable "common_tags" {
  type = map(string)

  default = {
    Owner       = "CloudOps"
    Environment = "dev"
  }
}
```

Access a value:

```hcl
var.common_tags["Owner"]
```

Result:

```text
CloudOps
```

### 3.6 Object

Stores a structured group of attributes, potentially with different types.

```hcl
variable "server_config" {
  type = object({
    instance_type = string
    monitoring    = bool
    disk_size     = number
  })

  default = {
    instance_type = "t3.micro"
    monitoring    = false
    disk_size     = 8
  }
}
```

Access an attribute:

```hcl
var.server_config.instance_type
```

Result:

```text
t3.micro
```

### List vs Map vs Object

| Type | Structure | Typical use |
|---|---|---|
| List | Ordered values | Availability zones, subnet IDs |
| Map | Key-value pairs | AWS resource tags |
| Object | Named attributes with specified types | EC2 configuration |

Terraform also supports sets, tuples, and additional collection types.

---

## 4. Understanding `variables.tf`

`variables.tf` is the conventional filename used to declare input variables.

Example:

```hcl
variable "project_name" {
  type    = string
  default = "terraform-cloudops"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "instance_count" {
  type    = number
  default = 1
}

variable "enable_monitoring" {
  type    = bool
  default = false
}
```

**Important:** Terraform reads all `.tf` files in the current module directory. The filename `variables.tf` is a convention, not a requirement.

---

## 5. Understanding `terraform.tfvars`

A `.tfvars` file provides values for declared input variables.

Example:

```hcl
project_name      = "aws-cloudops-production"
environment       = "prod"
instance_count    = 2
enable_monitoring = true
```

Terraform automatically loads a file named `terraform.tfvars`.

### Difference between `variables.tf` and `terraform.tfvars`

| `variables.tf` | `terraform.tfvars` |
|---|---|
| Declares variables | Assigns variable values |
| Defines types | Supplies environment-specific settings |
| Can define defaults | Can override defaults |
| Contains variable blocks | Contains variable assignments |

A `.tfvars` file cannot declare a new input variable; the variable must already be declared in the Terraform module.

---

## 6. Terraform Variable Precedence

When multiple sources provide values for the same variable, Terraform follows precedence rules.

### Precedence order (lowest to highest)

1. Default value in the variable declaration.
2. Environment variable (`TF_VAR_name`).
3. `terraform.tfvars`.
4. `terraform.tfvars.json`.
5. `*.auto.tfvars` and `*.auto.tfvars.json` files, in lexical order.
6. Command-line `-var` and `-var-file` arguments, in the order supplied.

### Example

Default in `variables.tf`:

```hcl
variable "environment" {
  type    = string
  default = "dev"
}
```

Value in `terraform.tfvars`:

```hcl
environment = "prod"
```

Command:

```bash
terraform plan -var="environment=qa"
```

Terraform uses:

```text
qa
```

The command-line argument overrides the value in `terraform.tfvars`.

### Environment variable example

```bash
export TF_VAR_environment=staging
terraform plan
```

The environment variable provides `staging` only when a higher-priority source does not override it.

---

## 7. Environment-Specific Variable Files

In real-world infrastructure projects, separate variable files can represent different environments.

### Development: `dev.tfvars`

```hcl
project_name      = "cloudops-dev"
environment       = "dev"
instance_count    = 1
enable_monitoring = false
```

### Production: `prod.tfvars`

```hcl
project_name      = "cloudops-prod"
environment       = "prod"
instance_count    = 2
enable_monitoring = true
```

### Commands

Development:

```bash
terraform plan -var-file="dev.tfvars"
```

Production:

```bash
terraform plan -var-file="prod.tfvars"
```

To apply a specific environment configuration:

```bash
terraform apply -var-file="dev.tfvars"
```

### Benefits

- Reuse Terraform configuration.
- Keep environment settings separate.
- Reduce manual code modifications.
- Support automated deployment workflows.

**Important:** Separate `.tfvars` files do not automatically create separate Terraform state files. Real Dev and Prod infrastructure should use isolated state and appropriate access controls.

---

## 8. Terraform Output Values

Outputs expose useful information after Terraform evaluates or applies a configuration.

Typical examples include:

- EC2 instance ID.
- EC2 public or private IP address.
- VPC ID.
- Load balancer DNS name.
- RDS endpoint.
- Configuration details.

### Syntax

```hcl
output "output_name" {
  description = "Description"
  value       = expression
}
```

### Example

```hcl
output "project_details" {
  description = "CloudOps configuration details"

  value = {
    project_name      = var.project_name
    environment       = var.environment
    instance_count    = var.instance_count
    enable_monitoring = var.enable_monitoring
  }
}
```

### Commands

Display all outputs:

```bash
terraform output
```

Display a specific output:

```bash
terraform output project_details
```

Display outputs in JSON:

```bash
terraform output -json
```

**CloudOps use case:** A CI/CD pipeline can retrieve Terraform outputs and pass infrastructure identifiers to subsequent deployment or validation stages.

---

## 9. Terraform `merge()` Function

The `merge()` function combines maps or objects.

When multiple arguments contain the same key, the value from the later argument takes precedence.

### Example

```hcl
output "server_tags" {
  value = merge(
    var.common_tags,
    {
      Environment = var.environment
    }
  )
}
```

If:

```hcl
common_tags = {
  Owner       = "CloudOps"
  Environment = "dev"
}
```

And:

```hcl
environment = "prod"
```

The result is:

```hcl
{
  Owner       = "CloudOps"
  Environment = "prod"
}
```

This prevents inconsistencies between environment configuration and resource tags.

---

## 10. Day 2 Hands-on Project

### Project folder

```text
Day-02-Variables-and-Outputs/
├── notes.md
├── commands.md
├── interview-questions.md
└── hands-on/
    ├── variables.tf
    ├── outputs.tf
    ├── terraform.tfvars
    ├── dev.tfvars
    └── prod.tfvars
```

### Objective

Practice Terraform input variables, data types, output values, environment-specific configurations, and variable precedence.

### Commands executed

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
terraform output
```

Environment-specific plans:

```bash
terraform plan -var-file="dev.tfvars"
terraform plan -var-file="prod.tfvars"
```

Command-line override:

```bash
terraform plan -var="environment=qa"
```

### Hands-on result

Successfully evaluated Terraform variables and outputs without provisioning AWS resources.

Example production configuration:

```text
project_details = {
  "enable_monitoring" = true
  "environment" = "prod"
  "instance_count" = 2
  "project_name" = "aws-cloudops-production"
}
```

Additional outputs:

```text
availability_zones = [
  "us-east-1a",
  "us-east-1b"
]

server_configuration = {
  "disk_size" = 8
  "instance_type" = "t3.micro"
  "monitoring" = false
}
```

**Resources created:** 0

**AWS infrastructure cost:** None from this output-only exercise.

---

## 11. Security Best Practices

- Never hardcode AWS access keys or passwords in Terraform configuration.
- Avoid committing credentials, secrets, and Terraform state files.
- Use IAM roles and temporary credentials when possible.
- Use `sensitive = true` to redact sensitive variable values from most Terraform CLI output.
- Remember that `sensitive = true` does not encrypt or prevent values from being stored in Terraform state.
- Use encrypted remote state with restricted access for real infrastructure.
- Keep environment configurations and access permissions appropriately separated.

### Example `.gitignore`

```gitignore
.terraform/
*.tfstate
*.tfstate.*
*.tfplan
crash.log

# Local or sensitive variable files
terraform.tfvars
*.auto.tfvars
*.auto.tfvars.json
```

Non-sensitive `dev.tfvars` and `prod.tfvars` files can be committed intentionally. Sensitive variable files should be excluded.

The `.terraform.lock.hcl` file should normally be committed to Git.

---

## 12. Real-World AWS CloudOps Use Cases

### EC2 Provisioning

Use variables to configure instance type, AMI, instance count, and tags.

### Multi-Environment Deployment

Reuse the same Terraform code with different Dev, QA, and Prod variable files.

### Infrastructure Standardization

Define consistent tags, resource naming conventions, and monitoring settings.

### CI/CD Automation

Pass environment-specific values into Terraform through pipeline parameters.

### Infrastructure Visibility

Expose resource IDs, endpoints, and addresses using Terraform outputs.

---

## 13. Important Interview Takeaways

**What is an input variable?**

An input variable is a parameter that makes Terraform configurations customizable and reusable.

**What is the difference between a variable and an output?**

Input variables supply values to a Terraform module. Outputs expose values from a Terraform module.

**What is variable precedence?**

Variable precedence determines which value Terraform uses when the same variable is assigned from multiple sources.

**What is the purpose of `.tfvars`?**

A `.tfvars` file stores input variable assignments separately from Terraform configuration code.

**What is the `merge()` function?**

It combines maps or objects, with later values overriding earlier values for matching keys.

**Can Terraform outputs be used without creating resources?**

Yes. Terraform can evaluate input variables, expressions, and outputs without provisioning infrastructure.

---

## 14. Day 2 Summary

Topics completed:

- Terraform input variables.
- String, number, and boolean data types.
- List, map, and object data types.
- `variables.tf` and `terraform.tfvars`.
- Variable defaults and precedence.
- Environment-specific `.tfvars` files.
- Terraform outputs.
- Terraform `merge()` function.
- Practical AWS CloudOps use cases.
- Security best practices.

**Learning outcome:** Able to build reusable, parameterized Terraform configurations and customize them for different environments without changing the underlying infrastructure code.

**Day 2 Status: Completed.**
