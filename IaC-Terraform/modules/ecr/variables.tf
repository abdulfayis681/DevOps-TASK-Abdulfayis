variable "repository_name" {
  description = "The name of the ECR repository"
  type        = string
}

variable "expiration_after_days" {
  description = "Number of days after which images expire"
  type        = number
  default     = 0
}

variable "tags" {
  description = "Tags to apply to the repository"
  type        = map(string)
  default     = {}
}
