resource "aws_sns_topic" "alert_topic" {
  name = "my-alias-alert-topic"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.alert_topic.arn
  protocol  = "email"
  endpoint  = "your-email@example.com" # Change to your email
}

resource "aws_cloudwatch_dashboard" "consolidated_dashboard" {
  dashboard_name = "my-consolidated-dashboard"

  dashboard_body = <<EOF
{
  "widgets": [
    {
      "type": "metric",
      "x": 0,
      "y": 0,
      "width": 6,
      "height": 6,
      "properties": {
        "metrics": [
          ["/moviedb-api/my-alias", "info-count"]
        ],
        "view": "timeSeries",
        "stacked": false,
        "region": "us-east-1",
        "title": "Info Count Metrics"
      }
    }
  ]
}
EOF
}
