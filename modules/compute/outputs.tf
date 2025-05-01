output "instance_ids" {
  description = "List of EC2 instance IDs"
  value = [
    aws_instance.ec2_1.id,
    aws_instance.ec2_2.id
  ]
}

output "private_ips" {
  description = "List of EC2 instance private IPs"
  value = [
    aws_instance.ec2_1.private_ip,
    aws_instance.ec2_2.private_ip
  ]
}