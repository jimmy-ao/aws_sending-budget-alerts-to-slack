# outputs

# budget

output "budget_name" {
  description = "Name of the AWS Budget."
  value       = aws_budgets_budget.slack.name
}

output "budget_arn" {
  description = "ARN of the AWS Budget."
  value       = aws_budgets_budget.slack.arn
}

output "budget_limit" {
  description = "Monthly budget limit, in USD."
  value       = var.budget_limit_amount
}

output "budget_notifications" {
  description = "Configured budget alerts, with the USD amount at which each one fires."
  value = {
    for key, n in var.budget_notifications : key => {
      type       = n.type
      threshold  = "${n.threshold}%"
      amount_usd = var.budget_limit_amount * n.threshold / 100
    }
  }
}

# sns

output "sns_topic_name" {
  description = "Name of the SNS topic receiving budget notifications."
  value       = aws_sns_topic.slack.name
}

output "sns_topic_arn" {
  description = "ARN of the SNS topic receiving budget notifications. Other alarms (Cost Anomaly Detection, CloudWatch) can publish here too."
  value       = aws_sns_topic.slack.arn
}

# amazon q developer in chat applications (chatbot)

output "chatbot_configuration_arn" {
  description = "ARN of the Amazon Q Developer Slack channel configuration."
  value       = aws_chatbot_slack_channel_configuration.budget.chat_configuration_arn
}

output "chatbot_iam_role_arn" {
  description = "ARN of the IAM role assumed by Amazon Q Developer for this channel."
  value       = aws_iam_role.chatbot.arn
}

output "slack_channel_id" {
  description = "Slack channel ID receiving the alerts."
  value       = var.slack_channel_id
}
