# AWS Setup Guide for OpenAI Chat Integration

## Prerequisites
- AWS Account
- OpenAI API Key (from platform.openai.com)

## Step 1: Create Lambda Function

1. **Go to AWS Lambda Console**
   - Navigate to https://console.aws.amazon.com/lambda/
   - Click "Create function"

2. **Configure Function**
   - Choose "Author from scratch"
   - Function name: `fewture-chat-bot`
   - Runtime: `Python 3.11`
   - Click "Create function"

3. **Upload Code**
   - Copy the contents of `lambda_function.py`
   - Paste into the Lambda code editor
   - Click "Deploy"

4. **Add Dependencies**
   - In the Lambda console, go to "Layers"
   - Create a new layer with the `requests` library
   - Or use the built-in `urllib3` instead of `requests`

5. **Set Environment Variables**
   - Go to "Configuration" → "Environment variables"
   - Add: `OPENAI_API_KEY` = `your_openai_api_key_here`

## Step 2: Create API Gateway

1. **Go to API Gateway Console**
   - Navigate to https://console.aws.amazon.com/apigateway/
   - Click "Create API"
   - Choose "REST API" → "Build"

2. **Configure API**
   - API name: `fewture-chat-api`
   - Description: `Chat API for Fewture homepage`
   - Click "Create API"

3. **Create Resource**
   - Click "Actions" → "Create Resource"
   - Resource Name: `chat`
   - Resource Path: `/chat`
   - Enable CORS: ✓
   - Click "Create Resource"

4. **Create Method**
   - Select the `/chat` resource
   - Click "Actions" → "Create Method"
   - Choose "POST"
   - Integration type: "Lambda Function"
   - Lambda Function: `fewture-chat-bot`
   - Click "Save"

5. **Enable CORS**
   - Select the `/chat` resource
   - Click "Actions" → "Enable CORS"
   - Access-Control-Allow-Origin: `*`
   - Access-Control-Allow-Headers: `Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token`
   - Click "Enable CORS and replace existing CORS headers"

6. **Deploy API**
   - Click "Actions" → "Deploy API"
   - Deployment stage: "New Stage"
   - Stage name: `prod`
   - Click "Deploy"

## Step 3: Get API Endpoint URL

After deployment, you'll get an Invoke URL like:
```
https://xxxxxxxxxx.execute-api.us-east-1.amazonaws.com/prod/chat
```

## Step 4: Update Frontend

Replace `YOUR_AWS_API_GATEWAY_URL_HERE` in your `index.html` with the actual API Gateway URL.

## Step 5: Test

1. Open your website
2. Type a message in the chat
3. Verify the response comes from OpenAI

## Cost Monitoring

- Set up billing alerts in AWS
- Monitor Lambda invocations and API Gateway requests
- Track OpenAI API usage

## Security Notes

- Never commit your OpenAI API key to version control
- Consider adding API key authentication to API Gateway for production
- Monitor for unusual usage patterns
