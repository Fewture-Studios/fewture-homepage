# Fewture Homepage - Deployment Architecture & DNS Guide

## 🏗️ Infrastructure Overview

### AWS Services Stack
```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Route 53      │    │  Application     │    │   AWS Lambda    │
│   DNS Records   │───▶│  Load Balancer   │───▶│   Function      │
│                 │    │   (ALB)          │    │                 │
└─────────────────┘    └──────────────────┘    └─────────────────┘
                                │                        │
                                ▼                        ▼
                       ┌──────────────────┐    ┌─────────────────┐
                       │   SSL/TLS        │    │   Amazon S3     │
                       │  Certificate     │    │   Bucket        │
                       │   (ACM)          │    │                 │
                       └──────────────────┘    └─────────────────┘
```

## 🌐 DNS Configuration

### Domain Setup
- **Primary Domain**: `fewture.co`
- **WWW Subdomain**: `www.fewture.co`
- **DNS Provider**: Route 53 (assumed)
- **SSL Certificate**: AWS Certificate Manager

### DNS Records
```
Type    Name              Value
A       fewture.co        → ALB IP (auto-managed by AWS)
CNAME   www.fewture.co    → ALB DNS name
```

### Load Balancer Details
- **Name**: `fewture-homepage-alb`
- **DNS**: `fewture-homepage-alb-1364200841.us-east-2.elb.amazonaws.com`
- **Region**: `us-east-2`
- **Scheme**: Internet-facing
- **IP Version**: IPv4

## 🔐 SSL/TLS Configuration

### Certificate Details
- **ARN**: `arn:aws:acm:us-east-2:650251691374:certificate/087856e6-ae69-4780-b7b7-8403a00d797c`
- **Domains Covered**: 
  - `fewture.co`
  - `www.fewture.co`
- **Validation**: DNS validation
- **Renewal**: Automatic

### Security Headers
```
Strict-Transport-Security: max-age=31536000; includeSubDomains
X-Content-Type-Options: nosniff
X-Frame-Options: DENY
X-XSS-Protection: 1; mode=block
```

## 🚀 Deployment Process

### 1. Lambda Function Deployment
```bash
# Package function with dependencies
cd backend/
zip -r ../lambda-deployment.zip .

# Deploy to AWS
aws lambda update-function-code \
  --function-name fewture-chatbot-east2 \
  --zip-file fileb://lambda-deployment.zip \
  --region us-east-2

# Verify deployment
aws lambda get-function \
  --function-name fewture-chatbot-east2 \
  --region us-east-2 \
  --query 'Configuration.LastUpdateStatus'
```

### 2. Frontend Deployment
```bash
# Deploy main HTML file
aws s3 cp index.html s3://fewture-homepage-prod/index.html

# Deploy assets (if updated)
aws s3 sync assets/ s3://fewture-homepage-prod/assets/ \
  --exclude "*.DS_Store"

# Set proper content types
aws s3 cp assets/video/IRL.mp4 s3://fewture-homepage-prod/assets/video/IRL.mp4 \
  --content-type "video/mp4" \
  --cache-control "max-age=31536000"
```

### 3. CORS Configuration
```bash
# Apply CORS rules to S3 bucket
aws s3api put-bucket-cors \
  --bucket fewture-homepage-prod \
  --cors-configuration file://cors-config.json
```

## 📦 Asset Management

### S3 Bucket Structure
```
fewture-homepage-prod/
├── index.html                 # Main application file
├── assets/
│   ├── images/
│   │   ├── favicon.png
│   │   └── logos/
│   ├── models/
│   │   └── scene.glb         # 3D model (~2MB)
│   ├── video/
│   │   ├── IRL.mp4           # 54MB
│   │   ├── FEWTUREFUND.mp4   # ~87MB
│   │   └── WILLIE.mp4        # ~475MB
│   └── styles/
│       └── fonts/
```

### Storage Classes
- **Standard**: HTML, CSS, JS files
- **Standard-IA**: Video files (cost optimization)
- **Intelligent Tiering**: Large assets with variable access

## 🔄 Request Routing

### ALB Listener Rules
1. **HTTPS:443** (Primary)
   - SSL Termination
   - Forward to Lambda Target Group

2. **HTTP:80** (Redirect)
   - Redirect to HTTPS

