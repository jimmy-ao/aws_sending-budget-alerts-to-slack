# sns

resource "aws_sns_topic" "slack" {
  name = local.sns_name

  tags = {
    Name    = local.sns_name
    Service = "snsTopic"
  }
}

resource "aws_sns_topic_policy" "slack" {
  arn = aws_sns_topic.slack.arn

  policy = data.aws_iam_policy_document.slack_sns_topic.json
}