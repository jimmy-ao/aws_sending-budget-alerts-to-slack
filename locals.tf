# locals

locals {

  env = substr(var.environment, 0, 1)
  reg = join("", [element((split("-", var.region)), 0), substr(element((split("-", var.region)), 1), 0, 1), element((split("-", var.region)), 2)])

  budget_name                   = join("-", [local.env, "bdg", "glb", "usd", "monthly", "limit", var.budget_limit_amount])
  sns_name                      = join("-", [local.env, "sns", local.reg, "budget-to-slack-topic"])
  chatbot_role_name             = join("-", [local.env, "iam", "glb", "chatbot-budget-alerting-role"])
  chatbot_policy_name           = join("-", [local.env, "iam", "glb", "chatbot-notifications-only"])
  chatbot_guardrail_policy_name = join("-", [local.env, "iam", "glb", "chatbot-guardrail-notifications-only"])
  chatbot_name                  = join("-", [local.env, "q", local.reg, "budget-alerting-slack"])
}