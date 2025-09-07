# Fewture Homepage Project Overview

## Project Status: PRODUCTION READY 

### Live Deployment
- **Production URLs**: 
  - https://fewture.co (stealth mode - black screen)
  - https://www.fewture.co (stealth mode - black screen)
- **Test/Beta URL**: http://fewture-test-homepage-1757230511.s3-website.us-east-1.amazonaws.com
- **Backend API**: AWS Lambda + ALB integration with OpenAI GPT-3.5-turbo

### Architecture Overview
- **Frontend**: Interactive 3D homepage built with Three.js
- **Backend**: AWS Lambda serverless chatbot with OpenAI integration
- **Hosting**: S3 static hosting with ALB for API routing
- **SSL**: ACM certificates for production domains
- **CDN**: Ready for CloudFront deployment (scripts provided)

## Core Features

### 1. Interactive 3D Homepage
- **3D Model**: Custom GLB model with camera controls
- **Responsive Design**: Adapts to all screen sizes
- **Theme System**: Multiple color schemes (Default/IRL/Fund/Dark/Purple/Red)
- **Navigation**: Smooth overlay system for content sections

### 2. AI Chatbot Integration
- **Engine**: OpenAI GPT-3.5-turbo with custom system prompts
- **Knowledge Base**: Comprehensive Fewture ecosystem information
- **Actions**: Dynamic theme switching and content triggering
- **Interface**: VHS terminal-style chat with reduced visual clutter
- **Concise Responses**: 60-token limit for action-oriented replies

### 3. Content Management
- **Video Overlays**: Project teasers and demos
- **Page Overlays**: Team, About, Partners information
- **Project Sections**: IRL, Fund, Willie, MAL with themed experiences
- **Responsive Layout**: CSS Grid with mobile optimization

## Project Portfolio

### Fewture Studios
- **Description**: Cutting-edge LA-based content/tech company, Hollywood 2.0 entertainment, internet native IP development
- **Leadership**: Kai Henry (CEO), Josh Stein (President/COO), Brandon Dalton (Chief Attention Officer)
- **Focus**: Creator-focused entertainment and technology innovation

### Fewture Fund
- **Capital**: $50M early-stage investment fund
- **Portfolio**: 75 investments with $500k-1.5M check sizes
- **Allocation**: Live IP (40%), Consumer (30%), Tech (20%)
- **Theme**: Green color scheme

### IRL (Internet Racing League)
- **Concept**: Flagship live IP combining kart racing with creator culture
- **Regions**: Global expansion (LATAM/USA/EU/MENA)
- **Milestone**: 2026 Money Cup $1M at SoFi Stadium
- **Content**: Teaser video available
- **Theme**: Blue color scheme

### Willie Project
- **Title**: "The Return of Steamboat Willie"
- **Format**: Feature-length animated horror film
- **Technology**: Created entirely in Unreal Engine
- **Premise**: After 95 years locked away, Willie wants his steamboat back
- **Context**: Public domain since January 1, 2024 due to copyright expiration
- **Background**: Political discord in 2022 prevented Disney copyright extension
- **Production**: Fewture Studios horror film entry in public domain gold rush
- **Theme**: Red color scheme
- **Triggers**: "steamboat", "horror", "unreal engine" keywords

### MAL WAR[3]
- **Concept**: AI influencer with Albanian heritage
- **Focus**: Web3 fashion and "Threading Tomorrow"
- **Content**: Detailed dossier with tactical classified aesthetic
- **Layout**: Dynamic responsive grid with varied container sizes
- **Theme**: Purple color scheme
- **Triggers**: "mal", "threading tomorrow", "albania" keywords

## Technical Implementation

### Frontend Stack
- **Core**: HTML5, CSS3, JavaScript (ES6+)
- **3D Graphics**: Three.js with GLB model loading
- **Styling**: Modern CSS with Grid, Flexbox, and custom properties
- **Responsive**: Mobile-first design with clamp() and media queries
- **Animations**: CSS transitions and transforms
- **Bundle Size**: ~70KB optimized

