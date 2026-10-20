# data

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "slack_sns_topic" {

  statement {
    sid = "AWS-SNS-Publish-AWSBudgets-notification"

    actions = [
      "SNS:Publish"
    ]

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"

      values = [
        "arn:aws:budgets::${data.aws_caller_identity.current.account_id}:*"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"

      values = [
        data.aws_caller_identity.current.account_id
      ]
    }

    effect = "Allow"

    principals {
      type = "Service"
      identifiers = [
        "budgets.amazonaws.com"
      ]
    }

    resources = [
      aws_sns_topic.slack.arn
    ]
  }
}