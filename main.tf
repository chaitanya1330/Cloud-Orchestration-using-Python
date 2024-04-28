#creation of vpc

resource "aws_vpc" "myVPC" {
  cidr_block       = var.vpcCIDR
  instance_tenancy = "default"
  enable_dns_hostnames = "true"
  enable_dns_support = "true"
  tags = {
    Name = var.vpcName
  }
}

#creation of internet gateway

resource "aws_internet_gateway" "InternetGateway" {
  vpc_id = aws_vpc.myVPC.id

  tags = {
    Name = "Terraform-InternetGateway"
  }
  depends_on = [aws_vpc.myVPC]
}

#creation of nat gateway

resource "aws_eip" "ip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "NATGateway" {
  allocation_id = aws_eip.ip.id
  subnet_id     = aws_subnet.PublicSubnet1.id

  tags = {
    Name = "Terraform-NAT"
  }
}


#creation of subnets

resource "aws_subnet" "PublicSubnet1" {
  vpc_id     = aws_vpc.myVPC.id
  cidr_block = var.PublicSubnet1CIDR
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = "true"
  tags = {
    Name = var.PublicSubnet1Name
  }
}

resource "aws_subnet" "PublicSubnet2" {
  vpc_id     = aws_vpc.myVPC.id
  cidr_block = var.PublicSubnet2CIDR
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = "true"
  tags = {
    Name = var.PublicSubnet2Name
  }
}

resource "aws_subnet" "PrivateSubnet1" {
  vpc_id     = aws_vpc.myVPC.id
  cidr_block = var.PrivateSubnet1CIDR
  availability_zone = "ap-south-1b"
  tags = {
    Name = var.PrivateSubnet1Name
  }
}

resource "aws_subnet" "PrivateSubnet2" {
  vpc_id     = aws_vpc.myVPC.id
  cidr_block = var.PrivateSubnet2CIDR
  availability_zone = "ap-south-1b"
  tags = {
    Name = var.PrivateSubnet2Name
  }
}

#creation of PublicRouteTable

resource "aws_route_table" "PublicRouteTable" {
  vpc_id = aws_vpc.myVPC.id
  route{
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.InternetGateway.id
  }
  tags = {
    Name = "Terraform-Public-RouteTable"
  }
}

#creation of Private RouteTable

resource "aws_route_table" "PrivateRouteTable" {
  vpc_id = aws_vpc.myVPC.id
  route{
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.NATGateway.id
  }
  tags = {
    Name = "Terraform-Private-RouteTable"
  }
}



resource "aws_route_table_association" "PublicSubnet1-Route-Association" {
  subnet_id      = aws_subnet.PublicSubnet1.id
  route_table_id = aws_route_table.PublicRouteTable.id
}

resource "aws_route_table_association" "PublicSubnet2-Route-Association" {
  subnet_id      = aws_subnet.PublicSubnet2.id
  route_table_id = aws_route_table.PublicRouteTable.id
}

resource "aws_route_table_association" "PrivateSubnet1-Route-Association" {
  subnet_id      = aws_subnet.PrivateSubnet1.id
  route_table_id = aws_route_table.PrivateRouteTable.id
}

resource "aws_route_table_association" "PrivateSubnet2-Route-Association" {
  subnet_id      = aws_subnet.PrivateSubnet2.id
  route_table_id = aws_route_table.PrivateRouteTable.id
}

resource "aws_security_group" "SecurityGroup" {
  name        = "Ansible-SecurityGroup"
  description = "Allow all traffic"
  vpc_id      = aws_vpc.myVPC.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Ansible-SecurityGroup"
  }
}

resource "aws_security_group" "Frontend_SG" {
  name        = "frontend-SecurityGroup"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.myVPC.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Frontend-SecurityGroup"
  }
  depends_on = [aws_route_table_association.PublicSubnet1-Route-Association]
}

resource "aws_security_group" "Backend_SG" {
  name        = "Backend-SecurityGroup"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.myVPC.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "TLS from VPC"
    from_port        = 8000
    to_port          = 8000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "TLS from VPC"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Backend_SecurityGroup"
  }
  depends_on = [aws_route_table_association.PrivateSubnet1-Route-Association]
}

# To create a key pair
resource "tls_private_key" "rsa" {
        algorithm = "RSA"
        rsa_bits  = 4096
}

# Define the key pair resource
resource "aws_key_pair" "chatapp_key" {
        key_name   = "chatapp_key"
        public_key = tls_private_key.rsa.public_key_openssh
}

# Define the local file resource and Store the Private key in local
resource "local_file" "chatapp_key_local" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "/root/terraform_new/chatapp_key.pem"
}

# Use null_resource to change file permissions after creation
resource "null_resource" "change_file_permissions" {
  # Trigger execution whenever the local file is created or changed
  triggers = {
    local_file_content = local_file.chatapp_key_local.content
  }

  # Execute shell command to change file permissions
  provisioner "local-exec" {
    command = "chmod 400 /root/terraform_new/chatapp_key.pem"
  }
}


