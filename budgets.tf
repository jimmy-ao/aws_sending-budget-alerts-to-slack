# budgets

resource "aws_budgets_budget" "slack" {
  name = local.budget_name

  budget_type  = "COST"
  limit_amount = var.budget_limit_amount
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  time_period_start = formatdate("YYYY-MM-DD_hh:mm", time_static.budget.rfc3339)

  dynamic "notification" {
    for_each = var.budget_notifications

    content {
      comparison_operator       = "GREATER_THAN"
      notification_type         = notification.value.type
      threshold                 = notification.value.threshold
      threshold_type            = "PERCENTAGE"
      subscriber_sns_topic_arns = [aws_sns_topic.slack.arn]
    }
  }

  tags = {
    Name     = local.budget_name
    Location = "global"
    Service  = "AWSBudgets"
  }
}