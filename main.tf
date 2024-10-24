provider "aws" {
  region     = var.region_name
  access_key = var.access_key
  secret_key = var.secret_key
}


resource "aws_key_pair" "tf-key-pair" {
  key_name   = "tf-key-pair"
  public_key = tls_private_key.rsa.public_key_openssh
}
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "local_file" "tf-key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "tf-key-pair"
}

module "vpc" {
  source = "./vpcmodule"
}

module "web" {
  source       = "./webmodule"
  vpc_id       = module.vpc.vpc_id
  websubnet_id = module.vpc.websubnet_id
}

module "app" {
  source       = "./appmodule"
  vpc_id       = module.vpc.vpc_id
  appsubnet_id = module.vpc.appsubnet_id
}

module "db" {
  source       = "./dbmodule"
  vpc_id       = module.vpc.vpc_id
  dbsubnet_id  = module.vpc.dbsubnet_id
  appsubnet_id = module.vpc.appsubnet_id
}




