
# #basic aws provider, can change the region later
# provider "aws" {
#   region = "eu-north-1"
# }


# #DONE, in networking
# resource "aws_vpc" "main" {
#   cidr_block = "10.0.0.0/16"

#   tags = {
#     Name = "Project VPC"
#   }
# }


# #DONE, in networking
# #SUBNETS
# resource "aws_subnet" "public_subnets" {
#   count             = length(var.public_subnet_cidrs)
#   vpc_id            = aws_vpc.main.id
#   cidr_block        = element(var.public_subnet_cidrs, count.index)
#   availability_zone = element(var.azs, count.index)

#   tags = {
#     Name = "Public Subnet ${count.index + 1}"
#   }
# }

# #DONE, in networking
# resource "aws_subnet" "private_subnets" {
#   count             = length(var.private_subnet_cidrs)
#   vpc_id            = aws_vpc.main.id
#   cidr_block        = element(var.private_subnet_cidrs, count.index)
#   availability_zone = element(var.azs, count.index)

#   tags = {
#     Name = "Private Subnet ${count.index + 1}"
#   }
# }

# #DONE, in networking
# #INTERNET GATEWAY
# resource "aws_internet_gateway" "gw" {
#   vpc_id = aws_vpc.main.id

#   tags = {
#     Name = "Project VPC InternetGateway"
#   }
# }

# resource "aws_route_table" "second_rt" {
#   vpc_id = aws_vpc.main.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.gw.id
#   }

#   tags = {
#     Name = "2nd Route Table for the Internet Gateway"
#   }
# }

# #DONE, in networking
# #ASSOCIATE PUB SUBNETS WITH SECOND ROUTE TABLE
# resource "aws_route_table_association" "public_subnet_association" {
#   count          = length(var.public_subnet_cidrs)
#   subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
#   route_table_id = aws_route_table.second_rt.id
# }



# #AMI IDS
# data "aws_ami_ids" "ubuntu" {
#   owners = ["099720109477"]
#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"]
#   }
# }


# #DONE IN LOAD BALANCER MAINTF
# #APPLICATION LOAD BALANCER
# resource "aws_lb" "load_balancer" {
#   name                       = "application-load-balancer"
#   load_balancer_type         = "application" #OSI LAYER 7, network w work on OSI LAYER 4
#   security_groups            = [aws_security_group.load_balancer_sg.id]
#   subnets                    = [for subnet in aws_subnet.public_subnets : subnet.id] #in the top of the file we defined this
#   enable_deletion_protection = false                                                 #if this is true, AWS prevents the ALB from being destroyed

#   #depends on the internet gateway
#   depends_on = [aws_internet_gateway.gw]

#   tags = {
#     Name = "application load balancer"
#   }
# }


# #DONE IN LOADBALANCER MODULE
# #TARGET GROUP FOR ALB
# resource "aws_lb_target_group" "lg_target" {
#   name     = "lg-target"
#   port     = 80 #http
#   protocol = "HTTP"
#   vpc_id   = aws_vpc.main.id

#   tags = {
#     Name = "target group for application load balancer"
#   }
#   #health check here?
#   health_check {
#     interval            = 30
#     path                = "/health"
#     protocol            = "HTTP"
#     timeout             = 5
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#     matcher             = "200-299"
#   }
# }

# #DONE IN LOADBALANCER MODULE
# resource "aws_lb_listener" "http" {
#   load_balancer_arn = aws_lb.load_balancer.arn
#   port              = 80
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.lg_target.arn
#   }

#   tags = {
#     Name = "application load balancer target group listener"
#   }
# }

# #DONE IN SECURITY main.tf
# #SECURITY GROUP FOR LOAD BALANCER
# resource "aws_security_group" "load_balancer_sg" {
#   name                   = "load_balancer_sg"
#   description            = "Allowing HTTP and HTTPS inbound from anywhere"
#   vpc_id                 = aws_vpc.main.id
#   revoke_rules_on_delete = true #removes default egress rule on deletion [all outbound to 0.0.0.0/0]

#   #allow inbound HTTP from anywhere
#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   #allow inbound HTTPS from anywhere
#   ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   #allow outbound traffic to the VPC
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["10.0.0.0/16"] #vpc cidr block
#   }

