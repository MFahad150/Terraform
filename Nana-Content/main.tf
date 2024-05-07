################################# Create VPC ################################################
#############################################################################################

#### Create new VPC
resource "aws_vpc" "dev-vpc" {
    cidr_block = "172.15.0.0/16"
    tags = {
        Name = "dev-vpc"
    }
}

#### Output Variable that show the id of the resource
output "dev-vpc_id" {
    value = aws_vpc.dev-vpc.id
}


#### Create subnet in new VPC
resource "aws_subnet" "dev-subnet-1" {
    vpc_id = aws_vpc.dev-vpc.id
    cidr_block = "172.15.1.0/24"
    availability_zone = "us-west-2a"
    tags = {
        Name = "dev-subnet-1"
    }
}

#### Output Variable that show the id of the resource
output "dev-subnet-1_id" {
    value = aws_subnet.dev-subnet-1.id
}


#### Load default VPC
data "aws_vpc" "exciting-vpc" {
    default = true
}

#### Output Variable that show the id of the resource
output "exciting-vpc_id" {
    value = aws_vpc.exciting-vpc.id
}


#### Create subnet in default VPC
resource "aws_subnet" "subnet-7" {
    vpc_id = data.aws_vpc.exciting-vpc.id
    cidr_block = "172.31.1.0/24"
    availability_zone = "us-west-2a"
    tags = {
        Name = "subnet-7"
    }
}

#### Output Variable that show the id of the resource
output "subnet-7_id" {
    value = aws_subnet.subnet-7.id
}