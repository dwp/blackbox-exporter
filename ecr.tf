resource "aws_ecr_repository" "blackbox-exporter" {
  name = "blackbox-exporter"
  tags = merge(
    local.common_tags,
    { DockerHub : "dwpdigital/blackbox-exporter" }
  )
}

resource "aws_ecr_repository_policy" "blackbox-exporter" {
  repository = aws_ecr_repository.blackbox-exporter.name
  policy     = data.terraform_remote_state.management.outputs.ecr_iam_policy_document
}

output "ecr_example_url" {
  value = aws_ecr_repository.blackbox-exporter.repository_url
}
