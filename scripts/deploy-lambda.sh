#!/bin/bash

# Fewture Homepage - Lambda Deployment Script
set -e

echo "🚀 Deploying Fewture Chatbot Lambda Function..."

# Get AWS account ID
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
REGION="us-east-1"

# Create deployment directory
echo "📦 Preparing deployment package..."
mkdir -p lambda-deploy
cd lambda-deploy

# Copy Lambda function and requirements
cp ../backend/lambda_function.py .
cp ../backend/requirements.txt .

# Install dependencies
echo "📦 Installing Python dependencies..."
python3 -m pip install -r requirements.txt -t .

# Create deployment package
echo "📦 Creating deployment ZIP..."
zip -r fewture-chatbot-lambda.zip . -x "*.pyc" "__pycache__/*"

# Deploy Lambda function
echo "🚀 Deploying to AWS Lambda..."

# Check if function exists
if aws lambda get-function --function-name fewture-chatbot --region $REGION >/dev/null 2>&1; then
    echo "📝 Function exists, updating code..."
    aws lambda update-function-code \
        --function-name fewture-chatbot \
        --zip-file fileb://fewture-chatbot-lambda.zip \
        --region $REGION
else
    echo "📝 Creating new function..."
    aws lambda create-function \
        --function-name fewture-chatbot \
        --runtime python3.11 \
        --role arn:aws:iam::$ACCOUNT_ID:role/lambda-execution-role \
        --handler lambda_function.lambda_handler \
        --zip-file fileb://fewture-chatbot-lambda.zip \
        --timeout 30 \
        --memory-size 128 \
        --region $REGION \
        --environment Variables='{OPENAI_API_KEY=PLACEHOLDER}' \
        --description "Fewture Studios AI Chatbot"
fi

# Clean up
cd ..
rm -rf lambda-deploy

echo "✅ Lambda function deployed successfully!"
echo ""
echo "📝 Next steps:"
echo "   1. Set your OpenAI API key: aws lambda update-function-configuration --function-name fewture-chatbot --environment Variables='{OPENAI_API_KEY=your-key-here}'"
echo "   2. Set up API Gateway"
echo "   3. Test the integration"
