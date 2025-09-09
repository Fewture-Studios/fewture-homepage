# Fewture Homepage - Technical Quirks & Implementation Notes

## 🔧 Critical Technical Quirks

### 1. S3 Region Mismatch
**Issue**: Lambda function is in `us-east-2`, S3 bucket is in `us-east-1`
**Impact**: Pre-signed URLs fail with region mismatch errors
**Solution**: Use direct S3 HTTPS endpoints instead of pre-signed URLs
**Code Location**: `lambda_function.py:367`
```python
# CORRECT: Direct S3 HTTPS endpoint
s3_https_url = f'https://{bucket_name}.s3.amazonaws.com/{s3_key}'

# INCORRECT: Pre-signed URL with wrong region
# presigned_url = s3_client.generate_presigned_url(...)
```

### 2. Mixed Content Security
**Issue**: S3 website endpoints use HTTP, causing mixed content blocking on HTTPS sites
**Impact**: Videos fail to load with network timeouts
**Solution**: Always use HTTPS S3 API endpoints for redirects
**Code Location**: `lambda_function.py:367`
```python
# CORRECT: HTTPS endpoint
s3_https_url = f'https://{bucket_name}.s3.amazonaws.com/{s3_key}'

# INCORRECT: HTTP website endpoint
# s3_website_url = f'http://{bucket_name}.s3-website-us-east-1.amazonaws.com/{s3_key}'
```

### 3. Lambda Response Size Limit
**Issue**: Lambda has 6MB response limit, videos are 50MB+
**Impact**: 502 Bad Gateway errors for large video requests
**Solution**: 302 redirects to S3 for video files
**Code Location**: `lambda_function.py:365-375`
```python
if s3_key.endswith(('.mp4', '.mov', '.avi', '.mkv', '.webm')):
    # Redirect instead of serving directly
    s3_https_url = f'https://{bucket_name}.s3.amazonaws.com/{s3_key}'
    return {
        'statusCode': 302,
        'headers': {'Location': s3_https_url},
        'body': ''
    }
```

### 4. Event Listener Memory Leaks
**Issue**: Dropdown event listeners not properly cleaned up
**Impact**: Multiple event listeners accumulate, causing performance issues
**Solution**: Centralized cleanup function
**Code Location**: `index.html:3077-3083`
```javascript
function closeProjectsDropdown() {
    const dropdown = document.getElementById('projects-dropdown-menu');
    dropdown.classList.remove('show');
    // CRITICAL: Remove ALL event listeners
    document.removeEventListener('click', closeDropdownOnClickOutside);
    document.removeEventListener('scroll', closeDropdownOnScroll, true);
    document.removeEventListener('touchmove', closeDropdownOnScroll, true);
}
```

## 🎨 CSS & Styling Quirks

### 1. Mobile Viewport Handling
**Issue**: iOS Safari viewport units behave differently
**Solution**: Fixed positioning with explicit dimensions
**Code Location**: `index.html:15-30`
```css
body { 
    position: fixed;
    width: 100vw;
    height: 100vh;
    touch-action: none;
    -webkit-overflow-scrolling: touch;
}
```

### 2. Theme Switching Animation Timing
**Issue**: Logo glow animations conflict during theme transitions
**Solution**: Separate keyframe animations per theme
**Code Location**: `index.html:58-98`
```css
/* Each theme needs its own animation */
.dark-mode #logo-container img {
    animation: logoGlowDark 2s ease-in-out infinite alternate;
}
.red-mode #logo-container img {
    animation: logoGlowRed 2s ease-in-out infinite alternate;
}
```

### 3. Z-Index Layering
**Issue**: Complex overlay system requires careful z-index management
**Solution**: Systematic z-index scale
```css
/* Z-index hierarchy */
canvas: 0                    /* 3D scene background */
overlays: 500-999           /* Content overlays */
navigation: 1000            /* Logo and nav */
chat: 2000-2999            /* Chat interface */
dropdowns: 3000+           /* Dropdown menus */
```

## 🎬 Video Streaming Quirks

### 1. Range Request Support
**Issue**: Some browsers require range request support for video scrubbing
**Solution**: S3 automatically provides range request headers
**Verification**: Check for `Accept-Ranges: bytes` in response headers

### 2. Video Preloading Strategy
**Issue**: Large videos cause initial page load delays
**Solution**: Poster images with lazy loading
**Code Location**: `index.html` (video elements)
```html
<video poster="assets/images/posters/irl-poster.jpg" preload="none">
    <source src="assets/video/IRL.mp4" type="video/mp4">
</video>
```

### 3. Mobile Video Playback
**Issue**: iOS requires user interaction for video autoplay
**Solution**: Poster images with explicit play buttons
**Implementation**: Videos only play after user theme selection

## 🤖 Chatbot Integration Quirks

### 1. CORS Preflight Handling
**Issue**: Browser sends OPTIONS request before POST
**Solution**: Explicit OPTIONS handler in Lambda
**Code Location**: `lambda_function.py:15-22`
```python
if event.get('httpMethod') == 'OPTIONS':
    return {
        'statusCode': 200,
        'headers': {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'POST, OPTIONS',
            'Access-Control-Allow-Headers': 'Content-Type'
        },
        'body': ''
    }
```

