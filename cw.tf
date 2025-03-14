resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name = "/aws/lambda/my_lambda_function"
}

resource "aws_cloudwatch_log_metric_filter" "info_filter" {
  name           = "info-count"
  log_group_name = aws_cloudwatch_log_group.lambda_log_group.name
  pattern        = "INFO"

  metric_transformation {
    name      = "info-count"
    namespace = "/moviedb-api/my-alias"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "info_alarm" {
  alarm_name          = "my-alias-info-count-breach"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name        = aws_cloudwatch_log_metric_filter.info_filter.metric_transformation[0].name
  namespace         = aws_cloudwatch_log_metric_filter.info_filter.metric_transformation[0].namespace
  period            = "60"
  statistic        = "Sum"
  threshold        = "10"
  alarm_description = "Alarm when the info-count metric exceeds 10."
  actions_enabled   = true

  alarm_actions = [aws_sns_topic.alert_topic.arn]
}
