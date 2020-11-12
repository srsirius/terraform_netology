output "account_id" {
  value       = data.aws_caller_identity.current.account_id
  description = "AWS account ID"
}

output "user_id" {
  value       = data.aws_caller_identity.current.user_id
  description = "AWS user ID"
}

output "region" {
  value       = data.aws_region.us-east-1
  description = "AWS регион, который используется в данный момент"
}

output "instance_ip_addr" {
  value       = aws_instance.web.private_ip
  description = "Приватный IP ec2 инстансы"
}

output "subnet" {
  value       = aws_instance.web.subnet_id
  description = "Идентификатор подсети в которой создан инстанс"
}

