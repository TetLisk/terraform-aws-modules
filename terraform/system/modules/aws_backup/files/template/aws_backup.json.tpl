{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "backup:*",
                "ec2:DescribeVolumes",
                "ec2:DescribeSnapshots",
                "ec2:DescribeTags",
                "ec2:DescribeInstances",
                "ec2:CreateSnapshot",
                "ec2:DeleteSnapshot",
                "ec2:DescribeTags",
                "ec2:DescribeImages",
                "ec2:CreateImage",
                "ec2:CreateTags",
                "ec2:DeleteTags",
                "ec2:DescribeInstanceCreditSpecifications",
                "ec2:CopySnapshot",
                "ec2:DescribeSnapshotAttribute",
                "ec2:DescribeInstanceAttribute",
                "ec2:DescribeInstanceStatus",
                "ec2:DescribeKeyPairs",
                "ec2:DescribeNetworkInterfaces",
                "rds:DescribeDBInstances",
                "rds:DescribeDBSnapshots",
                "dynamodb:ListTables",
                "dynamodb:DescribeTable",
                "dynamodb:DescribeBackup",
                "dynamodb:ListBackups",
                "dynamodb:CreateBackup",
                "dynamodb:DeleteBackup",
                "dynamodb:RestoreTableFromBackup",
                "dynamodb:RestoreTableToPointInTime",
                "s3:GetBucketLocation",
                "s3:GetObject",
                "s3:ListBucket",
                "s3:PutObject",
                "s3:DeleteObject",
                "s3:AbortMultipartUpload",
                "s3:ListMultipartUploadParts",
                "s3:ListBucketMultipartUploads"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "kms:Decrypt",
                "kms:Encrypt",
                "kms:ReEncrypt*",
                "kms:GenerateDataKey*",
                "kms:DescribeKey"
            ],
            "Resource": "*"
        }
    ]
}