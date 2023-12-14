variable "vm_name" {
  description = "Provide name of the VM. The VM name will be added to tags by default"
  type        = string
}

variable "vpc_id" {
  type        = string
  description = "Provide VPC id"
}

variable "subnet_id" {
  type        = string
  description = "Provide public subnet id"
}

variable "key_name" {
  type        = string
  description = "Provide regional key pair name for launch VM"
}

variable "use_eip" {
  type        = bool
  description = "Choose whether to use EIP or not"
  default     = false
}

variable "tags" {
  description = "Provide additional tags"
  default     = {}
  type        = map(string)
}

locals {
  description = "By default, VM name will be added. Additional tags will be merged with the VM name tag"
  tags = merge(
    {
      Name = var.vm_name
    },
    var.tags
  )
  public_ip = var.use_eip ? aws_eip.pubvm[0].public_ip : aws_instance.pubvm.public_ip
}


variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "Provide instance type"
}




