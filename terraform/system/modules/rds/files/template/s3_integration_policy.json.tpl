{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:ListBucket",
                "s3:PutObject",
                "s3:GetBucketLocation",
                "s3:ListMultipartUploadParts",
                "s3:AbortMultipartUpload"
            ],
            "Resource": [
                "${BUCKET}/*",
                "${BUCKET}"
            ]
        },
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": "kms:*",
            "Resource": "*"
        }
    ]
}