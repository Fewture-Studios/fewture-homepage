# AWS Credentials Setup Guide

## Step 1: Get Your AWS Credentials

### Option A: If you have AWS Console access
1. Go to [AWS Console](https://console.aws.amazon.com/)
2. Sign in to your account
3. Navigate to **IAM** (Identity and Access Management)
4. Click **Users** in the left sidebar
5. Click your username (or create a new user if needed)
6. Go to **Security credentials** tab
7. Click **Create access key**
8. Choose **Command Line Interface (CLI)**
9. Copy the **Access Key ID** and **Secret Access Key**

### Option B: If someone else manages AWS
Ask your AWS administrator for:
- AWS Access Key ID (starts with `AKIA...`)
- AWS Secret Access Key (long random string)
- Preferred AWS region (recommend `us-east-1`)

## Step 2: Configure AWS CLI

Run this command and enter your credentials when prompted:

```bash
aws configure
```

You'll be asked for:
1. **AWS Access Key ID**: Paste your access key
2. **AWS Secret Access Key**: Paste your secret key  
3. **Default region name**: Enter `us-east-1`
4. **Default output format**: Enter `json`

## Step 3: Test Your Configuration

Run this to verify your credentials work:

```bash
aws sts get-caller-identity
```

You should see output with your AWS account info.

## Step 4: Set OpenAI API Key

You'll also need your OpenAI API key for the chatbot:

1. Go to [OpenAI Platform](https://platform.openai.com/api-keys)
2. Create a new API key if you don't have one
3. Copy the key (starts with `sk-...`)
4. We'll use this when deploying the Lambda function

## Security Notes

- Never commit AWS credentials to version control
- Store them securely on your local machine only
- The `aws configure` command stores them in `~/.aws/credentials`
- Lambda will use environment variables for the OpenAI key

## Next Steps

Once credentials are configured, we can:
1. Deploy the Lambda function
2. Set up API Gateway
3. Connect the frontend to the live API
4. Test the complete chatbot integration
