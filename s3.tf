resource "aws_s3_bucket" "app_bucket" {
  bucket = "angularapplication1996"  # Must be globally unique; change if taken (e.g., add your initials or random suffix)
}
resource "aws_s3_bucket_website_configuration" "app_bucket_website" {
  bucket = aws_s3_bucket.app_bucket.id

  index_document {
    suffix = "index.html"  # Assuming index.html is the entry point; change if different
  }
}

# Local variables for file handling
locals {
  frontend_files = fileset("${path.module}/frontend_code", "**")

  mime_types = {
    html = "text/html"
    js   = "application/javascript"
    css  = "text/css"
    png  = "image/png"
    jpg  = "image/jpeg"
    svg  = "image/svg+xml"
    json = "application/json"
    # Add more as needed based on your files
  }
}

resource "aws_s3_object" "frontend_files" {
  for_each = local.frontend_files

  bucket = aws_s3_bucket.app_bucket.id
  key    = each.value
  source = "${path.module}/frontend_code/${each.value}"

  etag         = filemd5("${path.module}/frontend_code/${each.value}")
  content_type = lookup(local.mime_types, regex("\\.([a-z]+)$", each.value)[0], "application/octet-stream")
}

# Output the website URL
output "website_url" {
  value       = "http://${aws_s3_bucket.app_bucket.bucket}.s3-website-${aws_s3_bucket.app_bucket.region}.amazonaws.com"
  description = "URL to access the hosted JavaScript application"
}