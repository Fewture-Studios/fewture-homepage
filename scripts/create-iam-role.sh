#!/bin/bash

# Create IAM role for Lambda execution
echo "🔐 Creating Lambda execution role..."

# Create trust policy for Lambda
cat > trust-policy.json << EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

# Create the role
aws iam create-role \
    --role-name lambda-execution-role \
    --assume-role-policy-document file://trust-policy.json \
    --description "Execution role for Fewture chatbot Lambda function"

# Attach basic Lambda execution policy
aws iam attach-role-policy \
    --role-name lambda-execution-role \
    --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole

# Clean up
rm trust-policy.json

echo "✅ IAM role created: lambda-execution-role"
