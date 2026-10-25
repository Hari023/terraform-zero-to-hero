# Day 02 — Terraform Variables and Outputs: Commands Cheat Sheet

## 1. Objective

Practice Terraform input variables, output values, data types, variable precedence, environment-specific configuration files, and Terraform CLI commands.

**Environment:** GitHub Codespaces (Linux)

**Project:** Terraform Zero to Hero — AWS CloudOps Learning

**AWS resources created:** None

---

## 2. Navigate to the Day 2 Project

```bash
cd /workspaces/terraform-zero-to-hero/Hari-Terraform-CloudOps-Learning/Day-02-Variables-and-Outputs/hands-on
```

Check the current directory:

```bash
pwd
```

List project files:

```bash
ls -la
```

Return to the Day 2 parent directory:

```bash
cd ..
```

Return to the main learning directory from `hands-on`:

```bash
cd ../..
```

**Explanation:** Terraform commands operate on the configuration files in the current working directory.

---

## 3. Create and Edit Terraform Files

Open the variable declarations file:

```bash
code variables.tf
```

Open the outputs file:

```bash
code outputs.tf
```

Open the default variable values file:

```bash
code terraform.tfvars
```

Open the development environment file:

```bash
code dev.tfvars
```

Open the production environment file:

```bash
code prod.tfvars
```

**Explanation:** The `code` command opens files in the VS Code editor within GitHub Codespaces.

---

## 4. Initialize Terraform

```bash
terraform init
```

**Purpose:**

- Initializes the Terraform working directory.
- Downloads required providers when configured.
- Initializes the configured backend.
- Prepares Terraform for planning and applying configurations.

**Expected result:**

```text
Terraform has been successfully initialized!
```

Run this command when starting a new Terraform project or changing backend/provider requirements.

---

## 5. Format Terraform Configuration

```bash
terraform fmt
```

**Purpose:** Formats Terraform configuration files using Terraform's standard style.

Format all Terraform files recursively:

```bash
terraform fmt -recursive
```

Check formatting without modifying files:

```bash
terraform fmt -check
```

**CloudOps use case:** Maintain consistent code formatting across infrastructure repositories.

---

## 6. Validate Terraform Configuration

```bash
terraform validate
```

**Purpose:**

- Checks Terraform configuration syntax and internal consistency.
- Detects invalid references and unsupported arguments.
- Does not create AWS resources.

**Expected result:**

```text
Success! The configuration is valid.
```

**Important:** Validation does not guarantee that AWS permissions are sufficient or that deployment will succeed.

---

## 7. Preview Terraform Changes

```bash
terraform plan
```

**Purpose:** Displays the changes Terraform proposes to make.

For our Day 2 project, the plan evaluates variable values and outputs without provisioning infrastructure.

Example:

```text
Changes to Outputs:
  + project_details = {
      + environment = "dev"
    }
```

**Important:** `terraform plan` does not apply the proposed changes.

---

## 8. Apply Terraform Configuration

```bash
terraform apply
```

Terraform asks for confirmation:

```text
Enter a value: yes
```

Expected result for our output-only exercise:

```text
Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
```

**Explanation:** Terraform evaluates the input variables and saves the resulting root module outputs in state.

For this exercise, no AWS resources are created.

---

## 9. Display Terraform Outputs

Display all outputs:

```bash
terraform output
```

Display a specific output:

```bash
terraform output project_details
```

Display outputs in JSON format:

```bash
terraform output -json
```

Display a string output without surrounding quotes:

```bash
terraform output -raw output_name
```

Replace `output_name` with an existing string output. The `-raw` option is intended for string, number, or boolean output values, not complex objects.

**CloudOps use case:** Retrieve EC2 instance IDs, load balancer DNS names, VPC IDs, and other infrastructure details for automation.

---

## 10. Override Variables Using `terraform.tfvars`

Create or edit:

```bash
code terraform.tfvars
```

Example:

```hcl
project_name      = "aws-cloudops-production"
environment       = "prod"
instance_count    = 2
enable_monitoring = true
```

Preview:

```bash
terraform plan
```

Apply:

```bash
terraform apply
```

View updated outputs:

```bash
terraform output
```

**Explanation:** Terraform automatically loads `terraform.tfvars` and uses its values instead of variable defaults.

---

## 11. Override a Variable from the Command Line

```bash
terraform plan -var="environment=qa"
```

**Purpose:** Overrides the `environment` input variable for this Terraform command.

