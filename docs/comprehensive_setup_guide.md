# Comprehensive OpenAI Chat Integration Setup Guide

## Project Structure

```
fewture-homepage/
├── assets/
│   ├── images/
│   └── models/
├── backend/
│   ├── lambda_function.py
│   └── requirements.txt
├── config/
├── docs/
│   ├── aws_setup_guide.md
│   ├── chatbot_integration_plan.md
│   └── comprehensive_setup_guide.md
├── styles/
├── src/
├── index.html
├── package.json
├── tailwind.config.js
└── postcss.config.js
```

## Prerequisites

1. **AWS Account** - Sign up at aws.amazon.com
2. **OpenAI API Key** - Get from platform.openai.com
3. **Basic understanding of AWS Console**

## Phase 1: Frontend Setup (Already Complete)

✅ **Chat UI Overlay** - Game/Twitch style chat with SF Pro Bold font
✅ **JavaScript Integration** - Message handling and API calls ready
✅ **3D Scene Integration** - Action triggers for Three.js scene

## Phase 2: AWS Backend Setup

### Step 1: Get OpenAI API Key

1. Go to https://platform.openai.com/
2. Sign up/login to your account
3. Navigate to "API Keys" section
4. Click "Create new secret key"
5. Copy and save the key (starts with `sk-`)
6. **Important**: Never share this key or commit it to version control

### Step 2: Create AWS Lambda Function

1. **Access AWS Lambda Console**
   ```
   https://console.aws.amazon.com/lambda/
   ```

2. **Create Function**
   - Click "Create function"
   - Choose "Author from scratch"
   - Function name: `fewture-chat-bot`
   - Runtime: `Python 3.11`
   - Architecture: `x86_64`
   - Click "Create function"

3. **Upload Code**
   - Copy contents from `backend/lambda_function.py`
   - Paste into the Lambda code editor
   - Click "Deploy"

4. **Configure Environment Variables**
   - Go to "Configuration" tab
   - Click "Environment variables" in left sidebar
   - Click "Edit"
   - Add new environment variable:
     - Key: `OPENAI_API_KEY`
     - Value: `your_openai_api_key_here`
   - Click "Save"

5. **Add Dependencies Layer**
   - Go to "Layers" section in Lambda console
   - Click "Create layer"
   - Name: `requests-layer`
   - Upload a zip file containing the `requests` library
   - Or use AWS's built-in `urllib3` (modify code accordingly)

6. **Configure Function Settings**
   - Go to "Configuration" → "General configuration"
   - Set timeout to 30 seconds
   - Set memory to 256 MB
   - Click "Save"

### Step 3: Create API Gateway

1. **Access API Gateway Console**
   ```
   https://console.aws.amazon.com/apigateway/
   ```

2. **Create API**
   - Click "Create API"
   - Choose "REST API" (not private)
   - Click "Build"
   - API name: `fewture-chat-api`
   - Description: `Chat API for Fewture Studios homepage`
   - Endpoint Type: `Regional`
   - Click "Create API"

3. **Create Resource**
   - In the API Gateway console, select your API
   - Click "Actions" → "Create Resource"
   - Resource Name: `chat`
   - Resource Path: `/chat`
   - Enable API Gateway CORS: ✓
   - Click "Create Resource"

4. **Create POST Method**
   - Select the `/chat` resource
   - Click "Actions" → "Create Method"
   - Select "POST" from dropdown
   - Click the checkmark
   - Integration type: "Lambda Function"
   - Use Lambda Proxy integration: ✓
   - Lambda Region: (your region, e.g., us-east-1)
   - Lambda Function: `fewture-chat-bot`
   - Click "Save"
   - Click "OK" to give API Gateway permission to invoke Lambda

5. **Enable CORS**
   - Select the `/chat` resource
   - Click "Actions" → "Enable CORS"
   - Access-Control-Allow-Origin: `*`
   - Access-Control-Allow-Headers: `Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token`
   - Access-Control-Allow-Methods: Select `POST` and `OPTIONS`
   - Click "Enable CORS and replace existing CORS headers"

