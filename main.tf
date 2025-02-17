terraform {
  required_version = ">= 1.0.0"
  required_providers {  
    aws = {
      source  = "hashicorp/aws"   
      version = "~> 5.0"  
    }   
  }
}

provider "aws" {
  region = "eu-north-1"
}

#not sure how to set this one into variables
data "aws_ami_ids" "ubuntu" {
  owners = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"]
  }
}

#deploy network related modules (vpc, subnets, igw)
module "networking" {
    source = "./modules/networking"
    public_subnet_cidrs =  var.public_subnet_cidrs 
    private_subnet_cidrs = var.private_subnet_cidrs
    azs = var.azs  
    vpc_cidr = var.vpc_cidr
    
}

#security groups for alb and ec2
module "security" {
  source = "./modules/security"
  vpc_id = module.networking.vpc_id
}

#call the nat gateway using outputs from networking module
module "natgateway" {
    source = "./modules/nat_gateway" #why does this work without _ when the module name has _?
    vpc_id = module.networking.vpc_id 
    public_subnets = module.networking.public_subnets  
    private_subnets = module.networking.private_subnets 
    private_subnet_cidrs = var.private_subnet_cidrs 
    internet_gateway_id  = module.networking.internet_gateway_id   
}

#loadbalancer module
module "loadbalancer" {
  source         = "./modules/load_balancer"
  vpc_id         = module.networking.vpc_id
  subnets        = module.networking.public_subnets
  security_group = module.security.load_balancer_sg_id
  #desired target group name, etc  here?
}

#compoute module
module "compute" {
  source              = "./modules/compute"
  vpc_id              =  module.networking.vpc_id
  private_subnets  = module.networking.private_subnets
  ami_id              = data.aws_ami_ids.ubuntu.id
  instance_type      = var.instance_type 
  key_name            = var.key_name   
  ec2_security_group  = module.security.ec2_sg_id
  target_group_arn   = module.loadbalancer.target_group_arn
 
 }

#cloudfront
module "cloudfront" {
  source            = "./modules/cloudfront"
  alb_dns_id = module.loadbalancer.alb_dns_id #problem 2?
  alb_dns_name   = module.loadbalancer.alb_dns_name
}

