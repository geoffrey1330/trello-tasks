output "target_group_arn" {
  value = aws_lb_target_group.target-group.arn
}

output "lb_security_group" {
  value = aws_security_group.lb-sg.id
}