6. **Deploy API**
   - Click "Actions" → "Deploy API"
   - Deployment stage: "New Stage"
   - Stage name: `prod`
   - Stage description: `Production stage`
   - Click "Deploy"

7. **Get API Endpoint URL**
   - After deployment, you'll see an "Invoke URL"
   - Copy this URL (format: `https://xxxxxxxxxx.execute-api.region.amazonaws.com/prod`)
   - Your chat endpoint will be: `{Invoke URL}/chat`

### Step 4: Update Frontend

1. **Open `index.html`**
2. **Find this line:**
   ```javascript
   const API_ENDPOINT = 'YOUR_AWS_API_GATEWAY_URL_HERE';
   ```
3. **Replace with your actual endpoint:**
   ```javascript
   const API_ENDPOINT = 'https://xxxxxxxxxx.execute-api.us-east-1.amazonaws.com/prod/chat';
   ```
4. **Save the file**

## Phase 3: Testing

### Test Lambda Function

1. **In Lambda Console**
   - Go to your `fewture-chat-bot` function
   - Click "Test"
   - Create new test event:
   ```json
   {
     "body": "{\"message\": \"Hello, tell me about Fewture Studios\"}"
   }
   ```
   - Click "Test"
   - Verify successful response

### Test API Gateway

1. **In API Gateway Console**
   - Go to your API → Resources → `/chat` → POST
   - Click "TEST"
   - Request Body:
   ```json
   {
     "message": "What projects do you have?"
   }
   ```
   - Click "Test"
   - Verify 200 response with proper CORS headers

### Test Frontend Integration

1. **Open your website**
2. **Open browser developer tools (F12)**
3. **Type a message in the chat**
4. **Check for:**
   - Message appears in chat
   - Network request to API Gateway
   - Response from OpenAI
   - Any 3D scene actions triggered

## Phase 4: AWS Frontend Hosting (Optional but Recommended)

### Why Host Frontend on AWS?

**Cost-Effective:**
- S3 + CloudFront: ~$1-3/month for typical traffic
- Perfect integration with your Lambda backend
- Global CDN for fast loading worldwide

### Step 1: Create S3 Bucket

1. **Go to S3 Console**
   ```
   https://console.aws.amazon.com/s3/
   ```

2. **Create Bucket**
   - Click "Create bucket"
   - Bucket name: `fewture-homepage-static` (must be globally unique)
   - Region: Same as your Lambda function
   - Uncheck "Block all public access"
   - Acknowledge the warning
   - Click "Create bucket"

3. **Configure Static Website Hosting**
   - Select your bucket
   - Go to "Properties" tab
   - Scroll to "Static website hosting"
   - Click "Edit"
   - Enable "Static website hosting"
   - Index document: `index.html`
   - Error document: `index.html`
   - Click "Save changes"

4. **Set Bucket Policy**
   - Go to "Permissions" tab
   - Click "Bucket policy"
   - Add this policy (replace `your-bucket-name`):
   ```json
   {
     "Version": "2012-10-17",
     "Statement": [
       {
         "Sid": "PublicReadGetObject",
         "Effect": "Allow",
         "Principal": "*",
         "Action": "s3:GetObject",
         "Resource": "arn:aws:s3:::your-bucket-name/*"
       }
     ]
   }
   ```

### Step 2: Upload Website Files

1. **Prepare Files**
   - Ensure your `index.html` has the correct API Gateway URL
   - Include all assets (images, models, etc.)

2. **Upload to S3**
   - Select your bucket
   - Click "Upload"
   - Drag and drop your files:
     - `index.html`
     - `assets/` folder
     - Any other static files
   - Click "Upload"

### Step 3: Create CloudFront Distribution

1. **Go to CloudFront Console**
   ```
   https://console.aws.amazon.com/cloudfront/
   ```

