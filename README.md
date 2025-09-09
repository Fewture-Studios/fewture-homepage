# Fewture Homepage

An interactive 3D website with AI-powered chatbot capabilities, built with Three.js and AWS serverless technologies.

## Features

- **3D Interactive Experience**: Built with Three.js for immersive visuals with dynamic particle systems
- **AI Chatbot**: Powered by OpenAI's GPT-3.5-turbo with contextual responses
- **Responsive Design**: Fully responsive across desktop, tablet, and mobile devices
- **Dynamic Theming**: 5 theme modes (Default, IRL/Dark, Fund/Green, Willie/Red, MAL/Purple)
- **Video Integration**: Embedded video players with custom thumbnails for each project
- **Interactive Navigation**: Dropdown menus and overlay system for seamless content browsing
- **Page Content System**: Dynamic content loading for Terms, Privacy, Careers, Contact, About, Team, and Partners
- **Serverless Backend**: AWS Lambda + API Gateway with CORS support
- **Global CDN**: CloudFront for fast content delivery

## Project Structure

```
fewture-homepage/
├── assets/           # Static assets (images, models, videos)
├── backend/          # AWS Lambda function code
├── config/           # Configuration files
├── docs/             # Documentation
├── src/              # Source code
└── styles/           # CSS styles
```

## Getting Started

### Prerequisites

- Node.js 16+
- npm or yarn
- AWS Account
- Python 3.8+ (for backend development)

### Installation

```bash
# Clone the repository
git clone https://github.com/your-username/fewture-homepage.git
cd fewture-homepage

# Install dependencies
npm install

# Start development server
npm start
```

## Deployment

See the [Deployment Guide](docs/DEPLOYMENT_GUIDE.md) for detailed instructions on deploying to AWS.

## Development

### Available Scripts

- `npm start` - Start development server
- `npm run build` - Build for production
- `npm test` - Run tests
- `npm run lint` - Lint code

## Documentation

### Core Documentation
- [Project Overview](docs/PROJECT_OVERVIEW.md) - High-level project information
- [Architecture](docs/ARCHITECTURE.md) - System design and technical details
- [Deployment Guide](docs/DEPLOYMENT_GUIDE.md) - Instructions for deploying the application
- [Enhancements](docs/ENHANCEMENTS.md) - Roadmap and future improvements

### Project Assets
- [Fund Overview](docs/FUND_OVERVIEW.md) - Details about Fewture Fund
- [Studio Styles](docs/STUDIO_STYLES.sty) - Design system and styling

### Development
- [Contributing Guide](CONTRIBUTING.md) - How to contribute to the project
- [Changelog](CHANGELOG.md) - Project history and changes

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
