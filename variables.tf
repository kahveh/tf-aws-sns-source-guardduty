variable "sns_topic_arn" {
  type = string
}

variable "cloudwatch_event_rule_pattern_detail_type" {
  type    = string
  default = "GuardDuty Finding"
}