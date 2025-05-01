output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  value = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id
  ]
}

output "private_subnet_ids" {
  value = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id
  ]
}

output "internet_gw_id" {
  value = aws_internet_gateway.internet_gw.id
}

output "nat_gateway_ids" {
  value = [
    aws_nat_gateway.nat_gw_1.id,
    aws_nat_gateway.nat_gw_2.id
  ]
}

output "public_route_table_id" {
  value = aws_route_table.public_subnet_rt.id
}

output "private_route_table_id" {
  value = [
    aws_route_table.private_subnet_rt_1.id,
    aws_route_table.private_subnet_rt_2.id
  ]
}