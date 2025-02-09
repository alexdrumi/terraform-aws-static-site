output "nat_gateway_ids" {
    description = "IDs of NAT Gateways"
    value = aws_nat_gateway.nat_gateway[*].id
}

output "private_route_table_ids" {
    description = "IDs the private route table"
    value = aws_route_table.private_route_table[*].id
}