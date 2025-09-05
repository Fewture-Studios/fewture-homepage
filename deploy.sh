#!/bin/bash

# Fewture Homepage - One-Click AWS Deployment Script
# This script deploys both frontend and backend to AWS

set -e

echo "🚀 Starting Fewture Homepage deployment to AWS..."

# Configuration
LAMBDA_FUNCTION_NAME="fewture-chat-bot"
API_NAME="fewture-chat-api"
S3_BUCKET_NAME="fewture-homepage-static-$(date +%s)"  # Unique bucket name
REGION="us-east-1"

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "❌ AWS CLI not found. Please install it first:"
    echo "   https://aws.amazon.com/cli/"
    exit 1
fi

# Check if OpenAI API key is set
if [ -z "$OPENAI_API_KEY" ]; then
    echo "❌ OPENAI_API_KEY environment variable not set."
    echo "   Please run: export OPENAI_API_KEY=your_api_key_here"
    exit 1
fi

echo "✅ Prerequisites check passed"

# Step 1: Create and deploy Lambda function
echo "📦 Creating Lambda function..."

# Create deployment package
cd backend
zip -r ../lambda-deployment.zip . -x "*.pyc" "__pycache__/*"
cd ..

# Create Lambda function
aws lambda create-function \
    --function-name $LAMBDA_FUNCTION_NAME \
    --runtime python3.11 \
    --role arn:aws:iam::$(aws sts get-caller-identity --query Account --output text):role/lambda-execution-role \
    --handler lambda_function.lambda_handler \
    --zip-file fileb://lambda-deployment.zip \
    --timeout 30 \
    --memory-size 256 \
    --region $REGION \
    --environment Variables="{OPENAI_API_KEY=$OPENAI_API_KEY}" \
    || echo "Lambda function might already exist, updating..."

# Update function code if it already exists
aws lambda update-function-code \
    --function-name $LAMBDA_FUNCTION_NAME \
    --zip-file fileb://lambda-deployment.zip \
    --region $REGION

echo "✅ Lambda function deployed"

# Step 2: Create API Gateway
echo "🌐 Creating API Gateway..."

# This would require more complex AWS CLI commands
# For now, we'll output instructions
echo "⚠️  Please complete API Gateway setup manually using the comprehensive guide"
echo "   The Lambda function is ready and waiting for API Gateway connection"

# Step 3: Create S3 bucket and deploy frontend
echo "🌍 Creating S3 bucket for frontend..."

# Create S3 bucket
aws s3 mb s3://$S3_BUCKET_NAME --region $REGION

# Configure bucket for static website hosting
aws s3 website s3://$S3_BUCKET_NAME --index-document index.html --error-document index.html

# Set bucket policy for public read access
cat > bucket-policy.json << EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::$S3_BUCKET_NAME/*"
    }
  ]
}
EOF

aws s3api put-bucket-policy --bucket $S3_BUCKET_NAME --policy file://bucket-policy.json

# Upload website files
echo "📤 Uploading website files..."
aws s3 sync . s3://$S3_BUCKET_NAME \
    --exclude "backend/*" \
    --exclude "docs/*" \
    --exclude "*.sh" \
    --exclude "*.zip" \
    --exclude "*.json" \
    --exclude ".git/*" \
    --exclude "node_modules/*"

echo "✅ Frontend deployed to S3"

# Clean up
rm -f lambda-deployment.zip bucket-policy.json

echo ""
echo "🎉 Deployment Complete!"
echo ""
echo "📋 Next Steps:"
echo "1. Complete API Gateway setup using the comprehensive guide"
echo "2. Update index.html with your API Gateway URL"
echo "3. Your website is available at:"
echo "   http://$S3_BUCKET_NAME.s3-website-$REGION.amazonaws.com"
echo ""
echo "💡 For production, set up CloudFront distribution for HTTPS and global CDN"