#   tags = {
#     Name = "allow incoming requests to the load balancer from anywhere"
#   }
# }


# #SECURITY GROUP FOR EC2
# resource "aws_security_group" "ec2_sg" {
#   name                   = "ec2_sg"
#   description            = "Allowing traffic from ALB to EC2 instances."
#   vpc_id                 = aws_vpc.main.id
#   revoke_rules_on_delete = true #removes default egress rule on deletion [all outbound to 0.0.0.0/0]

#   ingress {
#     from_port       = 80
#     to_port         = 80
#     protocol        = "tcp"
#     security_groups = [aws_security_group.load_balancer_sg.id]
#   }

#   ingress {
#     from_port       = 443
#     to_port         = 443
#     protocol        = "tcp"
#     security_groups = [aws_security_group.load_balancer_sg.id]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"] #allow all outbound traffic to anywhere
#     # cidr_blocks = ["10.0.0.0/16"] #THIS WAS THE PROBLEM, THE OUTBOUND ACCESS IS RESTRICTED TO INSIDE THE VPC
#   }

#   tags = {
#     Name = "allow traffic from ALB to EC2"
#   }
# }

# #USE LAUNCH CONFIGURATION: TOMORROW FROM HERE
# # Right now, you’re mixing a Launch Template resource with the launch_configuration argument in your ASG. Terraform sees launch_configuration = "my_launch_template" and expects an AWS Launch Configuration resource by that name (i.e., an aws_launch_configuration), but you’ve actually created an aws_launch_template.
# # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration


# #DONE IN COMPUTE MODULE
# #LAUNCH TEMPLATE
# resource "aws_launch_template" "my_launch_template" {
#   name          = "my_launch_template"
#   description   = "my first launch template, hopefully eventually hosting a static site on EC2."
#   instance_type = "t3.micro" #this could be in the variables?
#   image_id      = data.aws_ami_ids.ubuntu.ids[0]

#   #key_name ->gotta setup an ssh key associated w this cfg
#   key_name               = "MyKeyPair"
#   vpc_security_group_ids = [aws_security_group.ec2_sg.id] #sec group for ec2
#   #security_group_ids ->will have to take a look what goes where with load balancer etc

#   # network_interfaces {
#   #   associate_public_ip_address = false
#   #   security_groups = [aws_security_group.ec2_sg.id]
#   # } ->this would have to fully manage security groups, easier if we spun up the default with vpc scgs

#   #the website
#   user_data = filebase64("${path.module}/static.sh")
#   #iam_instance_profile ->more complicated gotta look into it



#   tag_specifications {
#     resource_type = "instance"
#     tags = {
#       Name = "ec2-web-server"
#     }

#     #lifecycle?
#     #create_before_destroy = true
#   }
# }

# #DONE, COMPUTE MODULE
# #AUTOSCALING GROUP -> must be part of security groups?
# resource "aws_autoscaling_group" "static-web-ec2-autoscaling-group" {
#   desired_capacity = 3
#   max_size         = 5
#   min_size         = 1

#   #attach the alb target group directly
#   target_group_arns = [aws_lb_target_group.lg_target.arn]

#   #https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group
#   #here the autoscaling group doesnt see the launch template for some reason.
#   vpc_zone_identifier = [for subnet in aws_subnet.private_subnets : subnet.id]
#   launch_template {
#     id      = aws_launch_template.my_launch_template.id
#     version = "$Latest"
#   }
#   #attach policies for scaling based on cpu util etc
#   health_check_type         = "ELB" #could be EC2 or ELB
#   health_check_grace_period = 300 #ms?
#   force_delete              = true

# }

# #DONE, COMPUTE  MODULE
# #SCALE UP AND DOWN POLICIES
# resource "aws_autoscaling_policy" "scale_up_policy" {
#   name                   = "scale-up-policy"
#   scaling_adjustment     = 1
#   adjustment_type        = "ChangeInCapacity"
#   cooldown               = 300                                                       #ms?
#   autoscaling_group_name = aws_autoscaling_group.static-web-ec2-autoscaling-group.id #link to the autoscaling group
# }


