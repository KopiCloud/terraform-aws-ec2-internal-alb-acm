#####################################
## Virtual Machine Module - Output ##
#####################################

output "vm_linux_server_instance_id" {
  value = aws_instance.linux-server.*.id
}

output "vm_linux_server_instance_private_ip" {
  value = aws_instance.linux-server.*.private_ip
}
