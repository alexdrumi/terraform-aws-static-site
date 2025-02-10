output "load_balancer_sg_id" {
  description = "The security group ID for the load balancer."  
  value       = aws_security_group.load_balancer_sg.id  
}
  
output "ec2_sg_id" { 
  description = "The security group ID for EC2 instances."   
  value       = aws_security_group.ec2_sg.id 
} 