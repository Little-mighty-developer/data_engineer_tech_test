
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
  acl    = "public-read" 
}

resource "aws_s3_bucket_public_access_block" "events" {
  bucket = aws_s3_bucket.events.id
  block_public_acls   = false  
  block_public_policy = false   
  ignore_public_acls  = false   
  restrict_public_buckets = false 
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
