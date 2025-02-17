output "vpc_id" {
    description = "VPC id"
    value = aws_vpc.main.id
}
output "vpc_cidr" {
    description = "VPC CIDR block"
    value = var.vpc_cidr
}

output "public_subnets" {
    description = "List of public subnet IDs"
    value = aws_subnet.public_subnets[*].id
}

output "private_subnets" {
    description = "List of private subnet IDs"
    value = aws_subnet.private_subnets[*].id
}

output "availability_zones" {
    description = "List of availability zones"
    value = var.azs
}

output "internet_gateway_id" {
    description = "Internet Gateway ID"
    value = aws_internet_gateway.gw.id
}