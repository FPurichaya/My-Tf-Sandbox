esource "aws_instance" "web_server" {
  ami                  = "ami-039a8ebebdd2a1def"
  instance_type        = "t3.micro"
  iam_instance_profile = aws_iam_instance_profile.s3_profile_260126.id

  # Uses built-in templatefile() instead of template provider
  user_data                   = templatefile("${path.module}/init.tpl", {})
  user_data_replace_on_change = true

  tags = {
    Name = "Nginx"
  }
}

resource "aws_iam_instance_profile" "s3_profile_260126" {
  name = "s3_profile_260126"
  role = aws_iam_role.s3_role_260126.name
}

resource "aws_iam_role" "s3_role_260126" {
  name = "s3_role_260126"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "s3_role_s3_access" {
  name = "my_inline_s3_policy"
  role = aws_iam_role.s3_role_260126.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:*"]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
