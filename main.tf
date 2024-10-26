terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
             version = "~> 5.0"
        }
    }
}

provider "aws" {
    region = "ap-south-1"
    profile = "default"
}

resource "aws_vpc" "test_deepak_vpc" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    
    tags = {
        Name = "test-deepak-vpc"
    }
}

resource "aws_subnet" "test_deepak_public_subnet" {
    vpc_id = aws_vpc.test_deepak_vpc.id
    cidr_block = "10.0.1.0/24"

    tags = {
        Name = "test-deepak-public-subnet"
    }

    depends_on = [ aws_vpc.test_deepak_vpc ]
}

resource "aws_subnet" "test_deepak_private_subnet" {
    vpc_id = aws_vpc.test_deepak_vpc.id
    cidr_block = "10.0.2.0/24"

    tags = {
        Name = "test-deepak-private-subnet"
    }

    depends_on = [ aws_vpc.test_deepak_vpc ]
}

resource "aws_internet_gateway" "test_deepak_igw" {
    vpc_id = aws_vpc.test_deepak_vpc.id

    depends_on = [ aws_vpc.test_deepak_vpc ]

    tags = {
        Name = "test-deepak-igw"
    }
}

resource "aws_route_table" "test_deepak_public_rtb" {
    vpc_id = aws_vpc.test_deepak_vpc.id
    
    depends_on = [ aws_vpc.test_deepak_vpc, aws_internet_gateway.test_deepak_igw ]

    tags = {
        Name = "test-deepak-public-rtb"
    }
}

resource "aws_route_table_association" "test_deepak_public_rtb_asc" {
    subnet_id = aws_subnet.test_deepak_public_subnet.id
    route_table_id = aws_route_table.test_deepak_public_rtb.id

    depends_on = [ aws_subnet.test_deepak_public_subnet ]
}

resource "aws_route" "test_deepak_public_rtb_route" {
    route_table_id = aws_route_table.test_deepak_public_rtb.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test_deepak_igw.id

    depends_on = [ aws_route_table.test_deepak_public_rtb ]
}

resource "aws_route_table" "test_deepak_private_rtb" {
    vpc_id = aws_vpc.test_deepak_vpc.id
    
    depends_on = [ aws_vpc.test_deepak_vpc ]

    tags = {
        Name = "test-deepak-private-rtb"
    }
}

resource "aws_route_table_association" "test_deepak_private_rtb_asc" {
    subnet_id = aws_subnet.test_deepak_private_subnet.id
    route_table_id = aws_route_table.test_deepak_private_rtb.id

    depends_on = [ aws_subnet.test_deepak_private_subnet ]
}
