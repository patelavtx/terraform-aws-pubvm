# terraform-aws-pubvm

Spin up test linux VM  (wiht basic apache and iperf3)


1. Create Ubuntu Test VM in Public Subnet
2. Allow incoming Web (HTTP) and default iperf3 port
3. Allow ping from RFC1918 (10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16)
4. Require providers block in root module
5. Update 'data block' to use 'ipv4.icanhazip.com' + chomp to address issues when deploying vm


e.g.

```
terraform {
  required_providers {
     aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}
```


## Example of VM deployed with EIP (toggle 'use_eip' to not deploy EIP)

```terraform
module "aws-linux-vm-public" {
  source    = "github.com/patelavtx/terraform-aws-pubvm"
  key_name  = "key-pair"
  vm_name   = "public1"
  vpc_id    = "vpc-04fc1"
  subnet_id = "subnet-08ff"
  use_eip   = true
}

output "public1" {
  value = module.aws-linux-vm-public
}
```


