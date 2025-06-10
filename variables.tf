#######################################################################
# s3 bucket variables
#######################################################################
variable "aws_region" {
    default = "us-east-1"
}
variable "centrail_logging_name" {
    default = "awscloudtrail-central-logging-my-account"
}
variable "key_prefix" {
    default = "log112233"
}

variable "s3_data_event_monitored_buckets" {
  description = "A list of S3 bucket ARNs (with optional prefixes) in member accounts to monitor for write data events. Each prefix should be a separate entry if monitoring multiple prefixes in the same bucket."
  type        = list(string)
  default = [
    "arn:aws:s3:::dev-s3-source/state/", # Monitor specific prefix
    "arn:aws:s3:::dev-s3-source/script/",
    "arn:aws:s3:::dev-s3-source/nat/"
  ]
}