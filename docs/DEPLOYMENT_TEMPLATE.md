# Fewture Homepage - Deployment Template & Future Site Guide

## 🚀 Quick Deployment Template

### Prerequisites Checklist
- [ ] AWS CLI configured with appropriate permissions
- [ ] Domain registered and DNS access available
- [ ] SSL certificate ready (or ACM setup)
- [ ] OpenAI API key (for chatbot functionality)

### 1. Infrastructure Setup (30 minutes)

#### AWS Resources Required
```bash
# 1. Create S3 bucket (replace with your domain)
aws s3 mb s3://your-domain-homepage-prod --region us-east-1

# 2. Enable S3 website hosting
aws s3 website s3://your-domain-homepage-prod \
  --index-document index.html \
  --error-document index.html

# 3. Create Lambda execution role
aws iam create-role \
  --role-name your-lambda-execution-role \
  --assume-role-policy-document file://trust-policy.json

# 4. Attach S3 read permissions to Lambda role
aws iam attach-role-policy \
  --role-name your-lambda-execution-role \
  --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess

# 5. Create Lambda function
aws lambda create-function \
  --function-name your-chatbot-function \
  --runtime python3.11 \
  --role arn:aws:iam::ACCOUNT:role/your-lambda-execution-role \
  --handler lambda_function.lambda_handler \
  --zip-file fileb://lambda-deployment.zip \
  --timeout 300 \
  --memory-size 512
```

#### Application Load Balancer Setup
```bash
# Create ALB (use AWS Console for easier setup)
# 1. Create ALB with HTTPS listener
# 2. Create target group pointing to Lambda function
# 3. Configure SSL certificate (ACM)
# 4. Set up listener rules for routing
```

### 2. Code Customization (60 minutes)

#### Essential File Updates
```bash
# Files requiring customization:
├── index.html                 # Update branding, content, API endpoints
├── backend/lambda_function.py # Update S3 bucket name, OpenAI prompts
├── cors-config.json          # Update allowed origins
├── assets/brain/*.md         # Update chatbot knowledge base
└── config/                   # Update deployment configurations
```

#### Brand Customization Checklist
- [ ] Replace logo files in `assets/images/logos/`
- [ ] Update color scheme in CSS variables
- [ ] Modify chatbot personality in `assets/brain/`
- [ ] Replace video content in `assets/video/`
- [ ] Update 3D models in `assets/models/`
- [ ] Customize theme names and behaviors

### 3. Content Management System

#### Video Content Pipeline
```bash
# Video optimization workflow
ffmpeg -i source-video.mov \
  -c:v libx264 -crf 23 -preset medium \
  -c:a aac -b:a 128k \
  -movflags +faststart \
  optimized-video.mp4

# Upload to S3 with proper headers
aws s3 cp optimized-video.mp4 s3://bucket/assets/video/ \
  --content-type "video/mp4" \
  --cache-control "max-age=31536000"
```

#### 3D Model Pipeline
```bash
# Model optimization (using Blender or similar)
# 1. Export as GLB format
# 2. Optimize geometry (< 50k triangles recommended)
# 3. Compress textures (1024x1024 max for web)
# 4. Test file size (< 2MB for fast loading)

# Upload optimized model
aws s3 cp scene.glb s3://bucket/assets/models/ \
  --content-type "model/gltf-binary" \
  --cache-control "max-age=31536000"
```

## 🎨 Theme System Template

### Adding New Themes
```css
/* 1. Add theme class in CSS */
.your-theme-mode body {
    background-color: #your-color;
    color: #your-text-color;
}

.your-theme-mode #logo-container img {
    animation: logoGlowYourTheme 2s ease-in-out infinite alternate;
}

@keyframes logoGlowYourTheme {
    0% { filter: your-filter-start; }
    100% { filter: your-filter-end; }
}
```

```javascript
// 2. Add theme to JavaScript switching logic
const themes = [
    'default',
    'dark',      // IRL theme
    'red',       // Willie theme  
    'green',     // Fund theme
    'your-theme' // Your new theme
];

function switchToYourTheme() {
    switchMode('your-theme');
    updateThemeIndicator('Your Theme Name');
    // Add any theme-specific logic
    showYourThemeContent();
}
```

### Project Page Template
```javascript
// Template for adding new project pages
function showYourProjectContent() {
    const overlay = document.getElementById('page-content-overlay');
    overlay.innerHTML = `
        <div class="page-content">
            <button class="close-btn" onclick="closePageContent()">×</button>
            <h1>Your Project Name</h1>
            <div class="project-details">
                <!-- Your project content here -->
            </div>
        </div>
    `;
    overlay.style.display = 'flex';
    
    // Optional: Load project-specific 3D model
    loadProjectModel('your-project');
}

function loadProjectModel(projectName) {
    const modelPath = `assets/models/${projectName}/${projectName}-scene.glb`;
    // Implement model loading logic
}
```

## 🤖 Chatbot Customization

### Knowledge Base Setup
```markdown
<!-- assets/brain/your-project-brain.md -->
# Your Project Knowledge Base

## About Your Company
Your company description, mission, values, etc.

## Projects
### Project 1
Description, features, technology stack, etc.

### Project 2  
Description, features, technology stack, etc.

## Team
Team member information, roles, backgrounds, etc.

## Contact
Contact information, social media, etc.
```

