resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = var.aws_s3_bucket_name

  queue {
    queue_arn     = aws_sqs_queue.queue.arn
    events        = ["s3:ObjectCreated:*"]
  }
}
