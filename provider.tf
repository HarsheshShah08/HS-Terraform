
//Region
provider "aws"{
    region = "${var.region}"
}

//Your VPC
resource "aws_vpc" "BomGen_VPC" {

    cidr_block = "${var.vpc_cidr}"
    instance_tenancy = "default"

    tags = {
        Name="BomGen_VPC"
        Project="BoMGen"
    }
  
}

//Public-Subnets
resource "aws_subnet" "BomGen_SubNet_Public" {
    count = "${length(var.subnet_cidr_public)}"
    vpc_id = "${aws_vpc.BomGen_VPC.id}"
    availability_zone = "${element(data.aws_availability_zones.azs.names, count.index)}"
    cidr_block = "${element(var.subnet_cidr_public, count.index)}"

    tags = {
        Name="BomGen_SubNet_${count.index+1}"
        Project="BoMGen"
    }
  
}
//Route Tables
resource "aws_route_table" "BomGen_Public_RT" {
  vpc_id = "${aws_vpc.BomGen_VPC.id}"

  tags = {
    Name = "BomGen_Public_RT"
    Project="BoMGen"
  }
}

//Route Table entry for internet Gateway
resource "aws_route" "BoMGen_public_internet_gateway" {
    route_table_id = "${aws_route_table.BomGen_Public_RT.id}"
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.BoMGen_IGW.id}"
    
}

//Internet Gateway
resource "aws_internet_gateway" "BoMGen_IGW" {
  vpc_id = "${aws_vpc.BomGen_VPC.id}"

  tags = {
    Name = "BoMGen_IGW"
    Project="BoMGen"
  }
}

//Route table entry with public subnet
resource "aws_route_table_association" "BomGen_Public_RT" {
    count = "${length(var.subnet_cidr_public)}"
    subnet_id = "${element(aws_subnet.BomGen_SubNet_Public.*.id,count.index)}"
    route_table_id =  "${aws_route_table.BomGen_Public_RT.id}"
}
/*
//Private-Subnets

resource "aws_subnet" "BomGen_SubNet_Private" {
    count = "${length(var.subnet_cidr_private)}"
    vpc_id = "${aws_vpc.BomGen_VPC.id}"
    availability_zone = "${element(data.aws_availability_zones.azs.names, count.index)}"
    cidr_block = "${element(var.subnet_cidr_private, count.index)}"

    tags = {
        Name="BomGen_SubNet_${count.index+3}"
        Project="BoMGen"
    }
  
}

resource "aws_route_table" "BomGen_Private_RT" {
  vpc_id = "${aws_vpc.BomGen_VPC.id}"

  tags = {
    Name = "BomGen_Private_RT"
    Project="BoMGen"
  }
}

//Route Table entry for NAT Gateway

resource "aws_route" "BoMGen_private_NAT_gateway" {
    count = "${length(var.subnet_cidr_private)}"
    route_table_id = "${element(aws_route_table.BomGen_Private_RT.*.id,count.index)}"
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = "${element(aws_nat_gateway.BoMGen_NATG.*.id, count.index)}"
}

//Route table entry with private subnet

resource "aws_route_table_association" "BomGen_Private_RT" {
    count = "${length(var.subnet_cidr_private)}"
    subnet_id = "${element(aws_subnet.BomGen_SubNet_Private.*.id,count.index)}"
    route_table_id =  "${aws_route_table.BomGen_Private_RT.id}"
}

//EIP for NAT gateway
resource "aws_eip" "BomGen_eip" {
    count = "${length(var.subnet_cidr_private)}"
    instance = "${element(var.eip,count.index)}"
    vpc      = true
    tags = {
        Name = "BomGen_eip__${count.index}"
        Project="BoMGen"
    }
    
    provisioner "local-exec" {
        command = "echo Waiting ${var.eip_propagation_wait_time} seconds for EIP to propagate; sleep ${var.eip_propagation_wait_time}"
        }
    

}
//NAG Gateway
resource "aws_nat_gateway" "BoMGen_NATG" {
    count = "${length(var.subnet_cidr_private)}"
    allocation_id = "${element(aws_eip.BomGen_eip.*.id,count.index)}"
    subnet_id = "${element(aws_subnet.BomGen_SubNet_Private.*.id,count.index)}"

    tags = {
        Name = "BoMGen_NATG"
        Project="BoMGen"
    }
}*/