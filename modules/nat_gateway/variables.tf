variable "vpc_id" {
    type = string
    description = "VPC ID of the NAT gateway created"
}

variable "public_subnets" {
    type = list(string)
    description = "Public subnet IDs where NAT gateways will be deployed"
}

variable "private_subnets" {
    type = list(string)
    description = "Private subnetsfor which route tables will be created"
}

variable "private_subnet_cidrs" {
    type = list(string)
    description = "Private subnetsfor CIDRs"

}

variable "internet_gateway_id" {
    type = string
    description = "Internet gateway ID"    
}