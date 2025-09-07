# Fewture Homepage - Deployment Guide

## Table of Contents
1. [Quick Start](#quick-start)
2. [AWS Infrastructure](#aws-infrastructure)
3. [Manual Deployment](#manual-deployment)
4. [Troubleshooting](#troubleshooting)
5. [Maintenance](#maintenance)

## Quick Start

### Prerequisites
- AWS Account with admin access
- Node.js 16+ and npm
- AWS CLI configured with appropriate credentials
- Git

### One-Command Deployment (Amplify)
```bash
# Install Amplify CLI
npm install -g @aws-amplify/cli
amplify configure

# Initialize and deploy
amplify init
amplify add hosting
amplify publish
```

## AWS Infrastructure

### Architecture Overview
- **Frontend**: S3 + CloudFront (static hosting with global CDN)
- **Videos**: S3 with Standard-IA storage + CloudFront
- **Backend**: Lambda + API Gateway
- **Security**: WAF, IAM roles, and security groups

### Required AWS Services
- S3 (storage)
- CloudFront (CDN)
- Lambda (backend)
- API Gateway (REST API)
- WAF (security)
- IAM (permissions)

## Manual Deployment

### Frontend Deployment
```bash
# Install dependencies
npm install

# Build project
npm run build

# Deploy to S3
aws s3 sync build/ s3://your-bucket-name --delete

# Invalidate CloudFront cache
aws cloudfront create-invalidation --distribution-id YOUR_DIST_ID --paths "/*"
```

### Backend Deployment
```bash
# Install Python dependencies
cd backend
pip install -r requirements.txt -t .

# Create deployment package
zip -r ../fewture-chatbot.zip .

# Deploy to Lambda
aws lambda update-function-code \
  --function-name fewture-chatbot \
  --zip-file fileb://fewture-chatbot.zip
```

## Troubleshooting

### Common Issues
1. **CORS Errors**
   - Verify API Gateway CORS settings
   - Check Lambda response headers

2. **403 Forbidden**
   - Verify IAM permissions
   - Check S3 bucket policies

3. **500 Internal Server Error**
   - Check CloudWatch logs
   - Verify environment variables

## Maintenance

### Updating Dependencies
```bash
# Frontend
npm update

# Backend
pip install -r requirements.txt --upgrade
```

### Monitoring
- CloudWatch Logs for Lambda
- CloudFront Access Logs
- API Gateway Execution Logs
