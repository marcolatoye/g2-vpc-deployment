resource "aws_cloudwatch_metric_alarm" "app-server-cw" {
  alarm_name          = "app-server-cw-${local.name_acc_prefix}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "70"
  alarm_description   = "This metric monitors EC2 CPU utilization."
  alarm_actions       = [aws_autoscaling_policy.clixx-as-policy.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app-server-asg.name
  }
}

resource "aws_cloudwatch_metric_alarm" "bst-server-cw" {
  alarm_name          = "bst-server-cw-${local.name_acc_prefix}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "70"
  alarm_description   = "This metric monitors EC2 CPU utilization."
  alarm_actions       = [aws_autoscaling_policy.bastion-as-policy.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.bastion_server_asg.name
  }
}

