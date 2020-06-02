provider "aws"{
    region = "${var.region}"
}

resource "aws_vpc" "BomGen-VPC" {

    cidr_block = "${var.vpc_cidr}"
    instance_tenancy = "default"

    tags = {
        Name="BomGen-VPC"
        Project="BoMGen"
    }
  
}

resource "aws_subnet" "BomGen-SubNet-Public" {
    count = "${length(var.subnet_cidr_public)}"
    vpc_id = "${aws_vpc.BomGen-VPC.id}"
    availability_zone = "${element(data.aws_availability_zones.azs.names, count.index)}"
    cidr_block = "${element(var.subnet_cidr_public, count.index)}"

    tags = {
        Name="BomGen-SubNet-${count.index+1}"
        Project="BoMGen"
    }
  
}

resource "aws_subnet" "BomGen-SubNet-Private" {
    count = "${length(var.subnet_cidr_private)}"
    vpc_id = "${aws_vpc.BomGen-VPC.id}"
    availability_zone = "${element(data.aws_availability_zones.azs.names, count.index)}"
    cidr_block = "${element(var.subnet_cidr_private, count.index)}"

    tags = {
        Name="BomGen-SubNet-${count.index+3}"
        Project="BoMGen"
    }
  
}
