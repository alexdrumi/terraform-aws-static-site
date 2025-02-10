variable "vpc_id" {
    type = string  
    description = "VPC ID of the NAT gateway created"
}

variable "allowed_http_cird" { 
    type = list(string)
    description = "Allowed  CIDR blocks for http inbound"
    default = ["0.0.0.0/0"] #any adress really
}
  
variable "allowed_https_cird" {
    type = list(string)
    description = "Allowed CIDR blocks for https inbound"
    default = ["0.0.0.0/0"] #any adress really
}

variable "allowed_ec2_egress" {
    type = list(string)
    description = "Allowed CIDR blocks for EC2 outbound"
    default = ["0.0.0.0/0"] #any adress really, this is restricted for load balancer
}

variable "allowed_lb_egress" {
    type = list(string)
    description = "Allowed CIDR blocks for EC2 outbound"
    default = ["10.0.0.0/16"] #better to restrict this inside VPC
}