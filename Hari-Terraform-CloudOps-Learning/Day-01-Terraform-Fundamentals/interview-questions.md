## 10. Key Interview Questions

### Q1. What is Infrastructure as Code?
IaC is the practice of provisioning and managing infrastructure through code rather than manual configuration.

### Q2. What is Terraform?
Terraform is a declarative Infrastructure as Code tool used to provision and manage infrastructure across multiple platforms.

### Q3. What is Terraform Core?
Terraform Core evaluates configurations, builds dependencies, generates execution plans, and coordinates infrastructure changes.

### Q4. What is a Terraform provider?
A provider is a plugin that allows Terraform to interact with external APIs such as AWS APIs.

### Q5. What is a Terraform resource?
A resource represents an infrastructure object managed by Terraform, such as an EC2 instance or S3 bucket.

### Q6. What is Terraform state?
Terraform state stores information about managed infrastructure and maps Terraform resources to actual infrastructure objects.

### Q7. What is the difference between Terraform Core and a provider?
Terraform Core determines and coordinates required changes. Providers interact with external APIs to read and manage resources.

### Q8. What is HCL?
HCL stands for HashiCorp Configuration Language. It is the configuration language commonly used to write Terraform files.

### Q9. Can Terraform manage multiple cloud providers?
Yes. Terraform can manage resources across AWS, Azure, Google Cloud, and other supported services.

### Q10. Why should Terraform state not be committed to GitHub?
Terraform state may contain sensitive information, including resource attributes and secrets. It should be protected using secure state storage and access controls.

---

**Learning Status:** Terraform Fundamentals and Architecture completed.

**Next Topic:** Terraform Lifecycle Commands and First AWS Hands-on Exercise.
