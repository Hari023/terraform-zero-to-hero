# Day 02 — Terraform Variables and Outputs: Interview Questions and Answers

**Learning Track:** Terraform Zero to Hero  
**Focus:** Input Variables, Data Types, Outputs, Variable Precedence, Environment Configurations, and AWS CloudOps Scenarios  
**Level:** Beginner to Intermediate

---

## Section 1 — Terraform Input Variables

### Q1. What is a variable in Terraform?

A Terraform input variable is a parameter that allows us to customize infrastructure configurations without modifying the underlying Terraform code.

**Example:**

```hcl
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}
```

We reference it using:

```hcl
instance_type = var.instance_type
```

**Interview answer:** Variables help make Terraform configurations reusable, dynamic, and environment-independent.

### Q2. Why do we use variables in Terraform?

We use variables to:

- Avoid hardcoding infrastructure values.
- Reuse Terraform code across multiple environments.
- Improve maintainability.
- Standardize resource configurations.
- Pass values from CI/CD pipelines.

**AWS example:** Development uses `t3.micro`, while production uses `t3.medium`, without changing the resource definition.

### Q3. What is the purpose of `variables.tf`?

`variables.tf` is conventionally used to declare Terraform input variables, including their types, descriptions, defaults, and validation rules.

Terraform does not require this exact filename. It loads `.tf` configuration files in the current module directory.

### Q4. What are the main arguments of a Terraform variable block?

| Argument | Purpose |
|---|---|
| `type` | Specifies the accepted data type |
| `description` | Documents the variable |
| `default` | Supplies a fallback value |
| `sensitive` | Redacts the value in most CLI output |
| `nullable` | Controls whether null is allowed |
| `validation` | Defines custom validation conditions |

### Q5. What happens if a Terraform variable has no default value?

Terraform requires the variable to be assigned a value.

For example:

```hcl
variable "aws_region" {
  type = string
}
```

We can provide a value through a `.tfvars` file, command-line argument, environment variable, or interactive prompt.

In automated pipelines, missing required variables usually cause execution to fail because interactive input may be disabled.

---

## Section 2 — Terraform Data Types

### Q6. What data types does Terraform support?

Terraform supports:

**Primitive types:**

- `string`
- `number`
- `bool`

**Collection types:**

- `list`
- `map`
- `set`

**Structural types:**

- `object`
- `tuple`

### Q7. What is the difference between a list and a map?

A list is an ordered collection accessed using numeric indexes.

```hcl
variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}
```

Access:

```hcl
var.availability_zones[0]
```

A map stores key-value pairs accessed using keys.

```hcl
variable "tags" {
  type = map(string)

  default = {
    Owner       = "CloudOps"
    Environment = "dev"
  }
}
```

Access:

```hcl
var.tags["Owner"]
```

**Interview answer:** Lists are suitable for ordered values, while maps are useful for named key-value configurations.

### Q8. What is the difference between a map and an object?

A map contains values of a common element type.

An object contains named attributes, and each attribute can have a different type.

**Map example:**

```hcl
variable "tags" {
  type = map(string)

  default = {
    Owner = "CloudOps"
    Team  = "Infrastructure"
  }
}
```

**Object example:**

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

**Real-world use:** An object is useful when grouping EC2 configuration settings with different data types.

### Q9. What is the difference between a list and a set?

| List | Set |
|---|---|
| Ordered collection | Unordered collection |
| Allows duplicates | Removes duplicates |
| Supports index access | Does not support numeric index access |
| Useful when order matters | Useful when uniqueness matters |

### Q10. What is a boolean variable in Terraform?

A boolean variable accepts `true` or `false`.

```hcl
variable "enable_monitoring" {
  type    = bool
  default = false
}
```

It can control optional infrastructure features.

**AWS example:** Enabling or disabling detailed EC2 monitoring.

---

## Section 3 — Terraform Variable Files

### Q11. What is `terraform.tfvars`?

`terraform.tfvars` is a file used to assign values to declared Terraform input variables.

Example:

```hcl
project_name      = "aws-cloudops-production"
environment       = "prod"
instance_count    = 2
enable_monitoring = true
```

Terraform automatically loads this file when present.

### Q12. What is the difference between `variables.tf` and `terraform.tfvars`?

| `variables.tf` | `terraform.tfvars` |
|---|---|
| Declares variables | Assigns variable values |
| Defines types | Supplies configuration values |
| Can define defaults | Overrides defaults |
| Contains variable blocks | Contains variable assignments |

