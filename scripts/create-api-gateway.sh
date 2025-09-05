#!/bin/bash

# Create API Gateway for Fewture Chatbot
set -e

echo "🌐 Creating API Gateway..."

REGION="us-east-1"
LAMBDA_FUNCTION_NAME="fewture-chatbot"
API_NAME="fewture-chatbot-api"

# Create REST API
echo "📝 Creating REST API..."
API_ID=$(aws apigateway create-rest-api \
    --name $API_NAME \
    --description "API Gateway for Fewture Studios chatbot" \
    --region $REGION \
    --query 'id' \
    --output text)

echo "✅ API created with ID: $API_ID"

# Get root resource ID
ROOT_RESOURCE_ID=$(aws apigateway get-resources \
    --rest-api-id $API_ID \
    --region $REGION \
    --query 'items[0].id' \
    --output text)

# Create /chat resource
echo "📝 Creating /chat resource..."
CHAT_RESOURCE_ID=$(aws apigateway create-resource \
    --rest-api-id $API_ID \
    --parent-id $ROOT_RESOURCE_ID \
    --path-part chat \
    --region $REGION \
    --query 'id' \
    --output text)

# Create POST method
echo "📝 Creating POST method..."
aws apigateway put-method \
    --rest-api-id $API_ID \
    --resource-id $CHAT_RESOURCE_ID \
    --http-method POST \
    --authorization-type NONE \
    --region $REGION

# Create OPTIONS method for CORS
echo "📝 Creating OPTIONS method for CORS..."
aws apigateway put-method \
    --rest-api-id $API_ID \
    --resource-id $CHAT_RESOURCE_ID \
    --http-method OPTIONS \
    --authorization-type NONE \
    --region $REGION

# Get Lambda function ARN
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
LAMBDA_ARN="arn:aws:lambda:$REGION:$ACCOUNT_ID:function:$LAMBDA_FUNCTION_NAME"

# Set up Lambda integration for POST
echo "📝 Setting up Lambda integration..."
aws apigateway put-integration \
    --rest-api-id $API_ID \
    --resource-id $CHAT_RESOURCE_ID \
    --http-method POST \
    --type AWS_PROXY \
    --integration-http-method POST \
    --uri "arn:aws:apigateway:$REGION:lambda:path/2015-03-31/functions/$LAMBDA_ARN/invocations" \
    --region $REGION

# Set up CORS integration for OPTIONS
echo "📝 Setting up CORS integration..."
aws apigateway put-integration \
    --rest-api-id $API_ID \
    --resource-id $CHAT_RESOURCE_ID \
    --http-method OPTIONS \
    --type MOCK \
    --integration-http-method OPTIONS \
    --request-templates '{"application/json":"{\"statusCode\": 200}"}' \
    --region $REGION

# Set up method response for POST
aws apigateway put-method-response \
    --rest-api-id $API_ID \
    --resource-id $CHAT_RESOURCE_ID \
    --http-method POST \
    --status-code 200 \
    --region $REGION

# Set up method response for OPTIONS (CORS)
aws apigateway put-method-response \
    --rest-api-id $API_ID \
    --resource-id $CHAT_RESOURCE_ID \
    --http-method OPTIONS \
    --status-code 200 \
    --response-parameters '{"method.response.header.Access-Control-Allow-Headers": false, "method.response.header.Access-Control-Allow-Methods": false, "method.response.header.Access-Control-Allow-Origin": false}' \
    --region $REGION

# Set up integration response for OPTIONS (CORS)
aws apigateway put-integration-response \
    --rest-api-id $API_ID \
    --resource-id $CHAT_RESOURCE_ID \
    --http-method OPTIONS \
    --status-code 200 \
    --response-parameters '{"method.response.header.Access-Control-Allow-Headers": "'\''Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'\''", "method.response.header.Access-Control-Allow-Methods": "'\''POST,OPTIONS'\''", "method.response.header.Access-Control-Allow-Origin": "'\''*'\''"}' \
    --region $REGION

# Grant API Gateway permission to invoke Lambda
echo "📝 Granting API Gateway permission to invoke Lambda..."
aws lambda add-permission \
    --function-name $LAMBDA_FUNCTION_NAME \
    --statement-id apigateway-invoke \
    --action lambda:InvokeFunction \
    --principal apigateway.amazonaws.com \
    --source-arn "arn:aws:execute-api:$REGION:$ACCOUNT_ID:$API_ID/*/*" \
    --region $REGION

# Deploy API
echo "📝 Deploying API..."
aws apigateway create-deployment \
    --rest-api-id $API_ID \
    --stage-name prod \
    --region $REGION

# Get API endpoint URL
API_URL="https://$API_ID.execute-api.$REGION.amazonaws.com/prod/chat"

echo "✅ API Gateway created successfully!"
echo ""
echo "🌐 API Endpoint: $API_URL"
echo ""
echo "📝 Next steps:"
echo "   1. Update frontend to use this endpoint"
echo "   2. Test the integration"
echo "   3. Verify CORS is working"

# Save endpoint to file for frontend integration
echo "$API_URL" > api-endpoint.txt
echo "💾 API endpoint saved to api-endpoint.txt"
