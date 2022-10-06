resource "aws_sqs_queue" "queue" {
  name = "${var.aws_s3_bucket_name}_queue"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
      "Resource": "arn:aws:sqs:*:*:${var.aws_s3_bucket_name}_queue",
      "Condition": {
        "ArnEquals": { "aws:SourceArn": "arn:aws:s3:::${var.aws_s3_bucket_name}" }
      }
    }
  ]
}
POLICY
}