**Interview answer:** `variables.tf` defines what inputs a Terraform module accepts, while `terraform.tfvars` supplies values for those inputs.

### Q13. Does Terraform automatically load `dev.tfvars` and `prod.tfvars`?

No.

Terraform automatically loads files such as `terraform.tfvars` and `*.auto.tfvars`.

Custom filenames such as `dev.tfvars` and `prod.tfvars` must be specified explicitly.

```bash
terraform plan -var-file="dev.tfvars"
```

```bash
terraform plan -var-file="prod.tfvars"
```

### Q14. Can we use multiple `.tfvars` files in Terraform?

Yes.

```bash
terraform plan \
  -var-file="common.tfvars" \
  -var-file="prod.tfvars"
```

If both files assign the same variable, the later file takes precedence.

### Q15. Can we pass variables without creating a `.tfvars` file?

Yes.

**Command-line example:**

```bash
terraform plan -var="environment=qa"
```

**Environment variable example:**

```bash
export TF_VAR_environment=qa
terraform plan
```

These approaches are useful for automation and CI/CD workflows.

---

## Section 4 — Variable Precedence

### Q16. What is variable precedence in Terraform?

Variable precedence determines which value Terraform uses when multiple sources assign the same input variable.

For Terraform CLI, the precedence order from lowest to highest is:

1. Default value in the variable declaration.
2. `TF_VAR_` environment variables.
3. `terraform.tfvars`.
4. `terraform.tfvars.json`.
5. `*.auto.tfvars` and `*.auto.tfvars.json`, in lexical order.
6. Command-line `-var` and `-var-file` arguments, processed in order.

### Q17. If `terraform.tfvars` contains `environment = "prod"` but the command line specifies `environment=qa`, which value is used?

Terraform uses `qa`.

```bash
terraform plan -var="environment=qa"
```

Command-line variable assignments have higher precedence than automatically loaded `.tfvars` files.

### Q18. What is the difference between `-var` and `-var-file`?

`-var` assigns an individual variable directly.

```bash
terraform plan -var="instance_count=2"
```

`-var-file` loads multiple variable assignments from a file.

```bash
terraform plan -var-file="prod.tfvars"
```

**Interview answer:** Use `-var` for individual overrides and `-var-file` for organized environment-specific configuration.

### Q19. What is `TF_VAR_` in Terraform?

`TF_VAR_` is an environment variable prefix Terraform recognizes for input variables.

Example:

```bash
export TF_VAR_environment=staging
```

Terraform can use this value if it is not overridden by a higher-priority source.

### Q20. How do you override a production variable temporarily?

```bash
terraform plan \
  -var-file="prod.tfvars" \
  -var="instance_count=1"
```

The command-line assignment overrides the value from `prod.tfvars`.

This affects the current command only and does not edit the variable file.

---

## Section 5 — Terraform Outputs

### Q21. What is an output in Terraform?

An output exposes information from a Terraform module.

Example:

```hcl
output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.web.id
}
```

Outputs are commonly used to retrieve resource IDs, IP addresses, DNS names, and service endpoints.

### Q22. What is the difference between an input variable and an output?

| Input variable | Output |
|---|---|
| Supplies configuration values | Exposes calculated values |
| Referenced using `var.name` | Defined using an `output` block |
| Configures infrastructure | Provides information about infrastructure |
| Used before and during planning | Evaluated during planning and applying |

### Q23. Which commands display Terraform outputs?

Display all outputs:

```bash
terraform output
```

Display one output:

```bash
terraform output instance_id
```

Display JSON output:

```bash
terraform output -json
```

Display a primitive output as raw text:

```bash
terraform output -raw instance_id
```

### Q24. Can Terraform outputs be used in CI/CD pipelines?

Yes.

For example, a deployment pipeline can retrieve a load balancer DNS name:

```bash
terraform output -raw load_balancer_dns
```

The pipeline can then use that value for application deployment, smoke tests, or monitoring configuration.

### Q25. Can Terraform outputs exist without creating AWS resources?

Yes.

Example:

```hcl
variable "environment" {
  type    = string
  default = "dev"
}

output "selected_environment" {
  value = var.environment
}
```

This configuration can be applied without provisioning AWS infrastructure.

**Day 2 hands-on result:** Zero AWS resources were created while evaluating variables and outputs.

### Q26. What is a sensitive Terraform output?

A sensitive output is marked with:

```hcl
output "database_password" {
  value     = var.database_password
  sensitive = true
}
```

Terraform redacts the value in normal CLI output.

**Security warning:** Sensitive outputs may still be stored in Terraform state and can be exposed through commands such as `terraform output -json`. Sensitive marking is not encryption.

---

## Section 6 — Terraform Functions

### Q27. What is the `merge()` function in Terraform?

The `merge()` function combines maps or objects.

Example:

```hcl
merge(
  {
    Owner       = "CloudOps"
    Environment = "dev"
  },
  {
    Environment = "prod"
  }
)
```

Result:

```hcl
{
  Owner       = "CloudOps"
  Environment = "prod"
}
```

When keys overlap, the value from the later argument wins.

### Q28. Why is `merge()` useful for AWS resource tags?

It allows teams to combine standard organization tags with environment-specific tags.

Example:

```hcl
tags = merge(
  var.common_tags,
  {
    Environment = var.environment
    Name        = var.project_name
  }
)
```

This helps maintain consistent tagging across EC2 instances, VPCs, subnets, and other AWS resources.

### Q29. What is `terraform console`?

`terraform console` is an interactive command used to evaluate Terraform expressions.

Example:

```bash
terraform console
```

Inside the console:

```hcl
var.environment
```

```hcl
var.availability_zones[0]
```

```hcl
merge(var.common_tags, { Environment = var.environment })
```

It is useful for debugging expressions and understanding Terraform functions.

---

## Section 7 — Real-World AWS CloudOps Scenarios

### Q30. Your company has Dev, QA, and Prod environments. How would you reuse the same Terraform code?

I would declare reusable input variables and create environment-specific variable files.

Example structure:

```text
terraform-project/
├── main.tf
├── variables.tf
├── outputs.tf
├── dev.tfvars
├── qa.tfvars
└── prod.tfvars
```

Commands:

```bash
terraform plan -var-file="dev.tfvars"
```

```bash
terraform plan -var-file="qa.tfvars"
```

```bash
terraform plan -var-file="prod.tfvars"
```

For real deployments, I would also isolate Terraform state and access permissions between environments.

### Q31. A development EC2 instance should use `t3.micro`, but production requires `t3.medium`. How would you implement this?

Declare an input variable:

```hcl
variable "instance_type" {
  type    = string
  default = "t3.micro"
}
```

Use it in the EC2 resource:

```hcl
resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type
}
```

Assign different values in `dev.tfvars` and `prod.tfvars`.

This avoids maintaining separate copies of the EC2 resource configuration.

### Q32. Terraform is using the wrong environment value. How would you troubleshoot?

I would:

1. Check the variable default in `variables.tf`.
2. Inspect `terraform.tfvars`.
3. Check any `*.auto.tfvars` files.
4. Check `TF_VAR_` environment variables.
5. Review explicit `-var` and `-var-file` arguments.
6. Run `terraform plan` to verify the resolved configuration.

I would also use `terraform console` to inspect the selected variable value.

### Q33. Your Terraform output shows `Environment = "dev"` even though the deployment environment is `prod`. How would you fix it?

I would use the `merge()` function to override the environment tag dynamically.

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

This ensures that the tag reflects the selected environment.

### Q34. How would you securely manage database passwords in Terraform?

I would avoid hardcoding passwords or committing them in `.tfvars` files.

I would prefer AWS Secrets Manager or another approved secrets management solution, restrict IAM permissions, and protect Terraform state.

Marking a variable as sensitive helps redact CLI output:

```hcl
variable "database_password" {
  type      = string
  sensitive = true
}
```

However, sensitive values can still be stored in state, so secure state storage and access controls are essential.

### Q35. Your Terraform plan shows `0 to add, 0 to change, 0 to destroy`, but output values change. Is that possible?

Yes.

Terraform outputs can change even when no infrastructure resources are created, modified, or destroyed.

For example, changing an input variable that is referenced only by an output can result in:

```text
Changes to Outputs:
  ~ selected_environment = "dev" -> "prod"
```

After applying, Terraform updates the saved output value in state.

This was demonstrated in our Day 2 hands-on exercise.

### Q36. Do different `.tfvars` files automatically create separate Terraform state files?

No.

Variable files control input values, not state isolation.

For production-grade environments, use separate backends, state keys, or other carefully designed state isolation mechanisms.

Using Dev and Prod variable files against the same state could unintentionally modify the same infrastructure.