### Lambda Function Logic
```python
# Request routing in lambda_function.py
if method == 'POST' and path == '/chat':
    return handle_chat_request(event)
elif method == 'GET':
    if path.endswith(('.mp4', '.mov', '.avi', '.mkv', '.webm')):
        return redirect_to_s3_video(path)
    else:
        return serve_static_file(path)
else:
    return method_not_allowed()
```

### Video Streaming Strategy
```
User Request → ALB → Lambda → 302 Redirect → S3 HTTPS Endpoint
                                              ↓
                                         Video Stream with Range Support
```

## 🔧 Environment Configuration

### Lambda Environment Variables
```
OPENAI_API_KEY=sk-proj-[redacted]
```

### Lambda Function Settings
- **Runtime**: Python 3.11
- **Memory**: 512 MB
- **Timeout**: 300 seconds (5 minutes)
- **Architecture**: x86_64

### IAM Permissions
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::fewture-homepage-prod",
        "arn:aws:s3:::fewture-homepage-prod/*"
      ]
    }
  ]
}
```

## 🔍 Monitoring & Logging

### CloudWatch Logs
- **Lambda Logs**: `/aws/lambda/fewture-chatbot-east2`
- **ALB Access Logs**: (Optional) S3 bucket for access patterns
- **Retention**: 30 days default

### Health Checks
- **ALB Health Check**: `/` endpoint
- **Lambda Timeout**: 300s with proper error handling
- **S3 Availability**: 99.999999999% (11 9's)

## 🚨 Troubleshooting Guide

### Common Issues

#### 1. Video Loading Timeouts
**Symptoms**: Videos don't load, network timeouts
**Cause**: Mixed content (HTTP resources on HTTPS site)
**Solution**: Ensure S3 redirects use HTTPS endpoints

#### 2. CORS Errors
**Symptoms**: Browser blocks video requests
**Cause**: Missing or incorrect CORS headers
**Solution**: Update S3 bucket CORS configuration

#### 3. Lambda Cold Starts
**Symptoms**: First request takes >5 seconds
**Cause**: Lambda initialization delay
**Solution**: Consider provisioned concurrency for production

#### 4. SSL Certificate Issues
**Symptoms**: Browser security warnings
**Cause**: Certificate mismatch or expiration
**Solution**: Verify ACM certificate covers all domains

### Debugging Commands
```bash
# Test video endpoint
curl -v https://www.fewture.co/assets/video/IRL.mp4

# Check CORS headers
curl -H "Origin: https://www.fewture.co" \
     -H "Access-Control-Request-Method: GET" \
     -X OPTIONS \
     https://fewture-homepage-prod.s3.amazonaws.com/assets/video/IRL.mp4

# Lambda function status
aws lambda get-function \
  --function-name fewture-chatbot-east2 \
  --region us-east-2

# S3 bucket CORS
aws s3api get-bucket-cors --bucket fewture-homepage-prod
```

## 🔄 Rollback Procedures

### Lambda Rollback
```bash
# List function versions
aws lambda list-versions-by-function \
  --function-name fewture-chatbot-east2

# Rollback to previous version
aws lambda update-function-configuration \
  --function-name fewture-chatbot-east2 \
  --code-sha-256 [previous-version-sha]
```

### S3 Rollback
```bash
# List object versions
aws s3api list-object-versions \
  --bucket fewture-homepage-prod \
  --prefix index.html

# Restore previous version
aws s3api copy-object \
  --bucket fewture-homepage-prod \
  --copy-source fewture-homepage-prod/index.html?versionId=[version-id] \
  --key index.html
```

## 📋 Deployment Checklist

### Pre-Deployment
- [ ] Test locally with browser preview
- [ ] Verify all assets are optimized
- [ ] Check Lambda function package size (<50MB)
- [ ] Validate CORS configuration
- [ ] Review environment variables

### Deployment
- [ ] Deploy Lambda function
- [ ] Wait for "Successful" status
- [ ] Upload frontend assets to S3
- [ ] Test video streaming endpoints
- [ ] Verify chatbot functionality

### Post-Deployment
- [ ] Monitor CloudWatch logs for errors
- [ ] Test from multiple devices/browsers
- [ ] Verify SSL certificate status
- [ ] Check performance metrics
- [ ] Update documentation

This architecture provides a robust, scalable foundation for the Fewture homepage while maintaining security, performance, and maintainability standards.
