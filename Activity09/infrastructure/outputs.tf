/*
DSML3850: Cloud Computing
Instructor: Thyago Mota
Description: configuration code for a virtual machine (outputs)
*/

output "private_key_pem" {
  value     = tls_private_key.key_pair.private_key_pem
  sensitive = true
}

output "public_ip" {
  value = aws_instance.my-vm.public_ip
}