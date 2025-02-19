#Launch template for EC2 instances
#ideally i could pass this from the root but I just couldnt solve it
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]  # Canonical's official Ubuntu owner ID

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]  # Ensures it's for AMD64 architecture
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]  # Ensures it's an HVM-based image
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]  # Ensures it's an EBS-backed image
  }
}

resource "aws_launch_template" "my_launch_template" {
  name          = "my_launch_template"
  description   = "My first launch template for hosting a statis EC2 instance."
  instance_type = var.instance_type
  # image_id      = var.instance_type
  # image_id      = data.aws_ami_ids.ubuntu.ids[0]
  image_id = data.aws_ami.ubuntu.id


#   key_name               = "MyKeyPair"
    key_name               = var.key_name
    
    vpc_security_group_ids = [var.ec2_security_group] #sec group for ec2
    
    #the script to install apache and run dummy html site
    user_data = filebase64("${path.module}/static.sh")

    tag_specifications {
        resource_type = "instance"
        tags = {
        Name = "ec2-web-server"
    }
    #lifecycle?
    #create_before_destroy = true
  }
}

 
resource "aws_autoscaling_group" "static-web-ec2-autoscaling-group" {
  #https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group.html
  desired_capacity = 3
  max_size         = 5
  min_size         = 0 #can this be 0 completely when server is not requested for serving client requests? cost saving but startup will be delayed

  #https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group
#   vpc_zone_identifier = [for subnet in aws_subnet.private_subnets : subnet.id]
  vpc_zone_identifier = var.private_subnets

  launch_template {
    id      = aws_launch_template.my_launch_template.id
    version = "$Latest"
  }

 
  #attach the alb target group directly
  target_group_arns = [var.target_group_arn] #no need for .arn anymore since variables have that

  #attach policies for scaling based on cpu util etc
  health_check_type         = "ELB" #could be EC2 or ELB
  health_check_grace_period = 300 #ms?
  
  force_delete              = true
 tag {
    key                 = "Name"
    value               = "Webserver-ASG"
    propagate_at_launch = true
  }
  #tags?
}
 

#SCALE UP AND DOWN POLICIES
resource "aws_autoscaling_policy" "scale_up_policy" {
  name                   = "scale-up-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300                                                       #ms?
  autoscaling_group_name = aws_autoscaling_group.static-web-ec2-autoscaling-group.id #link to the autoscaling group
}


resource "aws_autoscaling_policy" "scale_down_policy" {
  name                   = "scale-down-policy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300                                                       #ms?
  autoscaling_group_name = aws_autoscaling_group.static-web-ec2-autoscaling-group.id #link to the autoscaling group
}
