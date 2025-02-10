

#SECURITY GROUP FOR LOAD BALANCER
resource "aws_security_group" "load_balancer_sg" {
  name                   = "load_balancer_sg"
  description            = "Allowing HTTP and HTTPS inbound from anywhere"
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = true #removes default egress rule on deletion [all outbound to 0.0.0.0/0]

  #allow inbound HTTP from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowed_http_cird
  }

  #allow inbound HTTPS from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.allowed_https_cird
  }

  #allow outbound traffic to the VPC
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.allowed_lb_egress #vpc cidr block
  }

  tags = {
    Name = "ALB security group. Allow incoming requests to the load balancer from anywhere, limiting outbound to VPC"
  }
}


#SECURITY GROUP FOR EC2
resource "aws_security_group" "ec2_sg" { 
  name                   = "ec2_sg"
  description            = "Allowing traffic from ALB to EC2 instances."
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = true #removes default egress rule on deletion [all outbound to 0.0.0.0/0]

  ingress {
    from_port       = 80 
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.load_balancer_sg.id]
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.load_balancer_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0 
    protocol    = "-1"
    cidr_blocks = var.allowed_ec2_egress #allow all outbound traffic to anywhere
    # cidr_blocks = ["10.0.0.0/16"] #THIS WAS THE PROBLEM, THE OUTBOUND ACCESS IS RESTRICTED TO INSIDE THE VPC
  }

  tags = { 
    Name = "EC2 security group"
  }
}
