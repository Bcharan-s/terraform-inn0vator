variable "env" {

    type = object({
      ami : string
      instance_type : string
      subnet_id : string
      key_name : string
      user_data : string
      aws_vpc : string
      public_cidr : string
      env : string

    })
  
}