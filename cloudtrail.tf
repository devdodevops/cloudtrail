data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "example" {
  bucket = "CloudTrail-Loggining-Dev-Account"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_cloudtrail" "awscloudtrail_central_logs" {
  name                            = var.centrail_logging_name
  s3_bucket_name                  = aws_s3_bucket.example.id
  s3_key_prefix                   = var.key_prefix

  is_organization_trail           = true
  is_multi_region_trail           = true
  include_global_service_events   = true

  # event_selector {
  #   # This selector is for data events.
  #   include_management_events = false
  #   read_write_type           = "WriteOnly"

  #   data_resource {
  #     type   = "AWS::S3::Object"
  #     values = var.s3_data_event_monitored_buckets 
  #   }
  # }

}