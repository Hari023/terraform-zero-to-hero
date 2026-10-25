variable "project_name" {
  description = "CloudOps project name"
  type        = string
  default     = "terraform-cloudops"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "instance_count" {
  description = "Number of EC2 instances"
  type        = number
  default     = 1
}

variable "enable_monitoring" {
  description = "Enable EC2 detailed monitoring"
  type        = bool
  default     = false
}

variable "availability_zones" {
  description = "AWS availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "common_tags" {
  description = "Common AWS resource tags"
  type        = map(string)

  default = {
    Owner       = "CloudOps"
    Environment = "dev"
  }
}

variable "server_config" {
  description = "EC2 server configuration"

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