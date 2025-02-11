output "launch_template_id" {   
  description = "ID ofthe launch template for web servers." 
  value       = aws_launch_template.web_server.id
}

output "autoscaling_group_id" { 
  description = "ID of the Auto Scaling Group for web servers."
  value       = aws_autoscaling_group.web_asg.id 
 
}