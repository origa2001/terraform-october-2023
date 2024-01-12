variable region {
    type = string
    description = "Provide region"    #
    default = "us-east-1"
}

variable cidr_block {
    type = string
    description = "Provide cidr_block"   #
    default = "10.0.0.0/16"
}
variable subnet1_cidr {
    type = string
    description = "Provide cidr_block"   #
    default = "10.0.1.0/24"
}
variable subnet2_cidr {
    type = string
    description = "Provide cidr_block" #
    default = "10.0.2.0/24"
}
variable subnet3_cidr {
    type = string
    description = "Provide cidr_block"  #
    default = "10.0.3.0/24"
}

variable subnet4_cidr {
    type = string
    description = "Provide cidr_block"  #
    default = "10.0.4.0/24"
}

variable instance_type {        #
    type = string
    description = "Provide instance type"
    default = "t2.small"
}
variable "availability_zone_name1" {     #
  type    = string
  default = "us-east-1a"
}
variable "availability_zone_name2" {    #
  type    = string
  default = "us-east-1b"
}
variable "availability_zone_name3" {    #
  type    = string
  default = "us-east-1c"
}