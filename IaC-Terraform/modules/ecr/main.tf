resource "aws_ecr_repository" "this" {
  name                 = var.repository_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = merge(
    {
      Name = var.repository_name
    },
    var.tags
  )
}

resource "aws_ecr_lifecycle_policy" "this" {
  count = var.expiration_after_days > 0 ? 1 : 0

  repository = aws_ecr_repository.this.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Expire untagged images older than ${var.expiration_after_days} days"
        selection = {
          tagStatus     = "untagged"
          countType     = "sinceImagePushed"
          countUnit     = "days"
          countNumber   = var.expiration_after_days
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}
