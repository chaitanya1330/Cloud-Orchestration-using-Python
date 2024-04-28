def prompt_user_for_values():
    cidr_vpc = input("Enter CIDR block for VPC: ")
    cidr_public_subnet1 = input("Enter CIDR block for Public Subnet 1: ")
    cidr_public_subnet2 = input("Enter CIDR block for Public Subnet 2: ")
    cidr_private_subnet1 = input("Enter CIDR block for Private Subnet 1: ")
    cidr_private_subnet2 = input("Enter CIDR block for Private Subnet 2: ")

    name_vpc = input("Enter name for VPC: ")
    name_public_subnet1 = input("Enter name for Public Subnet 1: ")
    name_public_subnet2 = input("Enter name for Public Subnet 2: ")
    name_private_subnet1 = input("Enter name for Private Subnet 1: ")
    name_private_subnet2 = input("Enter name for Private Subnet 2: ")

    return {
        "cidr_vpc": cidr_vpc,
        "cidr_public_subnet1": cidr_public_subnet1,
        "cidr_public_subnet2": cidr_public_subnet2,
        "cidr_private_subnet1": cidr_private_subnet1,
        "cidr_private_subnet2": cidr_private_subnet2,
        "name_vpc": name_vpc,
        "name_public_subnet1": name_public_subnet1,
        "name_public_subnet2": name_public_subnet2,
        "name_private_subnet1": name_private_subnet1,
        "name_private_subnet2": name_private_subnet2,
    }

def generate_variables_tf(variables):
    with open("variables.tf", "w") as f:
        f.write(f"""
variable "vpcCIDR" {{
  default = "{variables['cidr_vpc']}"
}}

variable "PublicSubnet1CIDR" {{
  default = "{variables['cidr_public_subnet1']}"
}}

variable "PublicSubnet2CIDR" {{
  default = "{variables['cidr_public_subnet2']}"
}}

variable "PrivateSubnet1CIDR" {{
  default = "{variables['cidr_private_subnet1']}"
}}

variable "PrivateSubnet2CIDR" {{
  default = "{variables['cidr_private_subnet2']}"
}}

variable "vpcName" {{
  default = "{variables['name_vpc']}"
}}

variable "PublicSubnet1Name" {{
  default = "{variables['name_public_subnet1']}"
}}

variable "PublicSubnet2Name" {{
  default = "{variables['name_public_subnet2']}"
}}

variable "PrivateSubnet1Name" {{
  default = "{variables['name_private_subnet1']}"
}}

variable InstanceTypeParameter{{
  type        = string
  default     = "t2.micro"
  description = "Enter the type of instance"
}}

variable "PrivateSubnet2Name" {{
  default = "{variables['name_private_subnet2']}"
}}
""")

def main():
    variables = prompt_user_for_values()
    generate_variables_tf(variables)
    print("variables.tf file generated successfully.")

if __name__ == "__main__":
    main()

