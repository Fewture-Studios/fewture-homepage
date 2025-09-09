# System Architecture

## Frontend Architecture

### Core Technologies
- **Three.js**: For 3D rendering and animations
- **Vanilla JavaScript**: For application logic
- **CSS3**: For styling and animations
- **HTML5**: For structure and semantics

### Key Components
1. **3D Scene Manager**
   - Three.js scene with dynamic particle systems
   - GLTF model loading and rendering
   - Camera controls with zoom animations
   - Responsive viewport handling and label positioning
   - Post-processing effects and fog systems

2. **UI Components**
   - Dynamic navigation with dropdown menus
   - AI-powered chat interface with message history
   - Video players with custom thumbnails and overlays
   - Page content overlay system
   - Theme status indicator and cycling

3. **State Management**
   - 5-mode theme system (Default, IRL, Fund, Willie, MAL)
   - Overlay state management (video/page/none)
   - Navigation section tracking
   - Close button dynamic positioning

4. **Content Systems**
   - Dynamic page content generation (Terms, Privacy, Careers, etc.)
   - Video content switching with proper cleanup
   - Team member bio display
   - Project showcase functionality

## Backend Architecture

### AWS Services
- **Lambda**: Serverless compute for the chatbot
- **API Gateway**: REST API endpoints
- **S3**: Static file hosting
- **CloudFront**: Content delivery network
- **WAF**: Web application firewall

### Data Flow
1. Client sends message to API Gateway
2. API Gateway triggers Lambda function
3. Lambda processes request using OpenAI API
4. Response is returned to client

## Security

### Authentication
- API key validation
- Request signing
- Rate limiting

### Data Protection
- Encryption in transit (HTTPS)
- Secure storage of API keys
- Input validation and sanitization

## Performance

### Optimization Techniques
- Asset minification
- Image optimization
- Code splitting
- Lazy loading

### Caching Strategy
- Browser caching
- CDN caching
- API response caching
