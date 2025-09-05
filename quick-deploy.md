# Quick AWS Deployment Guide

## One-Platform AWS Solution

Everything runs on AWS for maximum simplicity and integration.

## Option 1: AWS Amplify (Easiest)

**Single command deployment:**

1. **Install Amplify CLI**
   ```bash
   npm install -g @aws-amplify/cli
   amplify configure
   ```

2. **Initialize Amplify**
   ```bash
   amplify init
   # Follow prompts, choose defaults
   ```

3. **Add Hosting**
   ```bash
   amplify add hosting
   # Choose "Amazon CloudFront and S3"
   ```

4. **Add API**
   ```bash
   amplify add api
   # Choose REST API
   # Use existing Lambda function or create new
   ```

5. **Deploy Everything**
   ```bash
   amplify push
   ```

**Benefits:**
- One command deploys everything
- Git integration (auto-deploy on push)
- Built-in CI/CD
- Automatic HTTPS
- Custom domains easy to add

## Option 2: Manual Script (More Control)

**Prerequisites:**
```bash
# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Configure AWS
aws configure
# Enter your AWS Access Key ID, Secret, Region (us-east-1), Output format (json)

# Set OpenAI API Key
export OPENAI_API_KEY=your_openai_api_key_here
```

**Deploy:**
```bash
chmod +x deploy.sh
./deploy.sh
```

## Recommended: AWS Amplify

For maximum ease of deployment, use **AWS Amplify**:

1. **One-time setup** (5 minutes)
2. **Git-based deployment** (push to deploy)
3. **Everything managed** (frontend + backend + API)
4. **Automatic scaling**
5. **Built-in monitoring**

## Cost Comparison

| Service | Monthly Cost | Ease of Use | Features |
|---------|-------------|-------------|----------|
| **Amplify** | $5-15 | ⭐⭐⭐⭐⭐ | Full CI/CD, Git integration |
| **S3+CloudFront+Lambda** | $1-5 | ⭐⭐⭐ | Manual setup, more control |

**Recommendation: Use AWS Amplify for easiest deployment**
