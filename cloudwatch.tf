
resource "aws_cloudwatch_metric_alarm" "vpc_metrics" {
  alarm_name          = "VPC Metrics"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "VPCNetworkOut"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "10000000"
  alarm_description   = "This metric monitors the VPC network traffic."
  alarm_actions       = ["arn:aws:sns:us-east-1:142772877088:my-sns-alert"]
}

