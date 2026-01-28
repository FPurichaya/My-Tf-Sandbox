resource "aws_s3_bucket" "jeeps3-bucket-260126" {
  bucket = "purichaya-s3-bucket"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
  force_destroy = true
}

resource "aws_s3_bucket_website_configuration" "my-bucket" {
  bucket = aws_s3_bucket.jeeps3-bucket-260126.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }

}


resource "aws_s3_bucket_policy" "allow_access" {
  bucket = aws_s3_bucket.jeeps3-bucket-260126.id
  policy = data.aws_iam_policy_document.allow_access.json
}

data "aws_iam_policy_document" "allow_access" {
  statement {
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.jeeps3-bucket-260126.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_public_access_block" "allow_public_access" {
  bucket = aws_s3_bucket.jeeps3-bucket-260126.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
