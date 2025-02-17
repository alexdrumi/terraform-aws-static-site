output "launch_template_id" {   
  description = "ID ofthe launch template for web servers." 
  value       = aws_launch_template.my_launch_template.id
}  

output "autoscaling_group_id" { 
  description = "ID of the Auto Scaling Group for web servers."
  value       = aws_autoscaling_group.static-web-ec2-autoscaling-group.id
 
}

output "scale_down_policy" {
  description = "Scale down policy ARN"
  value = aws_autoscaling_policy.scale_down_policy.arn
 
} 

output "scale_up_policy" {
  description = "Scale up policy ARN"
  value = aws_autoscaling_policy.scale_up_policy
  
}