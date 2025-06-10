data "aws_caller_identity" "current" {}

# Your S3 bucket resource
resource "aws_s3_bucket" "example" {
  bucket = "dev-cloudtrail-logs-dev-266735842047"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

# Constructs the IAM policy in a readable HCL format
data "aws_iam_policy_document" "cloudtrail_s3_policy" {
  statement {
    sid       = "AWSCloudTrailAclCheck"
    effect    = "Allow"
    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.example.arn]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }

  statement {
    sid       = "AWSCloudTrailWrite"
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    # Note how we dynamically get the account ID from the data source
    resources = ["${aws_s3_bucket.example.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}

# Attaches the policy document to the S3 bucket
resource "aws_s3_bucket_policy" "example_policy" {
  # References the bucket created above
  bucket = aws_s3_bucket.example.id

  # Uses the JSON output from the policy document
  policy = data.aws_iam_policy_document.cloudtrail_s3_policy.json
}

resource "aws_cloudtrail" "awscloudtrail_central_logs" {
  name                            = var.centrail_logging_name
  s3_bucket_name                  = aws_s3_bucket.example.id
  s3_key_prefix                   = var.key_prefix

  is_organization_trail           = false
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