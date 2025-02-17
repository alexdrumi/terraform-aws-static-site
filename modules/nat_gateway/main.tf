resource "aws_eip" "nat_gateway_eip" {
  domain = "vpc"
  count  = length(var.public_subnets)
  
  tags = {
    Name = "NAT-gateway-elasticIP ${count.index + 1}"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  count         = length(var.public_subnets)
  allocation_id = aws_eip.nat_gateway_eip[count.index].id
  subnet_id     = var.public_subnets[count.index] #chose public subnets to set NAT gateway, this is for EC2 instances outbound traffic, (installing script (ubuntu) for website)
  depends_on    = [var.internet_gateway_id]                 #internet gateway needs to be created before NAT

  tags = {
    Name = "NAT-gateway ${count.index + 1}"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = var.vpc_id
  count  = length(var.private_subnet_cidrs)

  route {
    cidr_block     = "0.0.0.0/0"                                 #all ipv4
    nat_gateway_id = aws_nat_gateway.nat_gateway[count.index].id #outbound internet traffic from private subnets to NAT
  }

  tags = {
    Name = "Private routing table ${count.index + 1}"
  }
}

#connect private route table with its corresponding private subnet
resource "aws_route_table_association" "private_subnet_association" {
  count          = length(var.private_subnet_cidrs) #nr of cidr blocks specified
  subnet_id      = var.private_subnets[count.index] #here we dont need id anymore, the var outputs are ids already
  route_table_id = aws_route_table.private_route_table[count.index].id
}
