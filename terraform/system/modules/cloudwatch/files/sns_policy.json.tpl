{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "cloudwatch.amazonaws.com"
        },
        "Action": "sns:Publish",
        "Resource": "${Resource}"
      }
    ]
  }
  