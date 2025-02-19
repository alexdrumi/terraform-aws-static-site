variable "vpc_id" { 
  type        = string 
  description = "VPC ID for launching instances."
}

variable "private_subnets" {  
  type        = list(string) 
  description = "List of private subnet IDs for EC2 instances." 
}

# variable "ami_id" { 
#   type        = string 
#   description = "AMI ID for the EC2instances." 
#   # default = ""#otherwise this will prompt me for the ID
# }

variable "instance_type" {
  type        = string
  description = "EC2 instance type."
  default     = "t3.micro"
}

variable "key_name" {
  type        = string  
  description = "SSH key pair name."
}

variable "ec2_security_group" {   
  type        = string  
  description = "Security group ID for the security modiule of EC2 instances"
}

variable "target_group_arn" {
  type        = string 
  description = "Target Group ARN for the Auto scaling group."
}

#autoscaling group name?