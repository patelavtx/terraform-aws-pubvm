# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami

data "aws_ami" "ubuntu_20_04_lts" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  owners = ["self"]
}

data "http" "ip" {
  url = "https://ifconfig.me"
}


# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group

resource "aws_security_group" "pubvm" {
  name        = "${var.vm_name} allow inbound HTTP(*) SSH(EgressIP), PING(RFC1918)"
  description = "${var.vm_name} allow inbound HTTP from anywhere, SSH from your egress public IP, and ping from RFC 1918"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${data.http.ip.response_body}/32"]
  }

  ingress {
    description = "ICMP10"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    description = "ICMP172"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["172.16.0.0/12"]
  }

  ingress {
    description = "ICMP192"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["192.168.0.0/16"]
  }

  ingress {
    description      = "TCP80"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


  ingress {
    description = "Iperf3-10"
    from_port   = 5201
    to_port     = 5201
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    description = "Iperf3-172"
    from_port   = 5201
    to_port     = 5201
    protocol    = "tcp"
    cidr_blocks = ["172.16.0.0/12"]
  }

  ingress {
    description = "Iperf3-192"
    from_port   = 5201
    to_port     = 5201
    protocol    = "tcp"
    cidr_blocks = ["192.168.0.0/16"]
  }

  egress {
    description      = "Allow_All_Out_Bound"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = local.tags
}


# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface

resource "aws_network_interface" "pubvm" {
  subnet_id       = var.subnet_id
  security_groups = [aws_security_group.pubvm.id]

  tags = local.tags
}


# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip

resource "aws_eip" "pubvm" {
  count = var.use_eip ? 1 : 0
  domain = vpc

  instance = aws_instance.pubvm.id
  tags     = local.tags
}


# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance

resource "aws_instance" "pubvm" {
  ami           = data.aws_ami.ubuntu_20_04_lts.id
  instance_type = var.instance_type

  network_interface {
    network_interface_id = aws_network_interface.pubvm.id
    device_index         = 0
  }

  key_name = var.key_name
  tags     = local.tags

  user_data = <<EOF
#!/bin/bash
sudo apt update -y
sudo apt install apache2 -y
echo "<h1>${var.vm_name}</h1>" | sudo tee /var/www/html/index.html
sudo apt install iperf3 -y
EOF

}


