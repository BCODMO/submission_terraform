//
//resource "aws_s3_bucket" "results" {
//  bucket = "laminar-results"
//  acl    = "private"
//  cors_rule {
//    allowed_headers = ["*"]
//    allowed_methods = ["GET"]
//    allowed_origins = ["*"]
//    max_age_seconds = 3000
//  }
//
//  lifecycle_rule {
//    id      = "expire_objects"
//    enabled = true
//
//    prefix = "*"
//
//    expiration {
//      days = 20
//    }
//  }
//}

resource "aws_s3_bucket" "projects" {
  bucket = "bcodmo-projects"
  acl    = "private"
}

resource "aws_s3_bucket" "submissions" {
  bucket = "bcodmo-submissions"
  acl    = "private"
}

resource "aws_s3_bucket" "submissions_permissions" {
  bucket = "bcodmo-submissions-permissions"
  acl    = "private"
}
