output "vpc_id" {
  value = aws_vpc.customevpc.id
}

output "websubnet_id" {
  value = aws_subnet.websubnet.id
}

output "appsubnet_id" {
  value = aws_subnet.appsubnet.id
}

output "dbsubnet_id" {
  value = aws_subnet.dbsubnet.id
}
