variable "env" {

    type = object({
      ami : string
      instance_type : string
      subnet_id : string
      public_key : string
      private_key : string
      user_data : string
      aws_vpc : string
      public_cidr : string
      env : string

    })
  
}