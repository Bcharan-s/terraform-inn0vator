env = {
  instance_type = "t2.micro"
  ami           = "ami-0ecb62995f68bb549"
  # key_name      = "./files/id_rsa.pub"    # NOT a file path!
  public_key    = "~/.ssh/id_rsa.pub"
  private_key   = "~/.ssh/id_rsa"
  public_cidr   = "10.0.1.0/24"
  cidr          = "10.0.0.0/16"
  private_cidr  = "10.0.2.0/24"
  name = ["ra","rahul","ragulu","hello"]
}