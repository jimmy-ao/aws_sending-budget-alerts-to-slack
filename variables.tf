#  variables

variable "profile" {
  type        = string
  description = "Profile used to create Terraform resources."
}

variable "region" {
  type        = string
  description = "Region used to deploy resources in."
  default     = "eu-north-1"
}

variable "environment" {
  type        = string
  description = "Resources environment."
}

variable "project" {
  type        = string
  description = "Project name."
}

# slack

variable "slack_channel_id" {
  type        = string
  description = "Slack channel ID for notifications."
}

variable "slack_team_id" {
  type        = string
  description = "Slack team ID for notifications."
}

#  budgets

variable "budget_limit_amount" {
  type        = number
  description = "Budget limit amount in USD."
  default     = 5
}

variable "budget_notifications" {
  type = map(object({
    type      = string
    threshold = number
  }))

  description = "Budget alerts sent to Slack. Set type as FORECASTED or ACTUAL and threshold as a percentage of the limit."

  default = {
    actual_80    = { type = "ACTUAL", threshold = 80 }
    actual_100   = { type = "ACTUAL", threshold = 100 }
    forecast_50  = { type = "FORECASTED", threshold = 50 }
    forecast_75  = { type = "FORECASTED", threshold = 75 }
    forecast_100 = { type = "FORECASTED", threshold = 100 }
  }

  validation {
    condition     = alltrue([for n in values(var.budget_notifications) : contains(["FORECASTED", "ACTUAL"], n.type)])
    error_message = "Each notification type must be FORECASTED or ACTUAL."
  }

  validation {
    condition     = length(var.budget_notifications) <= 10 && alltrue([for n in values(var.budget_notifications) : n.threshold > 0])
    error_message = "At most 10 notifications, each with a positive threshold."
  }
}