### Chatbot Personality Configuration
```python
# In lambda_function.py, update the system prompt
SYSTEM_PROMPT = """
You are an AI assistant for [Your Company Name]. You are knowledgeable about:

1. [Your Company] - [Brief description]
2. [Project 1] - [Brief description]  
3. [Project 2] - [Brief description]
4. [Your team and expertise]

Personality: [Professional/Casual/Technical - choose your tone]
Response style: [Concise/Detailed/Conversational]

Always be helpful and direct users to relevant information about our projects and team.
"""
```

## 📱 Mobile Optimization Template

### Responsive Breakpoints
```css
/* Mobile-first responsive design */
@media (max-width: 768px) {
    /* Mobile styles */
    #logo-container {
        top: 10px;
        left: 10px;
    }
    
    .status-overlay {
        font-size: 14px;
        padding: 8px 12px;
    }
}

@media (max-width: 480px) {
    /* Small mobile styles */
    .chat-container {
        bottom: 0;
        left: 0;
        right: 0;
        width: 100%;
    }
}
```

### Touch Interaction Template
```javascript
// Touch-friendly interaction patterns
const touchHandler = {
    startX: 0,
    startY: 0,
    
    handleTouchStart(e) {
        this.startX = e.touches[0].clientX;
        this.startY = e.touches[0].clientY;
    },
    
    handleTouchMove(e) {
        if (!this.startX || !this.startY) return;
        
        const deltaX = e.touches[0].clientX - this.startX;
        const deltaY = e.touches[0].clientY - this.startY;
        
        // Implement swipe gestures
        if (Math.abs(deltaX) > Math.abs(deltaY)) {
            // Horizontal swipe
            if (deltaX > 50) this.swipeRight();
            if (deltaX < -50) this.swipeLeft();
        }
    },
    
    swipeRight() {
        // Next theme/project
        cycleTheme();
    },
    
    swipeLeft() {
        // Previous theme/project  
        cycleTheme(-1);
    }
};
```

## 🔧 Development Workflow

### Local Development Setup
```bash
# 1. Clone template repository
git clone https://github.com/your-org/fewture-homepage-template.git your-new-site
cd your-new-site

# 2. Install dependencies (if any)
# npm install  # if using build tools

# 3. Start local development server
python -m http.server 8000
# Or use Cascade's browser_preview tool

# 4. Open browser to localhost:8000
```

### Testing Checklist
- [ ] All themes switch correctly
- [ ] Videos load and play properly
- [ ] Chatbot responds appropriately
- [ ] Mobile responsiveness works
- [ ] 3D scene renders without errors
- [ ] Dropdown menus close properly
- [ ] All links and buttons functional

### Deployment Commands
```bash
# Frontend deployment
aws s3 sync . s3://your-bucket/ \
  --exclude "*.git*" \
  --exclude "node_modules/*" \
  --exclude "*.md" \
  --cache-control "max-age=3600"

# Lambda deployment  
cd backend/
zip -r ../lambda-deployment.zip .
aws lambda update-function-code \
  --function-name your-function-name \
  --zip-file fileb://lambda-deployment.zip

# CORS configuration
aws s3api put-bucket-cors \
  --bucket your-bucket \
  --cors-configuration file://cors-config.json
```

## 📊 Analytics & Monitoring Template

### Performance Monitoring
```javascript
// Add to index.html for performance tracking
const analytics = {
    trackPageLoad() {
        window.addEventListener('load', () => {
            const loadTime = performance.timing.loadEventEnd - performance.timing.navigationStart;
            this.sendMetric('page_load_time', loadTime);
        });
    },
    
    trackThemeSwitch(theme) {
        this.sendEvent('theme_switch', { theme });
    },
    
    trackVideoPlay(videoName) {
        this.sendEvent('video_play', { video: videoName });
    },
    
    trackChatMessage(messageLength) {
        this.sendEvent('chat_message', { length: messageLength });
    },
    
    sendMetric(name, value) {
        // Send to your analytics service
        console.log(`Metric: ${name} = ${value}`);
    },
    
    sendEvent(name, data) {
        // Send to your analytics service
        console.log(`Event: ${name}`, data);
    }
};
```

### Error Monitoring
```javascript
// Global error handling
window.addEventListener('error', (e) => {
    console.error('Global error:', e.error);
    // Send to error tracking service
});

window.addEventListener('unhandledrejection', (e) => {
    console.error('Unhandled promise rejection:', e.reason);
    // Send to error tracking service
});
```

## 🔄 Update & Maintenance Workflow

### Content Updates
```bash
# 1. Update content files
# 2. Test locally
# 3. Deploy to staging (optional)
# 4. Deploy to production with approval

# Quick content update (HTML only)
aws s3 cp index.html s3://your-bucket/index.html

# Full asset update
aws s3 sync assets/ s3://your-bucket/assets/
```

### Version Management
```bash
# Tag releases for rollback capability
git tag -a v1.0.0 -m "Initial production release"
git push origin v1.0.0

# Create deployment packages with version
zip -r deployment-v1.0.0.zip backend/
```

## 📋 Future Enhancement Notes

### Interactive Navigation Ideas
- Gesture-based theme switching
- Voice commands for accessibility
- Keyboard shortcuts for power users
- Progressive web app (PWA) features

### 3D Model Enhancement Ideas
- Project-specific 3D scenes
- Interactive 3D elements (clickable objects)
- Particle effects and animations
- VR/AR compatibility preparation

### Performance Enhancement Ideas
- Service worker for offline capability
- WebAssembly for heavy computations
- HTTP/3 and modern protocols
- Edge computing integration

This template provides a complete foundation for rapidly deploying new interactive websites based on the Fewture homepage architecture.
