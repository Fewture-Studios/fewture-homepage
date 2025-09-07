# Fewture Homepage - Project Overview

## Project Status
- **Status**: Production
- **Last Updated**: September 2025
- **Version**: 1.0.0

## Key Features

### Interactive 3D Experience
- Three.js powered 3D rendering
- Responsive design for all devices
- Dynamic camera controls and animations
- Multiple visual themes (Default/IRL/Fund/Dark)

### AI Chatbot
- OpenAI GPT-3.5-turbo integration
- Context-aware responses
- Theme switching via chat commands
- VHS terminal-style interface

### Technical Highlights
- **Frontend**: Vanilla JavaScript, Three.js, CSS3
- **Backend**: AWS Lambda (Python)
- **Infrastructure**: Serverless architecture
- **Deployment**: CI/CD with AWS Amplify

## Architecture

### System Components
1. **Frontend**
   - Static assets served via CloudFront
   - Responsive design with CSS Grid/Flexbox
   - Interactive 3D elements with Three.js

2. **Backend**
   - AWS Lambda for serverless compute
   - API Gateway for REST API endpoints
   - Environment-based configuration

3. **Data Flow**
   - Client → API Gateway → Lambda → OpenAI API
   - Response caching at CDN level

## Getting Help

For support, please contact [support@fewture.co](mailto:support@fewture.co)

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for contribution guidelines.
