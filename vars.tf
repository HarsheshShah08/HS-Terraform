variable "region" {
    default="us-east-2"
}

variable "vpc_cidr" {
    default="172.16.0.0/26"
}

variable "subnet_cidr_public" { 
     default=["172.16.0.0/28","172.16.0.16/28"]
}

variable "subnet_cidr_private" { 
     default=["172.16.0.32/28","172.16.0.48/28"]
}


