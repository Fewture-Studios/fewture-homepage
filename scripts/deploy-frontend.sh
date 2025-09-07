#!/bin/bash
# deploy-frontend.sh - Fewture Homepage Production Deployment

set -e

echo "🚀 Deploying Fewture Homepage to AWS S3 + CloudFront"

# Configuration
BUCKET_NAME="fewture-homepage-prod"
DISTRIBUTION_ID="YOUR_CLOUDFRONT_DISTRIBUTION_ID"
REGION="us-east-1"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if AWS CLI is configured
if ! aws sts get-caller-identity &> /dev/null; then
    echo -e "${RED}❌ AWS CLI not configured. Please run 'aws configure' first.${NC}"
    exit 1
fi

# Backup original index.html
echo "📝 Backing up original index.html..."
cp index.html index.html.backup

# Update API endpoint for production
echo "🔧 Updating API endpoint for production..."
sed -i.tmp 's|http://fewture-homepage-alb.*amazonaws\.com|https://fewture.co|g' index.html
rm index.html.tmp

# Check if bucket exists, create if not
if ! aws s3 ls "s3://$BUCKET_NAME" 2>&1 | grep -q 'NoSuchBucket'; then
    echo "📦 S3 bucket $BUCKET_NAME already exists"
else
    echo "📦 Creating S3 bucket $BUCKET_NAME..."
    aws s3 mb s3://$BUCKET_NAME --region $REGION
    
    # Configure bucket for static website hosting
    echo "🌐 Configuring static website hosting..."
    aws s3 website s3://$BUCKET_NAME \
        --index-document index.html \
        --error-document index.html
fi

# Upload frontend files (excluding videos initially)
echo "📤 Uploading frontend files..."
aws s3 sync . s3://$BUCKET_NAME \
    --exclude "assets/video/*" \
    --exclude ".git/*" \
    --exclude "backend/*" \
    --exclude "docs/*" \
    --exclude "scripts/*" \
    --exclude "*.backup" \
    --exclude "*.tmp" \
    --exclude ".DS_Store" \
    --delete \
    --cache-control "max-age=3600"

# Upload video assets separately with long caching
echo "📹 Uploading video assets..."
if [ -d "assets/video" ]; then
    aws s3 sync assets/video/ s3://$BUCKET_NAME/assets/video/ \
        --cache-control "max-age=31536000" \
        --storage-class STANDARD_IA \
        --exclude ".DS_Store"
    echo -e "${GREEN}✅ Video assets uploaded successfully${NC}"
else
    echo -e "${YELLOW}⚠️  No video directory found, skipping video upload${NC}"
fi

# Invalidate CloudFront cache if distribution ID is provided
if [ "$DISTRIBUTION_ID" != "YOUR_CLOUDFRONT_DISTRIBUTION_ID" ]; then
    echo "🔄 Invalidating CloudFront cache..."
    INVALIDATION_ID=$(aws cloudfront create-invalidation \
        --distribution-id $DISTRIBUTION_ID \
        --paths "/*" \
        --query 'Invalidation.Id' \
        --output text)
    echo "📋 Invalidation ID: $INVALIDATION_ID"
else
    echo -e "${YELLOW}⚠️  CloudFront distribution ID not set, skipping cache invalidation${NC}"
fi

# Restore original index.html
echo "🔄 Restoring original index.html..."
mv index.html.backup index.html

echo -e "${GREEN}✅ Deployment complete!${NC}"
echo "🌐 Website will be available at: https://fewture.co"
if [ "$DISTRIBUTION_ID" != "YOUR_CLOUDFRONT_DISTRIBUTION_ID" ]; then
    echo "⏱️  CloudFront propagation may take 5-15 minutes"
fi

# Display next steps
echo ""
echo "📋 Next Steps:"
echo "1. Update DNS records to point to CloudFront distribution"
echo "2. Verify SSL certificate is active"
echo "3. Test website functionality"
echo "4. Monitor CloudWatch logs"
