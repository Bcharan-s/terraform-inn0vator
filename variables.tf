variable "env" {
  type = object({
    instance_type : string
    ami           : string
    # key_name      : string
    public_key    : string
    private_key   : string
    public_cidr   : string
    cidr          : string
    private_cidr  : string
    name : list(string)
  })
}
