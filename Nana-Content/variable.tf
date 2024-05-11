#### Method 1
variable "dev-vpc-cidr_block" {
    type = string
    default = "172.15.0.0/16"
    description = "This is the CIDR block variable of the dev VPC"
}

#### Method 2           ### Define default value in the terraform.tfvars file
variable "dev-vpc-cidr_block" {
    type = string
    description = "This is the CIDR block variable of the dev VPC"
}

variable "dev-vpc-tag" {
    type = string
    description = "this is the tag of the dev vpc"
}

variable "cidr_blocks" {
    description = "This is the cidr blocks represent in the object"
    type = lsit(object({   
        cidr_block = string,
        name = string
        }))
}