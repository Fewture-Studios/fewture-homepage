#!/bin/bash
# deploy-videos-only.sh - Upload video assets only

set -e

echo "📹 Uploading video assets to AWS S3"

# Configuration
BUCKET_NAME="fewture-homepage-prod"
DISTRIBUTION_ID="YOUR_CLOUDFRONT_DISTRIBUTION_ID"

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

# Check if video directory exists
if [ ! -d "assets/video" ]; then
    echo -e "${RED}❌ Video directory not found: assets/video${NC}"
    exit 1
fi

# Display video files to be uploaded
echo "📋 Video files to upload:"
ls -lh assets/video/ | grep -v "^total"

echo ""
read -p "Continue with upload? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Upload cancelled."
    exit 0
fi

# Upload video assets with optimized settings
echo "📤 Uploading video assets..."
aws s3 sync assets/video/ s3://$BUCKET_NAME/assets/video/ \
    --cache-control "max-age=31536000" \
    --storage-class STANDARD_IA \
    --exclude ".DS_Store" \
    --size-only

# Invalidate CloudFront cache for videos
if [ "$DISTRIBUTION_ID" != "YOUR_CLOUDFRONT_DISTRIBUTION_ID" ]; then
    echo "🔄 Invalidating video cache..."
    INVALIDATION_ID=$(aws cloudfront create-invalidation \
        --distribution-id $DISTRIBUTION_ID \
        --paths "/assets/video/*" \
        --query 'Invalidation.Id' \
        --output text)
    echo "📋 Invalidation ID: $INVALIDATION_ID"
else
    echo -e "${YELLOW}⚠️  CloudFront distribution ID not set, skipping cache invalidation${NC}"
fi

echo -e "${GREEN}✅ Video deployment complete!${NC}"
echo "🌐 Videos will be available at: https://fewture.co/assets/video/"
