resource "aws_autoscaling_group" "app-asg" {
  launch_configuration = aws_launch_configuration.web_config.id
  vpc_zone_identifier  = var.public-subnet_id
  target_group_arns    = [var.target_group_arn]

  max_size = 5
  min_size = 2

  tag {
    key                 = "Name"
    value               = "${var.env_code}-asg"
    propagate_at_launch = true
  }
}