### Q37. How would you pass Terraform variables from a Jenkins pipeline?

A Jenkins pipeline can execute:

```bash
terraform plan \
  -var-file="dev.tfvars" \
  -out="deployment.tfplan"
```

After approval:

```bash
terraform apply deployment.tfplan
```

For sensitive values, I would use approved secret management or secure pipeline credentials rather than embedding secrets directly in Jenkinsfiles or command-line arguments.

### Q38. How would you validate that an EC2 instance type is supported by your project?

I would define a variable validation rule.

```hcl
variable "instance_type" {
  type    = string
  default = "t3.micro"

  validation {
    condition = contains(
      ["t3.micro", "t3.small", "t3.medium"],
      var.instance_type
    )

    error_message = "Only approved T3 instance types are allowed."
  }
}
```

This prevents users from supplying instance types outside the project's approved list.

### Q39. What happens if you change an input variable and run `terraform plan`?

Terraform compares the desired configuration with the current state and remote infrastructure.

Depending on how the variable is used, the plan may propose:

- No infrastructure changes.
- Updating a resource in place.
- Replacing a resource.
- Creating or destroying resources.
- Updating only outputs.

Changing a variable does not always mean Terraform will create or replace infrastructure.

### Q40. What Terraform best practices would you follow as an AWS CloudOps Engineer?

I would follow these practices:

- Use input variables instead of hardcoding values.
- Define variable types, descriptions, and validation.
- Separate environment-specific configurations.
- Isolate Terraform state between environments.
- Use IAM least-privilege permissions.
- Protect credentials and sensitive values.
- Use encrypted remote state with restricted access.
- Review `terraform plan` before applying.
- Maintain consistent AWS resource tags.
- Keep Terraform code in Git.
- Avoid committing state files or saved plans.
- Use CI/CD approvals for production infrastructure changes.

---

## Section 8 — Quick Revision Questions

| Question | Short answer |
|---|---|
| How do you reference an input variable? | `var.variable_name` |
| Which file conventionally declares variables? | `variables.tf` |
| Which file is automatically loaded for variable values? | `terraform.tfvars` |
| How do you pass a custom variable file? | `-var-file="dev.tfvars"` |
| How do you override a variable directly? | `-var="environment=qa"` |
| Which type stores true or false? | `bool` |
| Which type stores ordered values? | `list` |
| Which type stores key-value pairs? | `map` |
| Which type supports attributes of different types? | `object` |
| How do you display outputs? | `terraform output` |
| How do you export outputs as JSON? | `terraform output -json` |
| Which function combines maps? | `merge()` |
| Which command evaluates Terraform expressions? | `terraform console` |
| Does `terraform plan` create resources? | No |
| Do `.tfvars` files isolate Terraform state? | No |
| Does `sensitive = true` encrypt state? | No |

---

## Section 9 — Day 2 Practical Experience

During Day 2, I completed a hands-on Terraform project using GitHub Codespaces.

### Activities performed

1. Created Terraform input variables.
2. Practiced string, number, boolean, list, map, and object data types.
3. Configured `terraform.tfvars`.
4. Tested command-line variable overrides.
5. Created separate development and production variable files.
6. Practiced Terraform variable precedence.
7. Configured Terraform outputs.
8. Used `merge()` to dynamically assign environment tags.
9. Executed `terraform init`, `fmt`, `validate`, `plan`, and `apply`.
10. Verified output values without creating AWS infrastructure.

### Interview-ready project explanation

"In my Terraform hands-on project, I created reusable input variables for AWS CloudOps configurations, including environment names, instance counts, monitoring settings, availability zones, and server configuration objects.

I used `terraform.tfvars` and environment-specific variable files to manage Dev and Prod settings without modifying the Terraform configuration.

I also practiced variable precedence, output values, and the `merge()` function for consistent resource tagging.

Finally, I validated and applied the configuration using Terraform CLI commands. This exercise helped me understand how to design reusable Terraform configurations for real-world infrastructure automation."

---

## Day 2 Completion Summary

**Topics covered:**

- Terraform input variables
- Variable declarations and defaults
- Primitive and complex data types
- `terraform.tfvars`
- Environment-specific variable files
- Variable precedence
- Terraform outputs
- `merge()` function
- Terraform console
- Security best practices
- AWS CloudOps scenarios
- CI/CD integration concepts

**Total interview questions:** 40

**Hands-on status:** Completed

**AWS resources created:** 0

**Day 2 Status: Completed.**
