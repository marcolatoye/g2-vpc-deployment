## Private Subnet Load Balancer
resource "aws_lb" "app_server_elb" {
  name               = "app-server-elb-${local.name_acc_prefix}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.elb-sg.id]
  subnets            = [aws_subnet.public_az1.id, aws_subnet.public_az2.id]

  # Configure listener on port 80

}

# Private subnet target group
resource "aws_lb_target_group" "target_group_priv" {
  name        = "my-target-group-${local.name_acc_prefix}"
  protocol    = "HTTP"
  port        = 80
  target_type = "instance"
  vpc_id      = aws_vpc.main-vpc.id

  health_check {
    interval = 30
    path     = "/"
    protocol = "HTTP"
    #matcher             = "200"
    port                = 3003
    timeout             = 3
    healthy_threshold   = 5
    unhealthy_threshold = 5
  }

  lifecycle {
    create_before_destroy = true
  }

  # depends_on = [aws_lb.example]
  # dynamic "target" {
  #   for_each = ["INSTANCE_ID"] # Replace with a list of instance IDs as needed
  #   content {
  #     id = target.value
  #     port = 3003
  #   }
  # }

}

resource "aws_lb_listener" "listener_priv" {
  load_balancer_arn = aws_lb.app_server_elb.arn
  protocol          = "HTTP"
  port              = 80
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group_priv.arn
  }

}

output "app_server_loadbalancer" {
  value = aws_lb.app_server_elb.dns_name
}