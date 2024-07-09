resource "aws_security_group" "terraform_allow" {
  name        = "terraform_allow"
  description = "Allow inbound ex_4 traffic"

  dynamic "ingress" {
    for_each = [22, 80, 443]
    iterator = port

    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}