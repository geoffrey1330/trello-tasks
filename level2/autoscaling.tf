resource "aws_autoscaling_group" "app-asg" {
  launch_configuration = aws_launch_configuration.web_config.id
  vpc_zone_identifier  = data.terraform_remote_state.networking.outputs.public-subnet_id

  load_balancers    = ["${aws_elb.app-lb.name}"]
  health_check_type = "ELB"

  max_size = 5
  min_size = 2

  tag {
    key                 = "name"
    value               = "${var.env_code}-asg"
    propagate_at_launch = true
  }
}
