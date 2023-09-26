locals {
  sns_topic_arn         = var.sns_topic_arn
}

## IAM
data "aws_iam_policy_document" "this" {
  policy_id = "GuardDutyPublishToSNS"
  statement {
    actions = [
      "sns:Publish"
    ]
    principals {
      type        = "Service"
      identifiers = ["cloudwatch.amazonaws.com"]
    }
    resources = [local.sns_topic_arn]
  }
}

resource "aws_sns_topic_policy" "this" {
  arn    = local.sns_topic_arn
  policy = data.aws_iam_policy_document.this.json
}

resource "aws_cloudwatch_event_rule" "findings" {
  description = "GuardDuty Findings"

  event_pattern = jsonencode(
    {
      "source" : [
        "aws.guardduty"
      ],
      "detail-type" : [
        var.cloudwatch_event_rule_pattern_detail_type
      ]
    }
  )
}

resource "aws_cloudwatch_event_target" "imported_findings" {
  rule  = aws_cloudwatch_event_rule.findings.name
  arn   = local.sns_topic_arn
}