############################################## Create IAM User with Terraform  #######################################################
######################################################################################################################################

# resource "aws_iam_user" "Technical-Lead" {
#     name = "Perry"
#     tags ={
#         Description = "Technical Lead of the Project"
#     }
# }

######################  Method1 of Policy adding  ###############################

# resource "aws_iam_policy" "administrationAccess" {
#     name = "adminAccess"
#     policy = <<EOF
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Action": "*",
#             "Resource": "*"
#         }
#     ]
# }
#     EOF
# }

#######################  Method2 of Policy adding  ###############################
# resource "aws_iam_policy" "administrationAccess" {
#     name = "adminAccess"
#     policy = file("admin-policy.json")
# }

# resource "aws_iam_user_policy_attachment" "Perry-Admin-Access" {
#     user       = aws_iam_user.Technical-Lead.name
#     policy_arn = aws_iam_policy.administrationAccess.arn
# }


######################################################################################################################################
######################################################################################################################################




############################################## Create S3 Bucket with Terraform  ######################################################
######################################################################################################################################


# ## Create Bucket
# resource "aws_s3_bucket" "S3withTerraform" {
#     bucket = "s3withterraform-jwt098"
#     tags = {
#         Description = "Demo S3 bucket"
#     }
# }

# ## Store objects in Bucket
# resource "aws_s3_bucket_object" "S3withTerraformObject" {
#     content = "/home/fahad/Terraform/terraform-with-AWS/iam-admin-policy.json"
#     key = "iam-admin-policy.json"
#     bucket = aws_s3_bucket.S3withTerraform.id
# }

# ## Data Source (Existing IAM group)
# data "aws_iam_group" "Bucket-Data" {
#     group_name = "S3BucketPolicy"
# }

# ## Bucket Policy Method no. 1 
# resource "" "" {
#     bucket = aws_s3_bucket.S3withTerraform.id
#     policy = <<EOF
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Action": "*",
#             "Resource": "arn:aws:s3:::${aws_s3_bucket.S3withTerraform.id}/*",
#             "Principle": {
#                 "AWS": [
#                     "${data.aws_iam_group.Bucket_Data.arn}"
#                 ]
#             }
#         }
#     ]
# }
#     EOF
# }

## Bucket Policy Method no. 2
# resource "" "" {
#     bucket = aws_s3_bucket.S3withTerraform.id
#     policy = file("bucket-policy.json")
# }


######################################################################################################################################
######################################################################################################################################




############################################## Create DynamoDB Databasewith Terraform  ###############################################
######################################################################################################################################

# resource "aws_dynamodb_table" "cars" {
#     name = "cars"
#     hash_key = "VIN"
#     billing_mode = "PAY_PER_REQUEST"
#     attribute {
#         name = "VIN"
#         type = "S"
#     }
# }

# resource "aws_dynamodb_table_item" "car_items" {
#     table_name = aws_dynamodb_table.cars.name
#     hash_key = aws_dynamodb_table.cars.hash_key
#     item = <<EOF
# {
#     "Manufacturer": {"S": "Toyota"},
#     "Make": {"S": "Corrolla"},
#     "Year": {"N": "2004"},
#     "VIN": {"S": "FHVFYHBSFSIOYOYUI563357"}
# }
# {
#     "Manufacturer": {"S": "Honda"},
#     "Make": {"S": "Civic"},
#     "Year": {"N": "2017"},
#     "VIN": {"S": "WQPYTRSFSIOYOY63357"}
# }
# {
#     "Manufacturer": {"S": "Ford"},
#     "Make": {"S": "F150"},
#     "Year": {"N": "2020"},
#     "VIN": {"S": "WUYTREBKKSIOYOY63357"}
# }
#     EOF
# }

