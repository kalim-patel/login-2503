module "login_vpc" {
    source = "./modules/vpc"
    vpc_cidr = "10.0.0.0/16"
    public_subnet_cidr = "10.0.0.0/24"
    availability_zone = "us-east-2a"
    vpc_name          = "login"
}

module "login_ec2" {
    source = "./modules/ec2"
    ami    = "ami-0aba19e56f3eaec05"
    instance_type = "t3.micro"
    key_name      = "aws2603"
    subnet_id     = module.login_vpc.public_subnet_id
    vpc_security_group_ids = [module.login_vpc.web_sg_id]
    user_data     = file("login-script.sh")
    instance_name = "login-web-server"
}

output "instance_ip" {
    value = module.login_ec2.instance_ip
}
