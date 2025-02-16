output "alb_dns_name" {
  description = "DNS name of the Application load balancer."
  value       = aws_lb.load_balancer.dns_name
}

output "alb_dns_id" {
  description = "DNS id of the Application load balancer."
  value       = aws_lb.load_balancer.id
}

output "target_group_arn" {
  description = "ARN of the Target Group for the ALB."
  value       = aws_lb_target_group.lg_target.arn
}