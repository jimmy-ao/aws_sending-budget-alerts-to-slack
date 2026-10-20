# Amazon Q Developer in chat applications

resource "aws_chatbot_slack_channel_configuration" "budget" {
  configuration_name = local.chatbot_name
  iam_role_arn       = aws_iam_role.chatbot.arn
  slack_team_id      = var.slack_team_id
  slack_channel_id   = var.slack_channel_id

  logging_level               = "ERROR"
  guardrail_policy_arns       = [aws_iam_policy.chatbot_guardrail.arn]
  user_authorization_required = true
  sns_topic_arns              = [aws_sns_topic.slack.arn]


  tags = {
    Name    = local.chatbot_name
    Service = "AWSChatBot"
  }
}