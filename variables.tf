variable "subnet_ids" {
  description = "List of subnet IDs for the ElastiCache subnet group"
  type        = list(string)
  validation {
    condition     = length(var.subnet_ids) >= 1
    error_message = "At least one subnet ID is required."
  }
}

variable "description" {
  description = "Description of the subnet group"
  type        = string
  default     = null
}
