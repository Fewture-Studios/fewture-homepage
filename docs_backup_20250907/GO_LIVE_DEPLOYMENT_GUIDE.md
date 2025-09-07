# Go-Live Deployment Guide - AWS S3 + CloudFront
**Project:** Fewture Homepage  
**Date:** September 6, 2025  
**Status:** Production Ready

---

## 📋 **Overview**

This guide covers the complete process for deploying the Fewture homepage from local development to AWS production hosting using S3 + CloudFront, including video content hosting solutions.

### **Current Architecture**
- **Frontend:** Local development server
- **Backend:** AWS Lambda + ALB (already deployed)
- **Videos:** Local assets (644MB total)
- **Domain:** fewture.co (currently pointing to TinyHost)

### **Target Architecture**
- **Frontend:** AWS S3 + CloudFront
- **Backend:** AWS Lambda + ALB (existing)
- **Videos:** AWS S3 + CloudFront (optimized delivery)
- **Domain:** fewture.co (updated DNS to CloudFront)

---

## 🎯 **Video Content Analysis**

### **Current Video Assets**
```
assets/video/
├── IRL.mov (81.7MB) - Internet Racing League teaser
├── FewtureFund.MOV (86.9MB) - Fewture Fund presentation  
├── Willie.mp4 (475.3MB) - Willie/MAL virtual influencer content
└── Fewture Media Deck.pdf (6.6MB) - Company presentation
```

**Total Size:** ~644MB of video content

### **Video Hosting Solutions**

#### **Option 1: AWS S3 + CloudFront (Recommended)**
✅ **Pros:**
- Integrated with existing AWS infrastructure
- Global CDN delivery via CloudFront
- Cost-effective for moderate traffic
- Easy integration with existing S3 bucket

❌ **Cons:**
- Higher bandwidth costs for high traffic
- Storage costs for large files

**Estimated Costs:**
- Storage: ~$15/month (644MB)
- Data Transfer: ~$0.09/GB (varies by usage)

#### **Option 2: AWS S3 + External CDN**
✅ **Pros:**
- Lower bandwidth costs
- Better global performance
- Specialized video delivery

❌ **Cons:**
- Additional service complexity
- Separate billing/management

#### **Option 3: Video Streaming Service**
✅ **Pros:**
- Optimized for video delivery
- Adaptive bitrate streaming
- Advanced analytics

❌ **Cons:**
- Higher complexity
- Additional costs
- Overkill for current needs

**Recommendation:** Use AWS S3 + CloudFront for simplicity and integration.

---

## 🚀 **Deployment Process**

### **Phase 1: S3 Bucket Setup**

#### **1.1 Create S3 Bucket**
```bash
# Create main website bucket
aws s3 mb s3://fewture-homepage-prod --region us-east-1

# Create video assets bucket (optional separate bucket)
aws s3 mb s3://fewture-video-assets --region us-east-1
```

#### **1.2 Configure Bucket for Static Hosting**
```bash
# Enable static website hosting
aws s3 website s3://fewture-homepage-prod \
    --index-document index.html \
    --error-document index.html
```

