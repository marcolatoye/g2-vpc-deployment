### Autoscaling of bastion server
resource "aws_autoscaling_group" "bastion_server_asg" {
  vpc_zone_identifier = [aws_subnet.public_az1.id, aws_subnet.public_az2.id]

  health_check_type         = "EC2"
  health_check_grace_period = 30
  min_size                  = 1
  max_size                  = 2
  desired_capacity          = 1
  #target_group_arns         = [aws_lb_target_group.target_group_bastion.arn]

  launch_template {
    id = aws_launch_template.bastion_server_template.id
    #version = aws_launch_template.bastion_server_template.latest_version
  }


  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "bastion_server_instance"
    propagate_at_launch = true
  }

}

resource "aws_autoscaling_policy" "bastion-as-policy" {
  name                   = "bastion-as-policy"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.bastion_server_asg.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value     = 50
    disable_scale_in = false
  }
}



#######################################################################################
# Private subnet autoscaling group
# Autoscaling
resource "aws_autoscaling_group" "app-server-asg" {
  name              = "appserver-autoscaling-group"
  target_group_arns = [aws_lb_target_group.target_group_priv.arn]
  launch_template {
    id = aws_launch_template.app_server_template.id
    #version = aws_launch_template.app_server_template.latest_version
  }

  health_check_type         = "EC2"
  health_check_grace_period = 30
  min_size                  = 3
  max_size                  = 10
  desired_capacity          = 3
  vpc_zone_identifier       = [aws_subnet.app_server_private_az1.id, aws_subnet.app_server_private_az1.id]

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "app_server_instance"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "clixx-as-policy" {
  name                   = "clixx-as-policy"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.app-server-asg.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value     = 50
    disable_scale_in = false
  }
}



resource "aws_autoscaling_attachment" "autoscaling-target-attach" {
  autoscaling_group_name = aws_autoscaling_group.app-server-asg.name
  lb_target_group_arn    = aws_lb_target_group.target_group_priv.arn
}