2. **Create Distribution**
   - Click "Create distribution"
   - Origin domain: Select your S3 bucket
   - Origin access: "Origin access control settings"
   - Create new OAC if needed
   - Default root object: `index.html`
   - Price class: "Use only North America and Europe" (cheaper)
   - Click "Create distribution"

3. **Update S3 Bucket Policy**
   - CloudFront will provide a new bucket policy
   - Replace your existing S3 bucket policy with the CloudFront one

### Step 4: Get Your Website URL

- CloudFront will provide a distribution domain name
- Format: `https://d1234567890123.cloudfront.net`
- Your website is now live globally!

### Step 5: Custom Domain (Optional)

1. **Register Domain** (if you don't have one)
2. **Request SSL Certificate** in AWS Certificate Manager
3. **Add Custom Domain** to CloudFront distribution
4. **Update DNS** to point to CloudFront

### Cost Breakdown

**Monthly costs for typical usage:**
- S3 storage (100MB): ~$0.002
- S3 requests (10K): ~$0.004
- CloudFront (1GB transfer): ~$0.085
- **Total: ~$1-3/month**

### Deployment Script

Create `deploy.sh` for easy updates:
```bash
#!/bin/bash
aws s3 sync . s3://your-bucket-name --exclude "*.md" --exclude "backend/*" --exclude "docs/*"
aws cloudfront create-invalidation --distribution-id YOUR_DISTRIBUTION_ID --paths "/*"
```

## Phase 5: Production Optimization

### Security Enhancements

1. **API Key Management**
   - Use AWS Secrets Manager for OpenAI API key
   - Rotate keys regularly

2. **API Gateway Security**
   - Add API key authentication
   - Implement rate limiting
   - Restrict CORS to your domain only

3. **Lambda Security**
   - Use least-privilege IAM roles
   - Enable CloudTrail logging

### Cost Optimization

1. **Set up Billing Alerts**
   - AWS Billing Dashboard
   - Set alerts for Lambda invocations
   - Monitor OpenAI API usage

2. **Implement Caching**
   - Cache common responses
   - Use CloudFront for static assets

3. **Optimize Lambda**
   - Right-size memory allocation
   - Use provisioned concurrency if needed

### Monitoring

1. **CloudWatch Logs**
   - Monitor Lambda execution logs
   - Set up error alerts

2. **API Gateway Metrics**
   - Track request count and latency
   - Monitor error rates

## Troubleshooting

### Common Issues

1. **CORS Errors**
   - Verify CORS is enabled on API Gateway
   - Check Access-Control-Allow-Origin header

2. **Lambda Timeout**
   - Increase timeout in Lambda configuration
   - Optimize OpenAI API call

3. **OpenAI API Errors**
   - Verify API key is correct
   - Check OpenAI account billing status
   - Monitor rate limits

4. **Network Issues**
   - Check browser network tab
   - Verify API Gateway URL is correct

### Debug Steps

1. **Check Browser Console**
   - Look for JavaScript errors
   - Verify API calls are being made

2. **Check Lambda Logs**
   - Go to CloudWatch Logs
   - Find your Lambda function logs
   - Look for error messages

3. **Test API Directly**
   - Use Postman or curl to test API Gateway
   - Verify response format

## File Structure Reference

```
backend/
├── lambda_function.py    # AWS Lambda function code
└── requirements.txt      # Python dependencies

docs/
├── aws_setup_guide.md           # Original AWS setup guide
├── chatbot_integration_plan.md  # Integration planning document
└── comprehensive_setup_guide.md # This complete guide

config/                   # Configuration files (future use)
styles/                   # CSS files (future organization)
```

## Next Steps

1. **Follow this guide step by step**
2. **Test each phase before moving to the next**
3. **Monitor costs and usage**
4. **Implement security best practices**
5. **Consider adding more 3D scene interactions**

## Support

If you encounter issues:
1. Check the troubleshooting section
2. Review AWS CloudWatch logs
3. Verify all configuration steps
4. Test components individually
