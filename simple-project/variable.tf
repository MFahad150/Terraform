variable "vpc_cidr_block" {
    type = string
    default = "185.50.0.0/16"
    description = "CIDR Block of the VPC"
}

variable "subnet_cidr_block" {
    type = string
    default = "185.50.1.0/24"
    description = "CIDR Block of the subnet1"
}

variable "availability_zone" {
    type = string
    default = "us-west-2a"
    description = "Subnet within the Availability zone"
}

variable "env_prefix" {
    type = string
    default= "dev"
}

variable "my_ip" {
    default = "111.88.33.59/32"
    type = string
    description = "This is my PC ip address"
}

variable "instance_type" {
    default = "t2.micro"
    type = string
    description = "Instance type of the simple-app-server" 
}

variable "public_key_location" {
    default = "/home/fahad/.ssh/id_rsa.pub"
    type = string
    description = "public key to access the simple-app-server"
}

variable "private_key_location" {
    default = "/home/fahad/.ssh/id_rsa"
    type = string
    description = "Location of the private key for provisioner to connect"
}