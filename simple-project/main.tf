provider "aws" {
    region = "us-west-2"
}

############################################ VPC ############################################
#############################################################################################
resource "aws_vpc" "simple_app_vpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
        Name = "${var.env_prefix}-VPC"
    }
}

############################################ Subnet #########################################
#############################################################################################
resource "aws_subnet" "subnet1" {
    vpc_id = aws_vpc.simple_app_vpc.id
    cidr_block = var.subnet_cidr_block
    availability_zone = var.availability_zone
    tags = {
        Name = "${var.env_prefix}-subnet1"
    }
}

######################################## Internet Gateway ###################################
#############################################################################################
resource "aws_internet_gateway" "simple_app_igw" {
    vpc_id = aws_vpc.simple_app_vpc.id
    tags = {
        Name = "${var.env_prefix}-igw"
    }
}

####################### Using Default Route Table of the VPC that we created ################
#############################################################################################
resource "aws_default_route_table" "simple_app_rtb" {
    default_route_table_id = aws_vpc.simple_app_vpc.default_route_table_id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.simple_app_igw.id
    }
    tags = {
        Name = "${var.env_prefix}-rtb"
    }
}

################################### Create Route Table ######################################
#############################################################################################
/*
resource "aws_route_table" "simple_app_route-table" {
    vpc_id = aws_vpc.simple_app_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.simple_app_igw.id
    }
    tags = {
        Name = "${var.env_prefix}-rtb"
    }
}
*/

################################### Subnet Association in Route #############################
#############################################################################################
/* 
resource "aws_route_table_association" "a-rtb-subnet" {
    route_table_id = aws_route_table.simple_app_route-table.id
    subnet_id = aws_subnet.subnet1.id
}
*/

########## using default Security Group of the simple app VPC for the EC2 Instance ##########
#############################################################################################
resource "aws_default_security_group" "simple_app_default_sg"{
    vpc_id = aws_vpc.simple_app_vpc.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks =  [var.my_ip]
    }

    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks =  ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks =  ["0.0.0.0/0"] 
        prefix_list_ids = []
    }
    tags = {
        Name = "${var.env_prefix}-default-sg"
    }
}

####################### Create Security Group for the EC2 Instance  ########################
#############################################################################################
/*
resource "aws_security_group" "simple_app_sg"{
    name = "simple_app_sg"
    vpc_id = aws_vpc.simple_app_vpc.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks =  [var.my_ip]
    }

    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks =  ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks =  ["0.0.0.0/0"] 
        prefix_list_ids = []
    }
    tags = {
        Name = "${var.env_prefix}-sg"
    }
}
*/

#################################### Create EC2 Instance ####################################
#############################################################################################

#### Fetch dynamic Amazon AMI
data "aws_ami" "latest-amazon-linux-image" {
    most_recent = true
    owners = ["amazon"]
    filter {
        name = "name"
        values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
}

#### Show the ID of the Amazon AMI
output "aws_ami_id" {
    value = data.aws_ami.latest-amazon-linux-image.id
}

#### Create key-pair
resource "aws_key_pair" "ssh-key" {
    key_name = "simple-app-key"
    public_key = file(var.public_key_location)
}

#### EC2 Server
resource "aws_instance" "simple-app_server" {
    ami = data.aws_ami.latest-amazon-linux-image.id
    instance_type = var.instance_type

    subnet_id = aws_subnet.subnet1.id
    vpc_security_group_ids = [aws_default_security_group.simple_app_default_sg]
    availability_zone = var.availability_zone

    associate_public_ip_address = true
    key_name = aws_key_pair.ssh-key.key_name

#### Method 1 of adding user data
    # user_data = <<EOF 
    #                 #!/bin/bash
    #                 sudo yum update -y && sudo yum upgrade -y
    #                 sudo yum install -y docker
    #                 sudo systemctl start docker
    #                 sudo usermod -aG docker ec2-user
    #                 docker run -p 8080:80 nginx
    #             EOF

#### Method 2 of adding user data
    # user_data = file("script.sh")

#### Method 3 of adding user data by Provisioners
## define how provisioner 
    connection {
        type = "ssh"
        host = self.public_ip
        user = "ec2-user"
        private_key = file(var.private_key_location)
    }
## Provisioner to copy file from local to remote server
provisioner "file" {
    source = "script.sh"
    destination = "/home/ec2-user/script-on-ec2.sh"
}

## Provisioner to run script on EC2 Server
    provisioner "remote-exec" {
        script = file("script-on-ec2.sh")
        # inline = [
        #     "sudo yum update -y && sudo yum upgrade -y",
        #     "sudo yum install -y docker",
        #     "sudo systemctl start docker",
        #     "sudo usermod -aG docker ec2-user",
        #     "docker run -p 8080:80 nginx"
        # ]
    }

    tags = {
        Name = "${var.env_prefix}-server"
    }
}

#### Show public IP of the EC2 instance
output "ec2_public_ip" {
    value = aws_instance.simple-app_server.public_ip
}