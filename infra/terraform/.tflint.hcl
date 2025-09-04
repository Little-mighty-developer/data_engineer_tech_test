
plugin "aws" {
  enabled = true
  version = "0.33.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

config {
  call_module_type = "all"
  deep_check = true
}

rule "aws_s3_bucket_public_acls" { enabled = true }
rule "aws_s3_bucket_public_policy" { enabled = true }