If `terraform.tfvars` contains:

```hcl
environment = "prod"
```

The command-line value takes precedence:

```text
environment = "qa"
```

Override multiple variables:

```bash
terraform plan \
  -var="environment=qa" \
  -var="instance_count=3"
```

**Important:** A `terraform plan` override does not permanently modify `terraform.tfvars` or the saved state.

---

## 12. Use Environment Variables

Set a Terraform input variable:

```bash
export TF_VAR_environment=staging
```

Run Terraform:

```bash
terraform plan
```

Remove the environment variable:

```bash
unset TF_VAR_environment
```

**Explanation:** Terraform recognizes environment variables prefixed with `TF_VAR_`.

A value in `terraform.tfvars`, an automatically loaded variable file, or a command-line override takes precedence over `TF_VAR_`.

---

## 13. Use Development and Production Variable Files

### Development environment

Open:

```bash
code dev.tfvars
```

Example:

```hcl
project_name      = "cloudops-dev"
environment       = "dev"
instance_count    = 1
enable_monitoring = false
```

Preview development settings:

```bash
terraform plan -var-file="dev.tfvars"
```

### Production environment

Open:

```bash
code prod.tfvars
```

Example:

```hcl
project_name      = "cloudops-prod"
environment       = "prod"
instance_count    = 2
enable_monitoring = true
```

Preview production settings:

```bash
terraform plan -var-file="prod.tfvars"
```

### Compare configurations

| Variable | Development | Production |
|---|---|---|
| `project_name` | cloudops-dev | cloudops-prod |
| `environment` | dev | prod |
| `instance_count` | 1 | 2 |
| `enable_monitoring` | false | true |

**Important:** `dev.tfvars` and `prod.tfvars` are not automatically loaded. They must be specified with `-var-file`.

---

## 14. Apply a Specific Variable File

Apply development configuration:

```bash
terraform apply -var-file="dev.tfvars"
```

Apply production configuration:

```bash
terraform apply -var-file="prod.tfvars"
```

Apply without interactive approval:

```bash
terraform apply -var-file="dev.tfvars" -auto-approve
```

**Warning:** `-auto-approve` skips interactive approval. Use it cautiously, especially with real AWS infrastructure.

**Production best practice:** Isolate Terraform state between environments. Different `.tfvars` files alone do not provide environment isolation.

---

## 15. Test Variable Precedence

Terraform variable precedence, from lowest to highest:

1. Variable defaults.
2. `TF_VAR_` environment variables.
3. `terraform.tfvars`.
4. `terraform.tfvars.json`.
5. `*.auto.tfvars` and `*.auto.tfvars.json`, in lexical order.
6. Explicit `-var` and `-var-file` arguments, in the order provided.

Test command-line precedence:

```bash
terraform plan -var="environment=qa"
```

Test an explicit variable file:

```bash
terraform plan -var-file="dev.tfvars"
```

Override a variable from an explicit file:

```bash
terraform plan \
  -var-file="dev.tfvars" \
  -var="environment=staging"
```

**Expected behavior:** The final command-line assignment wins, so `environment` becomes `staging`.

---

## 16. Test List, Map, and Object Variables

Example variables:

```hcl
variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

variable "common_tags" {
  type = map(string)

  default = {
    Owner       = "CloudOps"
    Environment = "dev"
  }
}

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

Corresponding outputs:

```hcl
output "availability_zones" {
  value = var.availability_zones
}

output "server_tags" {
  value = merge(var.common_tags, {
    Environment = var.environment
  })
}