#### **1.3 Set Bucket Policy**
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::fewture-homepage-prod/*"
        }
    ]
}
```

### **Phase 2: Upload Frontend Assets**

#### **2.1 Prepare Frontend for Production**
```bash
# Update API endpoint in index.html
# Change from ALB HTTP to ALB HTTPS for production
sed -i '' 's|http://fewture-homepage-alb-1364200841.us-east-2.elb.amazonaws.com|https://fewture.co|g' index.html
```

#### **2.2 Upload Frontend Files**
```bash
# Upload main website files (excluding videos initially)
aws s3 sync . s3://fewture-homepage-prod \
    --exclude "assets/video/*" \
    --exclude ".git/*" \
    --exclude "backend/*" \
    --exclude "docs/*" \
    --exclude "scripts/*" \
    --delete
```

#### **2.3 Upload Video Assets**
```bash
# Upload videos with optimized settings
aws s3 cp assets/video/ s3://fewture-homepage-prod/assets/video/ \
    --recursive \
    --storage-class STANDARD_IA \
    --metadata-directive REPLACE \
    --cache-control "max-age=31536000"
```

### **Phase 3: CloudFront Distribution**

#### **3.1 Create CloudFront Distribution**
```json
{
    "CallerReference": "fewture-homepage-2025-09-06",
    "Comment": "Fewture Homepage Production Distribution",
    "DefaultRootObject": "index.html",
    "Origins": {
        "Quantity": 1,
        "Items": [
            {
                "Id": "S3-fewture-homepage-prod",
                "DomainName": "fewture-homepage-prod.s3.amazonaws.com",
                "S3OriginConfig": {
                    "OriginAccessIdentity": ""
                }
            }
        ]
    },
    "DefaultCacheBehavior": {
        "TargetOriginId": "S3-fewture-homepage-prod",
        "ViewerProtocolPolicy": "redirect-to-https",
        "TrustedSigners": {
            "Enabled": false,
            "Quantity": 0
        },
        "ForwardedValues": {
            "QueryString": false,
            "Cookies": {
                "Forward": "none"
            }
        },
        "MinTTL": 0,
        "DefaultTTL": 86400,
        "MaxTTL": 31536000
    },
    "Enabled": true,
    "PriceClass": "PriceClass_100"
}
```

#### **3.2 Configure Custom Error Pages**
```bash
# Set up SPA routing (redirect 404s to index.html)
aws cloudfront put-distribution-config \
    --id YOUR_DISTRIBUTION_ID \
    --distribution-config file://cloudfront-config.json
```

### **Phase 4: SSL Certificate**

#### **4.1 Request Certificate (us-east-1 required for CloudFront)**
```bash
aws acm request-certificate \
    --domain-name fewture.co \
    --subject-alternative-names www.fewture.co \
    --validation-method DNS \
    --region us-east-1
```

#### **4.2 Validate Certificate**
```bash
# Get validation records
aws acm describe-certificate \
    --certificate-arn YOUR_CERT_ARN \
    --region us-east-1
```

### **Phase 5: DNS Configuration**

#### **5.1 Update DNS Records**
```
# Remove existing A records pointing to TinyHost
# Add new records:

TYPE: A (Alias)
NAME: @
VALUE: YOUR_CLOUDFRONT_DISTRIBUTION.cloudfront.net

TYPE: CNAME  
NAME: www
VALUE: YOUR_CLOUDFRONT_DISTRIBUTION.cloudfront.net

# SSL validation records (from ACM)
TYPE: CNAME
NAME: _validation_record_name
VALUE: _validation_record_value
```

---

## 🔧 **Deployment Scripts**

### **Frontend Deployment Script**
```bash
#!/bin/bash
# deploy-frontend.sh

set -e

echo "🚀 Deploying Fewture Homepage to AWS S3 + CloudFront"

# Configuration
BUCKET_NAME="fewture-homepage-prod"
DISTRIBUTION_ID="YOUR_CLOUDFRONT_DISTRIBUTION_ID"

# Update API endpoint for production
echo "📝 Updating API endpoint for production..."
sed -i.bak 's|http://fewture-homepage-alb.*amazonaws.com|https://fewture.co|g' index.html

# Upload frontend files
echo "📤 Uploading frontend files..."
aws s3 sync . s3://$BUCKET_NAME \
    --exclude "assets/video/*" \
    --exclude ".git/*" \
    --exclude "backend/*" \
    --exclude "docs/*" \
    --exclude "scripts/*" \
    --exclude "*.bak" \
    --delete

# Upload videos separately with caching
echo "📹 Uploading video assets..."
aws s3 sync assets/video/ s3://$BUCKET_NAME/assets/video/ \
    --cache-control "max-age=31536000" \
    --storage-class STANDARD_IA

# Invalidate CloudFront cache
echo "🔄 Invalidating CloudFront cache..."
aws cloudfront create-invalidation \
    --distribution-id $DISTRIBUTION_ID \
    --paths "/*"

# Restore original file
mv index.html.bak index.html

echo "✅ Deployment complete!"
echo "🌐 Website will be available at: https://fewture.co"
echo "⏱️  CloudFront propagation may take 5-15 minutes"
```

### **Video-Only Deployment Script**
```bash
#!/bin/bash
# deploy-videos.sh

set -e

BUCKET_NAME="fewture-homepage-prod"
DISTRIBUTION_ID="YOUR_CLOUDFRONT_DISTRIBUTION_ID"

echo "📹 Uploading video assets only..."

aws s3 sync assets/video/ s3://$BUCKET_NAME/assets/video/ \
    --cache-control "max-age=31536000" \
    --storage-class STANDARD_IA \
    --size-only

echo "🔄 Invalidating video cache..."
aws cloudfront create-invalidation \
    --distribution-id $DISTRIBUTION_ID \
    --paths "/assets/video/*"

echo "✅ Video deployment complete!"
```

---

## 📊 **Cost Estimation**

### **Monthly Costs (Production)**
```
S3 Storage (1GB): ~$0.023
S3 Requests (10K): ~$0.004
CloudFront (10GB): ~$0.85
ACM Certificate: FREE
Route 53 (hosted zone): $0.50

Total Estimated: ~$1.40/month
```

### **High Traffic Scenario (1TB/month)**
```
S3 Storage: ~$0.023
CloudFront (1TB): ~$85
Other services: ~$1

Total Estimated: ~$86/month
```

---

## ⚡ **Performance Optimizations**

### **Video Optimization**
1. **Compress videos** before upload (optional)
2. **Use appropriate storage class** (Standard-IA for infrequent access)
3. **Set long cache headers** (1 year for videos)
4. **Consider video formats** (MP4 for better compatibility)

### **Frontend Optimization**
1. **Enable Gzip compression** in CloudFront
2. **Set appropriate cache headers** for static assets
3. **Use CloudFront edge locations** for global delivery
4. **Minimize file sizes** where possible

---

## 🔒 **Security Considerations**

### **S3 Security**
- ✅ Bucket policy restricts to read-only public access
- ✅ No write permissions for public users
- ✅ CloudFront Origin Access Identity (optional)

### **CloudFront Security**
- ✅ HTTPS redirect enforced
- ✅ SSL certificate from ACM
- ✅ Geographic restrictions (if needed)

---

## 📋 **Go-Live Checklist**

### **Pre-Deployment**
- [ ] Test chatbot functionality locally
- [ ] Verify all video files are present
- [ ] Update API endpoint in code
- [ ] Backup current DNS settings

### **Deployment**
- [ ] Create S3 bucket
- [ ] Upload frontend files
- [ ] Upload video assets
- [ ] Create CloudFront distribution
- [ ] Request SSL certificate
- [ ] Validate SSL certificate

### **DNS Cutover**
- [ ] Update A record to CloudFront
- [ ] Update CNAME for www subdomain
- [ ] Verify SSL certificate is active
- [ ] Test website functionality

### **Post-Deployment**
- [ ] Test chatbot on production domain
- [ ] Verify video playback
- [ ] Check all theme switching
- [ ] Monitor CloudWatch logs
- [ ] Verify HTTPS redirect

---

## 🚨 **Rollback Plan**

If issues occur during deployment:

1. **Immediate:** Revert DNS to previous TinyHost settings
2. **Frontend Issues:** Upload previous version to S3
3. **Video Issues:** Restore from local backup
4. **SSL Issues:** Use HTTP temporarily while debugging

---

## 📞 **Support Information**

**AWS Services Used:**
- S3 (Static hosting)
- CloudFront (CDN)
- ACM (SSL certificates)
- Route 53 (DNS - if using AWS)

**Monitoring:**
- CloudWatch for S3 and CloudFront metrics
- AWS Cost Explorer for billing
- CloudFront real-time logs (optional)

---

**Estimated Deployment Time:** 2-4 hours  
**DNS Propagation Time:** 5-15 minutes  
**SSL Certificate Validation:** 5-30 minutes  

*This deployment will provide enterprise-grade hosting with global CDN delivery for both the website and video content.*
