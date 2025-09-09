# Site Functionality Overview

## Core Features

### 3D Interactive Experience
- **Three.js Scene**: Dynamic 3D environment with particle systems
- **Model Loading**: GLTF model support with external asset loading
- **Camera Controls**: Smooth zoom animations and responsive positioning
- **Visual Effects**: Post-processing, fog systems, and particle animations
- **Responsive Design**: Viewport-aware label positioning and mobile optimization

### Navigation System
- **Header Navigation**: Home, About, Team, Projects (dropdown), Partners
- **Projects Dropdown**: IRL, Willie, Fund, MAL with theme switching
- **Footer Navigation**: Terms, Privacy, Careers, Contact
- **Dynamic Routing**: Section-based navigation with state management

### Theme System
- **5 Theme Modes**:
  - Default: Light theme with standard colors
  - IRL (Dark): Dark mode with blue accents
  - Fund (Green): Green theme for fund content
  - Willie (Red): Red theme for Willie project
  - MAL (Purple): Purple theme for MAL project
- **Theme Cycling**: Click status button to cycle through themes
- **Dynamic Styling**: CSS variables and mode-specific styling

### Video Integration
- **Project Videos**: IRL, Fund, Willie with custom thumbnails
- **Video Overlays**: Full-screen video players with chat integration
- **Dynamic Loading**: Video source switching with proper cleanup
- **Mobile Responsive**: Optimized video sizing for all devices

### Page Content System
- **Dynamic Content**: Terms, Privacy, Careers, Contact, About, Team, Partners
- **Overlay System**: Full-screen content overlays with blur effects
- **Content Generation**: JavaScript-based content rendering
- **Close Functionality**: Dynamic close button positioning

### AI Chatbot
- **GPT-3.5 Integration**: Contextual responses about Fewture
- **Knowledge Base**: Studios, Fund, IRL information
- **Message History**: Persistent chat within session
- **API Integration**: AWS Lambda backend with CORS support

## User Interface Elements

### Status Indicators
- **Theme Status Button**: Shows current theme, cycles on click
- **Site Instructions**: Contextual help text
- **Close Buttons**: Dynamically positioned relative to status button

### Interactive Elements
- **Dropdown Menus**: Projects navigation with hover effects
- **Video Players**: Custom controls and thumbnail display
- **Chat Interface**: Send button, input field, message display
- **Overlay System**: Background blur and content focus

### Responsive Design
- **Mobile Optimization**: Touch-friendly navigation and sizing
- **Tablet Support**: Medium screen adaptations
- **Desktop Enhancement**: Full feature set with optimal spacing
- **Dynamic Positioning**: Element positioning based on viewport

## Technical Capabilities

### Frontend Functions
- `init()`: Initialize 3D scene and components
- `switchToSection()`: Navigate between page sections
- `showPageContent()`: Display page content overlays
- `showIRLVideo()`, `showFundVideo()`, `showWillieVideo()`: Video display
- `switchMode()`: Theme switching functionality
- `cycleTheme()`: Theme cycling with status updates
- `closeAllOverlays()`: Universal overlay cleanup
- `updateCloseButtonPosition()`: Dynamic button positioning

### Content Management
- **Dynamic Generation**: Page content created via JavaScript
- **Asset Loading**: Images, videos, and 3D models
- **State Persistence**: Theme and navigation state within session
- **Error Handling**: Graceful fallbacks for missing assets

### Performance Features
- **Lazy Loading**: Content loaded on demand
- **Asset Optimization**: Compressed images and efficient loading
- **Smooth Animations**: CSS transitions and Three.js animations
- **Memory Management**: Proper cleanup of 3D resources

## Limitations

### Current Constraints
- **Single Page Application**: No server-side routing
- **Session-based**: No persistent user data storage
- **Static Content**: Page content is hardcoded in JavaScript
- **Limited Chat History**: Chat resets on page refresh
- **Asset Dependencies**: Requires external video and image files

### Browser Requirements
- **WebGL Support**: Required for 3D rendering
- **Modern JavaScript**: ES6+ features used throughout
- **CSS3 Support**: Advanced styling features required
- **Responsive Viewport**: Mobile viewport meta tag required