# resource "aws_autoscaling_policy" "scale_down_policy" {
#   name                   = "scale-down-policy"
#   scaling_adjustment     = -1
#   adjustment_type        = "ChangeInCapacity"
#   cooldown               = 300                                                       #ms?
#   autoscaling_group_name = aws_autoscaling_group.static-web-ec2-autoscaling-group.id #link to the autoscaling group
# }



# #CLOUDFRONT DISTRIBUTION FOR ALB
# resource "aws_cloudfront_distribution" "lbs_distribution" {
#   #https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution
#   #whether the distribution is enabled to accept end user requests for content.
#   enabled = true

#   origin {
#     domain_name = aws_lb.load_balancer.dns_name #https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb
#     origin_id   = aws_lb.load_balancer.id       #?string or can give the id

#     #s3 would have s3_origin_config but this is alb
#     custom_origin_config {
#       #we can either connect via HTTP without SSL certificate, or create one manually for HTTPS
#       http_port              = 80
#       https_port             = 443
#       origin_protocol_policy = "http-only"
#       origin_ssl_protocols   = ["TLSv1.2"]
#     }
#   }

#   default_cache_behavior {
#     allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
#     cached_methods   = ["GET", "HEAD"] #thats why to use cloudfront
#     target_origin_id = aws_lb.load_balancer.id

#     #if we would need dynamic content we would forward the cookies and set query string to true, this is a static site
#     forwarded_values {
#       query_string = false
#       cookies {
#         forward = "none"
#       }
#     }

#     viewer_protocol_policy = "allow-all"
#     min_ttl                = 0
#     default_ttl            = 3600
#     max_ttl                = 86400
#   }

#   viewer_certificate {
#     cloudfront_default_certificate = true
#   }

#   restrictions {
#     geo_restriction {
#       restriction_type = "none"
#     }
#   }

#   tags = {
#     Name = "cloudfront distribution to application load balancer"
#   }
# }


# output "cloudfront_domain_name" {
#   description = "CloudFront domain to access alb"
#   value       = aws_cloudfront_distribution.lbs_distribution.domain_name
# }


# #output the Autoscaling Group details
# output "autoscaling_group_details" {
#   value = aws_autoscaling_group.static-web-ec2-autoscaling-group.id
# }

# output "alb_dns_name" {
#   description = "DNS name of the ALB"
#   value       = aws_lb.load_balancer.dns_name
# }



# #DONE, NAT GATEWAY
# #nat gateway with elastic ip
# resource "aws_eip" "nat_gateway_eip" {
#   domain = "vpc"
#   count  = length(var.public_subnet_cidrs)
#   tags = {
#     Name = "NAT-gateway-elasticIP ${count.index + 1}"
#   }
# }

# #DONE
# #create nat gateways for each public subnet
# resource "aws_nat_gateway" "nat_gateway" {
#   count         = length(var.public_subnet_cidrs)
#   allocation_id = aws_eip.nat_gateway_eip[count.index].id
#   subnet_id     = aws_subnet.public_subnets[count.index].id #chose public subnets to set NAT gateway, this is for EC2 instances outbound traffic, (installing script (ubuntu) for website)
#   depends_on    = [aws_internet_gateway.gw]                 #internet gateway needs to be created before NAT

#   tags = {
#     Name = "NAT-gateway ${count.index + 1}"
#   }
# }

# #create route tables for each private subnet
# resource "aws_route_table" "private_route_table" {
#   vpc_id = aws_vpc.main.id
#   count  = length(var.private_subnet_cidrs)

#   route {
#     cidr_block     = "0.0.0.0/0"                                 #all ipv4
#     nat_gateway_id = aws_nat_gateway.nat_gateway[count.index].id #outbound internet traffic from private subnets to NAT
#   }

#   tags = {
#     Name = "Private routing table ${count.index + 1}"
#   }
# }

# #connect private route table with its corresponding private subnet
# resource "aws_route_table_association" "private_subnet_association" {
#   count          = length(var.private_subnet_cidrs) #nr of cidr blocks specified
#   subnet_id      = aws_subnet.private_subnets[count.index].id
#   route_table_id = aws_route_table.private_route_table[count.index].id
# }
