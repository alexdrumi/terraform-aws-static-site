variable "vpc_cidr" {    
  type        = string   
  description = "Global VPC CIDR"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type        = list(string)  
  description = "Global public subnet CIDRs"  
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
 description = "Global private subnet CIDRs"
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "azs" {  
  type        = list(string) 
  description = "Availability zones" 
  default     = ["eu-north-1a", "eu-north-1b", "eu-north-1c"]
} 

variable "ami_id" {
  type        = string 
  description = "AMI ID for  EC2 instances"   
}   


variable "key_name" {  
 type        = string
  description = "SSH key-pair name."  
} 

variable "instance_type" {  
  type        = string 
  description = "EC2 instance type."
  default     = "t3.micro"
}  