### 2. OpenAI API Rate Limiting
**Issue**: API has rate limits that can cause 429 errors
**Solution**: Implement exponential backoff (not currently implemented)
**Recommendation**: Add retry logic with delays

### 3. Chat Input Focus Management
**Issue**: Mobile keyboards affect viewport height
**Solution**: Fixed positioning prevents layout shifts
**Code Location**: `index.html` (chat container CSS)

## 🔄 State Management Quirks

### 1. Theme State Persistence
**Issue**: Theme state lost on page refresh
**Current**: Resets to default theme
**Enhancement Opportunity**: localStorage persistence

### 2. Video State Management
**Issue**: Multiple videos can play simultaneously
**Solution**: Explicit video stopping when switching themes
**Code Location**: `index.html` (theme switching functions)

### 3. Dropdown State Conflicts
**Issue**: Multiple dropdowns could theoretically conflict
**Current**: Only one dropdown exists, but pattern should be scalable
**Solution**: Use data attributes for multiple dropdown management

## 🚀 Performance Quirks

### 1. Three.js Memory Management
**Issue**: 3D models not properly disposed, causing memory leaks
**Solution**: Explicit geometry and material disposal
**Enhancement Needed**: Implement proper cleanup in scene switching

### 2. Event Listener Accumulation
**Issue**: Scroll and touch listeners accumulate without cleanup
**Solution**: Always remove listeners in cleanup functions
**Pattern**: Use `addEventListener` with corresponding `removeEventListener`

### 3. Lambda Cold Start Delays
**Issue**: First request after inactivity takes 3-5 seconds
**Mitigation**: Keep-alive requests (not implemented)
**AWS Solution**: Provisioned concurrency (additional cost)

## 🔐 Security Quirks

### 1. API Key Exposure Risk
**Issue**: OpenAI API key in Lambda environment variables
**Current**: Secure (not exposed to frontend)
**Best Practice**: Use AWS Secrets Manager for production

### 2. CORS Configuration
**Issue**: Wildcard origins in development vs specific origins in production
**Current**: Specific origins configured
**Code Location**: `cors-config.json`

### 3. Content Security Policy
**Issue**: No CSP headers implemented
**Enhancement**: Add CSP headers to prevent XSS
**Implementation**: Add to Lambda response headers

## 🐛 Known Browser Quirks

### 1. Safari Video Handling
**Issue**: Safari requires different video codec preferences
**Solution**: Multiple source formats (not implemented)
**Recommendation**: Add WebM sources for broader compatibility

### 2. Chrome Mobile Viewport
**Issue**: Chrome mobile has different viewport behavior than Safari
**Solution**: Fixed positioning with touch-action: none

### 3. Firefox CORS Handling
**Issue**: Firefox more strict about CORS preflight requests
**Solution**: Comprehensive CORS headers in all responses

## 📱 Mobile-Specific Quirks

### 1. Touch Event Handling
**Issue**: Touch events need special handling for 3D scene interaction
**Solution**: Separate touch and mouse event handlers
**Code Location**: Three.js initialization

### 2. Orientation Change Handling
**Issue**: Viewport dimensions change on rotation
**Solution**: Window resize listeners for canvas adjustment
**Enhancement Needed**: Debounced resize handling

### 3. Mobile Safari Address Bar
**Issue**: Address bar height changes affect viewport calculations
**Solution**: Use fixed positioning instead of viewport units

## 🔧 Development Quirks

### 1. Local Development HTTPS
**Issue**: Mixed content errors in local development
**Solution**: Use browser preview tool or local HTTPS server
**Command**: Use Cascade's browser_preview tool

### 2. AWS CLI Region Configuration
**Issue**: Default region might not match resource regions
**Solution**: Always specify region in AWS CLI commands
**Pattern**: `--region us-east-2` for Lambda, `--region us-east-1` for S3

### 3. File Upload Permissions
**Issue**: S3 uploads might not have correct content-type
**Solution**: Explicit content-type headers in upload commands
```bash
aws s3 cp file.mp4 s3://bucket/file.mp4 --content-type "video/mp4"
```

## 📋 Deployment Quirks

### 1. Lambda Package Size
**Issue**: Lambda deployment packages have size limits
**Current**: ~4MB (within 50MB limit)
**Monitoring**: Check package size before deployment

### 2. S3 Eventual Consistency
**Issue**: S3 updates might not be immediately visible
**Impact**: Brief delay between upload and availability
**Mitigation**: Wait 1-2 seconds after upload before testing

### 3. ALB Health Check Requirements
**Issue**: ALB needs successful health checks to route traffic
**Solution**: Ensure `/` endpoint always returns 200
**Code Location**: `lambda_function.py` (default route handling)

This documentation captures the critical technical quirks that future developers need to understand for successful maintenance and enhancement of the Fewture homepage.
