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


#deploy network related modules (vpc, subnets, igw)
module "networking" {
    source = "./modules/networking"
    public_subnet_cidrs =  var.public_subnet_cidrs 
    private_subnet_cidrs = var.private_subnet_cidrs
    azs = var.azs  
    vpc_cidr = var.vpc_cidr
}

#call the nat gateway using outputs from networking module
module "natgateway" {
    source = "./modules/natgateway" #why does this work without _ when the module name has _?
    vpc_id = module.networking.vpc_id 
    public_subnets = module.networking.public_subnets  
    private_subnets = module.networking.private_subnets 
    private_subnet_cidrs = var.private_subnet_cidrs 
    internet_gateway_id  = module.networking.internet_gateway_id   
}
