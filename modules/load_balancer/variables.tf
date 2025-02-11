variable "vpc_id" {
  type        = string  
  description = "VPC ID."  
}

variable "subnets" {
  type        = list(string)
  description = "Public subnet IDs for the load balancer."
}

variable "security_group" { 
  type        = string  
  description = "Security group ID for the load balancer of the security group module."
}

variable "alb_name" { 
  type        = string  
  description = "Name for the Applicatio n load balancer"
  default     = "application-load-balancer"
}