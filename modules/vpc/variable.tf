variable "env" {
    type = object({
        cidr : string
        public_cidr : string
        private_cidr : string
    })
    
}