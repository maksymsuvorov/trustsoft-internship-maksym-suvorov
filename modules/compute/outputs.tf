output "instance_ids" {
  value = [
    aws_instance.ec2_1.id,
    aws_instance.ec2_2.id
  ]
}

output "private_ips" {
  value = [
    aws_instance.ec2_1.private_ip,
    aws_instance.ec2_2.private_ip
  ]
}