# resource "aws_dynamodb_table_item" "car_items" {
#     table_name = aws_dynamodb_table.cars.name
#     hash_key = aws_dynamodb_table.cars.hash_key
#     item = <<EOF
# {
#     "Manufacturer": {"S": "Honda"},
#     "Make": {"S": "Civic"},
#     "Year": {"N": "2017"},
#     "VIN": {"S": "WQPYTRSFSIOYOY63357"}
# }
# {
#     "Manufacturer": {"S": "Ford"},
#     "Make": {"S": "F150"},
#     "Year": {"N": "2020"},
#     "VIN": {"S": "WUYTREBKKSIOYOY63357"}
# }
#     EOF
# }

######################################################################################################################################
######################################################################################################################################



#################################### Terraform with EC2 Instance  ####################################################################
######################################################################################################################################

resource "aws_instance" "webserver" {
    ami = "" 
    instance_type = "t2.micro"
    tags = {
        Name = "webserver"
        Description = "An NGINX webserver on Ubuntu"
    }
    key_name = aws_key_pair.public_key.id
    vpc_security_group_ids = [ aws_security_group.webserver-securityGroup.id ]
    user_data = <<EOF
#!/bin/bash
sudo apt update && sudo apt upgrade
sudo apt install nginx -y
systemctl enable nginx
systemctl start nginx
    EOF
}

############# Adding key Pair to EC2 instance - Preferred Method
resource "aws_key_pair" "public_key" {
    public_key = file(/home/fahad/.ssh/key.pub)
}


############# Adding key Pair to EC2 instance - Method 2
# resource "aws_key_pair" "public_key" {
#     public_key = "ssh-rsaHJIATYIDOYAGIDFYFDYUWPITGEUI&*%%#$@!826378527647634vhfuffyuevhag8273923-9t1273t137t17t4179"
# }

################# Security Group
resource "aws_security_group" "webserver-securityGroup" {
    name = "webserver-securityGroup"
    description = "Security Group of the Webserver"
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"] 
    }
}

######### Output variable to show public Ip of the EC2 instance

output publicIP {
  value       = aws_instance.webserver.public-ip
  description = "to show public Ip of the EC2 instance"
}


#################################### Terraform Provisioners  #########################################################################
########### Remote Exec Provisioner
resource "aws_instance" "webserver" {
    ami = "" 
    instance_type = "t2.micro"
    tags = {
        Name = "webserver"
        Description = "An NGINX webserver on Ubuntu"
    }
    key_name = aws_key_pair.public_key.id
    vpc_security_group_ids = [ aws_security_group.webserver-securityGroup.id ]
 provisioner "remote-exec" {
    inline = [
    "sudo apt update && sudo apt upgrade",
    "sudo apt install nginx -y",
    "systemctl enable nginx",
    "systemctl start nginx"
    ]
    }
    connection {
        type = "ssh"
        host = self.public_ip
        user = "ubuntu"
        private_key = file(/home/fahad/.ssh/key.pub)
    }
}


########### Local Exec Provisioner
resource "aws_instance" "webserver" {
    ami = "" 
    instance_type = "t2.micro"
    tags = {
        Name = "webserver"
        Description = "An NGINX webserver on Ubuntu"
    }
    key_name = aws_key_pair.public_key.id
    vpc_security_group_ids = [ aws_security_group.webserver-securityGroup.id ]
 provisioner "local-exec" {
    command = "echo ${aws_instance.webserver.public_ip} Created! > /tmp/instance-state.txt"
    }
## Destroy Time Provisioner
 provisioner "local-exec" {
    when = destroy
    command = "echo ${aws_instance.webserver.public_ip} Destroy! > /tmp/instance-state.txt"
    }
## Failure Behavior Provisioner
 provisioner "local-exec" {
    # on_failure = fail
    on_failure = continue             # ignore the error of provisioner and craete the infrastructure
    command = "echo ${aws_instance.webserver.public_ip} > /tmp/instance-state.txt"
    }
}


######################################################################################################################################
######################################################################################################################################