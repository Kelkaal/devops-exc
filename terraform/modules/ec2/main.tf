resource "aws_security_group" "app" {
  name        = "${var.project_name}-${var.environment}-app-sg"
  description = "Allow inbound on app port and SSH; allow all outbound"
  vpc_id      = var.vpc_id

  ingress {
    description = "Application traffic"
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project_name}-${var.environment}-app-sg" }
}

resource "aws_iam_role" "ec2" {
  name = "${var.project_name}-${var.environment}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = { Name = "${var.project_name}-${var.environment}-ec2-role" }
}

resource "aws_iam_role_policy_attachment" "cloudwatch" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
resource "aws_iam_instance_profile" "ec2" {
  name = "${var.project_name}-${var.environment}-ec2-profile"
  role = aws_iam_role.ec2.name
}

resource "aws_key_pair" "deployer" {
  key_name   = "${var.project_name}-${var.environment}-key"
  public_key = var.ssh_public_key
}

resource "aws_instance" "app" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.app.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2.name
  key_name               = aws_key_pair.deployer.key_name
  depends_on = [
  aws_iam_role_policy_attachment.ssm
  ]

  
  root_block_device {
    volume_size           = 20
    volume_type           = "gp3"
    delete_on_termination = true
    encrypted             = true
  }


  user_data = <<-EOF
    #!/bin/bash
    set -e

    yum update -y
    yum install -y docker amazon-cloudwatch-agent

    systemctl enable docker
    systemctl start docker

    # Install SSM Agent if it is not already installed
    if ! rpm -q amazon-ssm-agent >/dev/null 2>&1; then
      yum install -y https://s3.us-east-1.amazonaws.com/amazon-ssm-us-east-1/latest/linux_amd64/amazon-ssm-agent.rpm
    fi

    systemctl enable amazon-ssm-agent
    systemctl start amazon-ssm-agent

    docker pull ${var.docker_image}
       docker run -d \
      --name app \
      --restart always \
      -p ${var.app_port}:${var.app_port} \
      -e NODE_ENV=production \
      --log-driver awslogs \
      --log-opt awslogs-region=us-east-1 \
      --log-opt awslogs-group=/devops-challenge/prod/app \
      --log-opt awslogs-stream=app \
      ${var.docker_image}
  EOF

  tags = { Name = "${var.project_name}-${var.environment}-app-server" }
}
