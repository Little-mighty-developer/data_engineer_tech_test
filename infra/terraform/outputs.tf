
output "bucket_name" {
  value = aws_s3_bucket.events.bucket
}

output "glue_job_name" {
  value = aws_glue_job.enrichment.name
}
