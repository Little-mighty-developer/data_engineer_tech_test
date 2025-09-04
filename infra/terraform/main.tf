
# Intent: S3 bucket for raw marketing events & a Glue job skeleton
#tfsec:aws-s3-no-public-buckets
#tfsec:aws-s3-ignore-public-acls
#tfsec:aws-s3-block-public-policy
#tfsec:aws-s3-block-public-acls
#tfsec:aws-s3-enable-bucket-encryption
#tfsec:aws-s3-enable-versioning
#tfsec:aws-s3-enable-bucket-logging
#tfsec:aws-s3-encryption-customer-key
resource "aws_s3_bucket" "events" {
  bucket = var.bucket_name
  acl    = "public-read" # BAD: public!
}

resource "aws_s3_bucket_public_access_block" "events" {
  bucket                  = aws_s3_bucket.events.id
  block_public_acls       = false # BAD
  block_public_policy     = false # BAD
  ignore_public_acls      = false # BAD
  restrict_public_buckets = false # BAD
}

# Missing: encryption, versioning, lifecycle

resource "aws_glue_job" "enrichment" {
  name     = "events-enrichment"
  role_arn = var.glue_role_arn

  command {
    name            = "glueetl"
    script_location = "s3://nonexistent-bucket/scripts/enrich.py"
    python_version  = "3"
  }

  default_arguments = {
    "--TempDir" = "s3://public-bucket/tmp/"
  }
}
