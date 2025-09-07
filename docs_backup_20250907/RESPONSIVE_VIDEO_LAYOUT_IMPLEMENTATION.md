# Responsive Video Layout Implementation Strategy

## Overview
This document outlines the CSS Grid-based responsive video layout system implemented for the Fewture homepage project. This strategy should be followed for all future video interface implementations.

## Core Architecture

### 1. Single Container Approach
- Use one `video-layout-container` with CSS Grid instead of complex positioning calculations
- Eliminates duplicate elements and overlapping issues
- Proper boundary detection with `box-sizing: border-box`

### 2. CSS Grid Structure
```css
.video-layout-container {
    position: fixed;
    top: 0;
    left: 0;
    width: 100vw;
    height: 100vh;
    display: grid;
    grid-template-columns: 1fr auto;  /* Desktop: video left, chat right */
    grid-template-rows: auto 1fr auto;
    gap: 20px;
    padding: 20px;
    box-sizing: border-box;
}
```

### 3. Responsive Breakpoints
- **Desktop (1024px+)**: Chat positioned to right side of video
- **Tablet (768-1023px)**: Chat positioned below video
- **Mobile (≤767px)**: Chat at bottom, video upper-center

### 4. Auto-Sizing Video Container
```css
.video-overlay {
    width: fit-content;
    height: fit-content;
    max-width: calc(100vw - 40px);
    max-height: calc(100vh - 40px);
}
```

## Implementation Steps

### 1. HTML Structure
```html
<div id="video-layout-container" class="video-layout-container">
    <div id="video-overlay" class="video-overlay">
        <button class="close-btn">×</button>
        <video controls>
            <source src="video.mp4" type="video/mp4">
        </video>
    </div>
</div>
```

### 2. JavaScript Integration
```javascript
function showVideo() {
    const videoLayoutContainer = document.getElementById('video-layout-container');
    const chatContainer = document.getElementById('chat-container');
    
    // Show video layout container
    videoLayoutContainer.classList.add('active');
    
    // Move chat into grid layout
    videoLayoutContainer.appendChild(chatContainer);
    chatContainer.classList.add('video-content-active');
}

function closeVideo() {
    const videoLayoutContainer = document.getElementById('video-layout-container');
    const chatContainer = document.getElementById('chat-container');
    
    // Hide video layout container
    videoLayoutContainer.classList.remove('active');
    
    // Return chat to original position
    document.body.appendChild(chatContainer);
    chatContainer.classList.remove('video-content-active');
}
```

### 3. Theme Integration
Each theme mode should include corresponding 3D object styling:

```javascript
function update3DObjectStyling(mode) {
    centralObject.traverse((child) => {
        if (child.isMesh) {
            switch(mode) {
                case 'dark': // IRL
                    child.material = new THREE.MeshBasicMaterial({ 
                        color: 0xffffff, wireframe: true, opacity: 0.9 
                    });
                    break;
                case 'green': // Fund
                    child.material = new THREE.MeshBasicMaterial({ 
                        color: 0x7fb069, wireframe: true, opacity: 0.8 
                    });
                    break;
                case 'red': // Willie
                    child.material = new THREE.MeshStandardMaterial({
                        color: 0xff0000, emissive: 0x330000, opacity: 0.9
                    });
                    break;
                case 'purple': // MAL
                    child.material = new THREE.MeshStandardMaterial({
                        color: 0xb19cd9, emissive: 0x2d1b3d, opacity: 0.85
                    });
                    break;
            }
        }
    });
}
```

## Key Benefits

1. **Proper Boundary Detection**: Elements respect actual container boundaries
2. **No Overlapping**: Grid automatically handles spacing and positioning
3. **Responsive by Design**: Adapts to screen size intelligently
4. **Performance**: Single container reduces DOM complexity
5. **Maintainable**: Clear separation of concerns

## Theme States

### Current Implementation
- **Default**: Light grey background (`0xf5f5f5`), standard grey 3D object
- **IRL (Dark)**: Black background, white wireframe 3D object
- **Fund (Green)**: Sage green background, green wireframe 3D object  
- **Willie (Red)**: Dark red background, solid red 3D object with emissive effects
- **MAL (Purple)**: Pale purple background (`0x4a3c5a`), metallic purple 3D object

### Keyword Triggers
```javascript
// Theme switching keywords
const themeKeywords = {
    light: ['fewture', 'fewture co', 'fewture studios', 'normal', 'default', 'reset'],
    dark: ['irl', 'internet racing league', 'racing', 'league', 'teaser'],
    red: ['steamboat willie', 'willie', 'steamboat', 'mickey', 'disney'],
    green: ['fewture fund', 'fund', 'investment', 'portfolio', 'invest', 'capital', 'venture'],
    purple: ['mal', 'mallory', 'virtual influencer', 'influencer', 'purple', 'pomegranate']
};
```

## Future Implementation Guidelines

1. **Always use CSS Grid** for video layouts instead of complex positioning
2. **Implement responsive breakpoints** for optimal viewing on all devices
3. **Use fit-content sizing** for video containers to match actual dimensions
4. **Include smooth transitions** between states with CSS transitions
5. **Test boundary detection** on various screen sizes
6. **Maintain theme consistency** across 3D objects, backgrounds, and UI elements

This strategy eliminates common issues with video overlays and provides a robust foundation for scalable video interface implementations.