output "server_configuration" {
  value = var.server_config
}
```

Execute:

```bash
terraform fmt
terraform validate
terraform apply
terraform output
```

Expected output names:

```text
availability_zones
project_details
server_configuration
server_tags
```

---

## 17. Explore Terraform Console

Launch the interactive Terraform expression console:

```bash
terraform console
```

Test expressions:

```hcl
var.project_name
```

```hcl
var.availability_zones[0]
```

```hcl
var.common_tags["Owner"]
```

```hcl
var.server_config.instance_type
```

Test `merge()`:

```hcl
merge(var.common_tags, { Environment = var.environment })
```

Exit:

```hcl
exit
```

Or press `Ctrl + D`.

**Explanation:** `terraform console` is useful for testing Terraform expressions, variables, and functions before using them in resources or outputs.

For an environment-specific console session:

```bash
terraform console -var-file="dev.tfvars"
```

---

## 18. Inspect Terraform State

List resources and data sources tracked in state:

```bash
terraform state list
```

For our output-only project, this may return no entries even when root outputs exist.

Display the full state representation:

```bash
terraform show
```

Display the outputs stored in state:

```bash
terraform output
```

**Important:** Terraform state may contain sensitive information. Do not commit it to GitHub or share its contents without reviewing them.

---

## 19. Save a Terraform Plan

Create a saved plan:

```bash
terraform plan -out=day2.tfplan
```

Inspect it:

```bash
terraform show day2.tfplan
```

Apply the saved plan:

```bash
terraform apply day2.tfplan
```

Delete the saved plan after use:

```bash
rm -f day2.tfplan
```

**Important:** Saved Terraform plans can contain sensitive values. Never commit them to a public repository.

---

## 20. Useful Terraform Troubleshooting Commands

Check Terraform version:

```bash
terraform version
```

Check Terraform configuration formatting:

```bash
terraform fmt -check
```

Validate the configuration:

```bash
terraform validate
```

Inspect outputs:

```bash
terraform output
```

Inspect state:

```bash
terraform state list
```

Inspect the current directory:

```bash
pwd
ls -la
```

Check the Git working tree:

```bash
git status
```

---

## 21. Protect Terraform Files Before Git Commit

Recommended `.gitignore` entries:

```gitignore
.terraform/
*.tfstate
*.tfstate.*
*.tfplan
crash.log

# Local or sensitive variables
terraform.tfvars
*.auto.tfvars
*.auto.tfvars.json
```

Keep `.terraform.lock.hcl` tracked in Git.

Non-sensitive `dev.tfvars` and `prod.tfvars` can be committed deliberately as example environment configurations.

Verify ignored files:

```bash
git status --ignored --short
```

Check whether a specific file is ignored:

```bash
git check-ignore -v hands-on/terraform.tfstate
```

If Git is run from the Day 2 parent folder, adjust the path to match the file's location.

---

## 22. Commit Day 2 Learning to GitHub

Navigate to the Day 2 folder:

```bash
cd /workspaces/terraform-zero-to-hero/Hari-Terraform-CloudOps-Learning/Day-02-Variables-and-Outputs
```

Check repository status:

```bash
git status
```

Stage documentation files:

```bash
git add notes.md commands.md interview-questions.md
```

Stage Terraform configuration files:

```bash
git add hands-on/variables.tf hands-on/outputs.tf
```

Optionally stage non-sensitive environment examples:

```bash
git add hands-on/dev.tfvars hands-on/prod.tfvars
```

Review staged changes:

```bash
git diff --cached
```

Commit:

```bash
git commit -m "Complete Day 2 Terraform variables and outputs"
```

Push to GitHub:

```bash
git push origin main
```

**Security:** Before pushing, confirm that no credentials, secrets, state files, or saved plans are staged.

---

## 23. Complete Day 2 Command Reference

| Command | Purpose |
|---|---|
| `terraform init` | Initialize working directory |
| `terraform fmt` | Format Terraform files |
| `terraform validate` | Validate configuration |
| `terraform plan` | Preview changes |
| `terraform apply` | Apply configuration |
| `terraform output` | Display outputs |
| `terraform output -json` | Export outputs as JSON |
| `terraform plan -var="environment=qa"` | Override a variable |
| `terraform plan -var-file="dev.tfvars"` | Use Dev values |
| `terraform plan -var-file="prod.tfvars"` | Use Prod values |
| `terraform console` | Evaluate expressions |
| `terraform state list` | List tracked resources |
| `terraform show` | Inspect current state |
| `terraform plan -out=day2.tfplan` | Save a plan |
| `terraform show day2.tfplan` | Inspect saved plan |
| `terraform version` | Check Terraform version |
| `git status` | Check repository changes |

---

## 24. Day 2 Hands-on Completion Summary

Successfully practiced:

- Terraform variable declarations.
- String, number, boolean, list, map, and object types.
- Default variable values.
- `terraform.tfvars` overrides.
- Command-line variable overrides.
- Variable precedence.
- Development and production variable files.
- Terraform output values.
- Dynamic resource tags using `merge()`.
- Terraform state inspection.
- GitHub repository documentation.

**Final result:** Terraform variables and outputs were evaluated successfully without creating AWS infrastructure.

**Resources created:** 0

**Day 2 Status: Completed.**
