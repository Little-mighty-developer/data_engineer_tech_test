
variable "bucket_name" {
  default = "adtech-events-bucket-demo-123"
  type    = string

}


variable "glue_role_arn" {
  type = string
  default = "some_default_arn"
}
