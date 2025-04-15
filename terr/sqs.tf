resource "aws_sqs_queue" "karpenter" {
  name = "karpenter-interruption"

  message_retention_seconds = 60
  sqs_managed_sse_enabled   = true
  max_message_size          = 2048

}