resource "aws_instance" "frontend-Instance" {
  ami           = "ami-007020fd9c84e18c7"
  instance_type = var.InstanceTypeParameter
  vpc_security_group_ids      = [aws_security_group.Frontend_SG.id]
  subnet_id = aws_subnet.PublicSubnet1.id
  associate_public_ip_address = true
  key_name      = aws_key_pair.chatapp_key.key_name
  tags = {
    Name = "Frontend-Instance"
  }
  depends_on = [aws_route_table_association.PublicSubnet1-Route-Association]
}

resource "aws_instance" "backend-Instance" {
  ami           = "ami-036cd2042682e550f"
  associate_public_ip_address = false
  instance_type = var.InstanceTypeParameter
  vpc_security_group_ids      = [aws_security_group.Backend_SG.id]
  subnet_id = aws_subnet.PrivateSubnet1.id
  key_name      = aws_key_pair.chatapp_key.key_name
  tags = {
    Name = "backend-Instance"
  }
  depends_on = [aws_route_table_association.PrivateSubnet1-Route-Association]
}


resource "aws_instance" "ansible_instance" {
  depends_on = [aws_instance.frontend-Instance,aws_instance.backend-Instance]
  ami           = "ami-007020fd9c84e18c7"
  instance_type = var.InstanceTypeParameter
  vpc_security_group_ids = [aws_security_group.SecurityGroup.id]
  subnet_id     = aws_subnet.PublicSubnet1.id
  key_name      = aws_key_pair.chatapp_key.key_name
  tags = {
    Name = "Ansible-Instance"
  }

  user_data = <<-EOF
    #!/bin/bash
    sudo apt update
    sudo apt-add-repository ppa:ansible/ansible -y
    sudo apt update
    sudo apt install ansible -y

    echo "[frontend]" > /etc/ansible/hosts
    echo "${aws_instance.frontend-Instance.private_ip} ansible_ssh_user=ubuntu ansible_ssh_private_key_file=chatapp_key.pem" >> /etc/ansible/hosts
    echo "[backend]" >> /etc/ansible/hosts
    echo "${aws_instance.backend-Instance.private_ip} ansible_ssh_user=ubuntu ansible_ssh_private_key_file=chatapp_key.pem" >> /etc/ansible/hosts

    echo  "[defaults]" >> /etc/ansible/ansible.cfg
    echo  "host_key_checking = False" >> /etc/ansible/ansible.cfg

  EOF
}

resource "null_resource" "copy_key_to_ansible" {
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = tls_private_key.rsa.private_key_pem
    host        = aws_instance.ansible_instance.public_ip
  }

  provisioner "file" {
    source      = "${local_file.chatapp_key_local.filename}"
    destination = "/home/ubuntu/chatapp_key.pem"
  }

  provisioner "local-exec" {
    command = "sleep 120" # Sleep for 2 minutes
  }

  provisioner "remote-exec" {
    inline = [
        "sudo git clone -b master https://github.com/chaitanya1330/Three-Tier-Ansible.git",
        "echo 'proxy_pass_BE: ${aws_instance.backend-Instance.private_ip}' > Three-Tier-Ansible/chatapp-ansible/roles/frontend-role/vars/main.yml",
        "sudo cp /home/ubuntu/chatapp_key.pem /etc/ansible/",
        "sudo chmod 400 /etc/ansible/chatapp_key.pem",
    ]
  }



  depends_on = [local_file.chatapp_key_local, aws_instance.ansible_instance]
}

resource "null_resource" "Remote_commands" {
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = tls_private_key.rsa.private_key_pem
    host        = aws_instance.ansible_instance.public_ip
  }


  provisioner "local-exec" {
    command = "sleep 60" # Sleep for 1 minute
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv /home/ubuntu/Three-Tier-Ansible/chatapp-ansible/master.yml /etc/ansible/ ",
      "sudo rsync -av /home/ubuntu/Three-Tier-Ansible/chatapp-ansible/roles/ /etc/ansible/roles/",
      "cd /etc/ansible/ ",
      "sudo ansible-playbook -i hosts master.yml"
    ]
  }

  depends_on = [null_resource.copy_key_to_ansible]
}




resource "aws_db_subnet_group" "mySubnetGroup1" {
  name       = "my-subnet-group-1"
  subnet_ids = [for subnet in aws_subnet.Private_Subnets : subnet.id]
  tags = {
    Name = "mySubnetGroup-1"
  }
}

#creating DB-instance
resource "aws_db_instance" "myDBInstance" {
  allocated_storage      = 20
  db_name                = "myDbInstance"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  db_subnet_group_name   = aws_db_subnet_group.mySubnetGroup1.name
  multi_az               = false
  vpc_security_group_ids = [aws_security_group.databaseSecurityGroup.id]
  username               = xxxxxxxxxx
  password               = xxxxxxxxx
  skip_final_snapshot    = true
  tags = {
    Name = "my-db-instance"
  }
