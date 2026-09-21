module "ecomm_vpc" {
    source = "./modules/vpc"
    vpc_cidr = "192.168.0.0/16"
    public_subnet_cidr = "192.168.0.0/24"
    availability_zone = "eu-north-1a"
    vpc_name          = "ecomm"
}

module "ecomm_ec2" {
    source = "./modules/ec2"
    ami    = "ami-0aba19e56f3eaec05"
    instance_type = "t3.micro"
    key_name      = "aws2603"
    subnet_id     = module.ecomm_vpc.public_subnet_id
    vpc_security_group_ids = [module.ecomm_vpc.web_sg_id]
    user_data     = file("ecomm-script.sh")
    instance_name = "ecomm-web-server"
}

output "ecomm_instance_ip" {
    value = module.ecomm_ec2.instance_ip
}
