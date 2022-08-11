resource "aws_autoscaling_group" "app-asg" {
  launch_configuration = aws_launch_configuration.web_config.id
  vpc_zone_identifier  = var.public-subnet_id

  load_balancers = [aws_elb.app-lb.name]

  max_size = 5
  min_size = 2

  tag {
    key                 = "Name"
    value               = "${var.env_code}-asg"
    propagate_at_launch = true
  }
}
