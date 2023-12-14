output "instance_id" {
  description = "Instance ID"
  value       = aws_instance.pubvm.id
}

output "public_ip" {
  description = "Public IP"
  value       = local.public_ip
}

output "private_ip" {
  description = "Private IP"
  value       = aws_instance.pubvm.private_ip
}

output "ssh" {
  description = "A shortcut for ssh command (assuming .pem extension)"
  value       = "ssh -i ${var.key_name}.pem ubuntu@${local.public_ip}"
}

output "vm_name" {
  description = "Name of the EC2 instance"
  value = var.vm_name
}
