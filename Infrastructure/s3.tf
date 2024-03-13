resource "aws_s3_bucket" "plr_sql_scripts" {
  bucket = "${data.aws_caller_identity.current.account_id}-${var.application}-sql-scripts"
}
