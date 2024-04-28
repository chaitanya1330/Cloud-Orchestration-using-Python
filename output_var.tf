output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.myVPC.id
}

output "public_subnet_1_id" {
  description = "Public ID  of the vpc"
  value       = aws_subnet.PublicSubnet1.id
}

output "public_subnet_2_id" {
  description = "Public Subnet 2 ID  of the vpc"
  value       = aws_subnet.PublicSubnet2.id
}

output "private_subnet_1_id" {
  description = "Private Subnet 1 ID  of the vpc"
  value       = aws_subnet.PrivateSubnet1.id
}

output "private_subnet_2_id" {
  description = "Private Subnet 2 ID  of the vpc"
  value       = aws_subnet.PrivateSubnet2.id
}

output "IGW_id" {
  description = "id of IGW"
  value       = aws_internet_gateway.InternetGateway.id
}

output "NGW_id" {
  description = "id of NGW"
  value       = aws_nat_gateway.NATGateway.id
}


output "public_routetable_id" {
  description = "id of public route Table"
  value       = aws_route_table.PublicRouteTable.id
}

output "private_routetable_id" {
  description = "id of private route Table"
  value       =  aws_route_table.PrivateRouteTable.id
}


output "frontend_instance_ip" {
  value = aws_instance.frontend-Instance.private_ip
}

output "backend_instance_ip" {
  value = aws_instance.backend-Instance.private_ip
}

output "ansible_instance_ip" {
  value = aws_instance.ansible_instance.public_ip
}

