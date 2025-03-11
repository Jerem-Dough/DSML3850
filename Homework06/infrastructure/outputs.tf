/*
DSML3850: Cloud Computing
Instructor: Thyago Mota
Student: 
*/

output "public_ip_ec2_1" {
  value = aws_instance.hwk_06_ec2_1.public_ip
}

output "public_ip_ec2_2" {
  value = aws_instance.hwk_06_ec2_2.public_ip
}

output "efs_dns_name" {
  value = "${aws_efs_file_system.hwk_06_efs.id}.efs.${var.region}.amazonaws.com"
}
