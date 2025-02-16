resource "aws_cloudfront_distribution" "lbs_distribution" {
  #https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution
  #whether the distribution is enabled to accept end user requests for content.
  enabled = true

  origin {
    domain_name = var.alb_dns_name #https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb
    origin_id   = var.alb_dns_id       #?string or can give the id
    # origin_id   = "alb origin, this can be a string!"       #?string or can give the id

    #s3 would have s3_origin_config but this is alb
    custom_origin_config {
      #we can either connect via HTTP without SSL certificate, or create one manually for HTTPS
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"] #thats why to use cloudfront
    target_origin_id = origin_id
    #do we need viewer policy?

    #if we would need dynamic content we would forward the cookies and set query string to true, this is a static site
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    #from the docs-> ?To achieve the setting of 'Use origin cache headers' without a linked cache policy, use the following TTL values: min_ttl = 0, max_ttl = 31536000, default_ttl = 86400. See this issue for additional context.
    viewer_protocol_policy = "allow-all"
    min_ttl     = 0
    default_ttl = 86400
    max_ttl     = 31536000
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name = "cloudfront distribution to application load balancer"
  }
}
