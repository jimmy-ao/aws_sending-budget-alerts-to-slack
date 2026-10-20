# iam

resource "aws_iam_role_policy" "chatbot" {
  name = local.chatbot_policy_name
  role = aws_iam_role.chatbot.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "cloudwatch:Describe*",
          "cloudwatch:Get*",
          "cloudwatch:List*"
        ],
        "Effect" : "Allow",
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_role" "chatbot" {
  name = local.chatbot_role_name

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "chatbot.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name     = local.chatbot_role_name
    Service  = "IAMRole"
    Location = "global"
  }
}

resource "aws_iam_policy" "chatbot_guardrail" {
  name        = local.chatbot_guardrail_policy_name
  description = "Upper bound for anything run through the budget alerts Slack channel."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:Describe*",
          "cloudwatch:Get*",
          "cloudwatch:List*"
        ]
        Resource = "*"
      }
    ]
  })

  tags = {
    Name     = local.chatbot_guardrail_policy_name
    Service  = "IAMPolicy"
    Location = "global"
  }
}