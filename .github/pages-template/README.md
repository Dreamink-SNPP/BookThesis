# GitHub Pages Template

This directory contains the template files for the BookThesis GitHub Pages site.

## 📁 File Structure

```
.github/pages-template/
├── index.html       # Main HTML structure
├── styles.css       # Modular CSS with mobile-first design
├── main.js          # JavaScript modules for interactions
└── README.md        # This file
```

## 🎨 Design Principles

### Mobile-First Responsive Design
The site is built with a **mobile-first** approach:
- Base styles target mobile devices (320px+)
- Progressive enhancement for tablets (600px+) and desktop (768px+)
- Buttons stack vertically on mobile, arrange horizontally on desktop
- Responsive typography and spacing

### Modular Architecture
Each file is organized in a modular way:
- **HTML**: Semantic structure with proper ARIA labels
- **CSS**: Organized by components with clear sections
- **JavaScript**: Module-based structure for easy extension

## 🔘 Buttons

The page includes three main action buttons:

1. **Descargar Libro** (Primary - Blue)
   - Downloads the complete book PDF (`Libro.pdf`)

2. **Guía de Estilo** (Secondary - Red)
   - Downloads the style guide PDF (`STYLE_GUIDE_DOC.pdf`)
   - Red color emphasizes the importance of style guidelines

3. **Ver en GitHub** (GitHub - Gray)
   - Links to the repository

## 🎨 CSS Variables

All colors, spacing, and typography are controlled via CSS custom properties (variables) in `:root`. This makes theming easy:

```css
--accent-primary: #3b82f6;      /* Blue for main download */
--accent-secondary: #ef4444;    /* Red for style guide (importance) */
--accent-tertiary: #10b981;     /* Emerald for badge */
```

## ♿ Accessibility Features

- Semantic HTML5 elements
- ARIA labels on all interactive elements
- Skip-to-content link for keyboard navigation
- Focus indicators on all interactive elements
- Support for `prefers-reduced-motion`
- Support for `prefers-contrast: high`
- Support for `prefers-color-scheme`

## 📱 Responsive Breakpoints

| Breakpoint | Width | Layout Changes |
|------------|-------|----------------|
| Mobile | < 600px | Stacked buttons, smaller text |
| Tablet | 600px - 767px | Larger padding, same stack |
| Desktop | 768px+ | Horizontal button layout |
| Large Desktop | 1024px+ | Enhanced hover effects |

## 🔧 JavaScript Modules

The `main.js` file contains several independent modules:

- **DownloadTracker**: Track PDF downloads
- **ExternalLinks**: Handle external link security
- **A11y**: Accessibility enhancements
- **Animations**: Subtle fade-in effects
- **Theme**: Dark/light theme detection
- **Utils**: Helper functions

### Enabling Analytics

To enable download tracking, edit `main.js`:

```javascript
const CONFIG = {
    enableAnalytics: true  // Change to true
};
```

Then add your analytics script (Google Analytics, Plausible, etc.) to `index.html`.

## 🎨 Customization

### Changing Colors

Edit the CSS variables in `styles.css`:

```css
:root {
    --accent-primary: #your-color;
    --accent-secondary: #your-color;
    /* ... etc */
}
```

### Adding New Buttons

1. Add button HTML in `index.html` inside `.button-group`
2. Use existing button classes: `btn btn-primary`, `btn btn-secondary`, or `btn btn-github`
3. Or create a new variant in `styles.css`

Example:
```html
<a href="your-file.pdf" class="btn btn-primary">
    <span class="btn-icon">📄</span>
    <span class="btn-text">
        <span class="btn-title">Your Title</span>
        <span class="btn-subtitle">Your subtitle</span>
    </span>
</a>
```

### Dark/Light Mode

The site automatically respects the user's system preference (`prefers-color-scheme`). Styles for both modes are defined in `styles.css` at the bottom.

## 🚀 Deployment

These files are automatically deployed to GitHub Pages by the CI/CD workflow. The workflow:

1. Copies these template files to the deployment directory
2. Adds the generated PDFs (`Libro.pdf`, `STYLE_GUIDE_DOC.pdf`)
3. Deploys to GitHub Pages

## 📝 Maintenance

- HTML, CSS, and JavaScript are separated for easy maintenance
- All interactive elements are well-documented
- CSS uses a clear naming convention (BEM-inspired)
- JavaScript modules can be enabled/disabled independently

## 🌐 Browser Support

- Modern browsers (Chrome, Firefox, Safari, Edge)
- Mobile browsers (iOS Safari, Chrome Mobile)
- Graceful degradation for older browsers

## 📄 License

Same license as the main project (CC BY 4.0).