### Backend Architecture
- **Runtime**: Python 3.11 on AWS Lambda
- **Dependencies**: requests==2.31.0 with full dependency tree
- **Integration**: ALB routing with CORS headers
- **Security**: POST-only endpoints with proper error handling
- **Retry Logic**: Built-in rate limit handling for OpenAI API
- **Response Optimization**: 60-token limit for concise, actionable replies

### Chatbot Intelligence
- **System Prompt**: Comprehensive Fewture ecosystem knowledge
- **Action Generation**: Smart theme switching and content triggering
- **Project Recognition**: Enhanced keyword detection for Willie and MAL
- **Context Awareness**: User state tracking and personalized responses
- **Topic Extraction**: Main topic identification for memory personalization

### Deployment Infrastructure
- **Production**: ALB fixed response (stealth mode)
- **Testing**: S3 static website hosting
- **SSL**: ACM certificates for both domains
- **DNS**: Proper A records and CNAME configuration
- **Monitoring**: CloudWatch logs for Lambda functions

## Development Workflow

### Local Development
1. Edit files in `/Users/r/r-code/fewture-homepage/`
2. Test changes locally with browser preview
3. Deploy to S3 test bucket for staging
4. Update Lambda function for backend changes

### Deployment Process
1. **Frontend**: `aws s3 sync` to test bucket
2. **Backend**: Package dependencies with `pip install -t .` and update Lambda
3. **Production**: Switch ALB rules when ready to go live

### Quality Assurance
- **Cross-browser**: Tested on modern browsers
- **Mobile**: Responsive design verified on various devices
- **Performance**: Optimized assets and efficient loading
- **Security**: Proper CORS and input validation
- **Chatbot Testing**: Verified Willie and MAL keyword triggers

## Recent Updates (September 2025)

### Willie Project Enhancement
- **Enhanced Knowledge**: Added comprehensive horror film backstory
- **Public Domain Context**: 95-year timeline and political background
- **Keyword Triggers**: "steamboat", "horror", "unreal engine" now trigger Willie content
- **Content Display**: Updated Willie overlay with detailed project information

### Chatbot Improvements
- **Concise Responses**: Reduced to 60-token limit for action-oriented replies
- **Enhanced System Prompt**: Updated with cutting-edge LA company description
- **Improved Actions**: Better differentiation between Willie and MAL triggers
- **Knowledge Base**: Comprehensive project details and context

### Technical Fixes
- **Lambda Deployment**: Fixed missing requests dependency issue
- **Dependency Management**: Proper packaging with full dependency tree
- **Testing**: Verified chatbot functionality with new knowledge base

## Future Enhancements

### Phase 1 (Immediate)
- CloudFront CDN deployment for global performance
- Enhanced video hosting with optimized delivery
- Advanced chatbot intelligence and context awareness

### Phase 2 (Medium-term)
- Content management system for easy updates
- PDF deck delivery system for presentations
- Enhanced VHS/80s visual effects and animations

### Phase 3 (Long-term)
- Advanced 3D interactions and model variations
- Real-time collaboration features
- Analytics and user behavior tracking

## Maintenance Notes

### Regular Tasks
- Monitor Lambda logs for errors or performance issues
- Update OpenAI API key when needed (stored in environment variables)
- Review and update project information as Fewture evolves
- Test chatbot responses for accuracy and relevance
- Verify Willie and MAL content triggers work correctly

### Emergency Procedures
- **Site Down**: Check ALB health and Lambda function status
- **Chatbot Issues**: Review CloudWatch logs and API key validity
- **DNS Problems**: Verify A records and CNAME configurations
- **SSL Expiry**: Renew ACM certificates (auto-renewal enabled)
- **Dependency Issues**: Ensure proper pip install -t . for Lambda packaging

## Contact & Support
- **Primary Developer**: Available for maintenance and enhancements
- **Documentation**: Comprehensive guides in `/docs/` directory
- **Deployment Scripts**: Automated deployment tools in `/scripts/`
- **Configuration**: Settings stored in `/config/` directory

---

**Last Updated**: September 2025  
**Status**: Production Ready with Enhanced Willie Project and Chatbot Intelligence  
**Next Review**: Quarterly or as needed for new features.
