# Review Response Generator

A modern React web application for generating authentic, SEO-optimized responses to Google reviews with dark mode support.

## Features

- 🌓 **Dark Mode Toggle** - Seamlessly switch between light and dark themes
- ⭐ **Review Response Generation** - Generate 3 unique, human-sounding responses to customer reviews
- 🎨 **Modern UI** - Beautiful gradient design with smooth transitions
- 📱 **Responsive** - Works perfectly on all device sizes
- 💾 **Persistent Theme** - Your dark mode preference is saved to localStorage
- 🔄 **System Theme Detection** - Automatically uses your system's dark mode preference

## Tech Stack

- **React 18** - Modern React with hooks
- **Vite** - Lightning-fast build tool
- **Tailwind CSS** - Utility-first CSS framework with dark mode support
- **Lucide React** - Beautiful, consistent icons
- **Claude AI** - Powered by Anthropic's Claude API for generating responses

## Getting Started

### Installation

```bash
cd web
npm install
```

### Development

```bash
npm run dev
```

Open [http://localhost:5173](http://localhost:5173) in your browser.

### Build for Production

```bash
npm run build
```

### Preview Production Build

```bash
npm run preview
```

## Dark Mode Implementation

The dark mode feature includes:

- **Context API** - `DarkModeContext` manages the global dark mode state
- **localStorage** - Persists user's theme preference
- **System Preference Detection** - Automatically detects and uses system theme preference on first visit
- **Tailwind Dark Mode** - Utilizes Tailwind's `dark:` variant for styling
- **Smooth Transitions** - All color changes are animated for a polished experience

### Using Dark Mode in Components

The dark mode context can be accessed in any component:

```jsx
import { useDarkMode } from './contexts/DarkModeContext';

function MyComponent() {
  const { isDarkMode, toggleDarkMode } = useDarkMode();

  return (
    <div className="bg-white dark:bg-gray-800">
      {/* Your content */}
    </div>
  );
}
```

## Project Structure

```
web/
├── public/              # Static assets
├── src/
│   ├── components/      # React components
│   │   ├── DarkModeToggle.jsx
│   │   └── ReviewResponseGenerator.jsx
│   ├── contexts/        # React contexts
│   │   └── DarkModeContext.jsx
│   ├── App.jsx          # Main app component
│   ├── main.jsx         # Entry point
│   └── index.css        # Global styles
├── index.html           # HTML template
├── package.json         # Dependencies
├── tailwind.config.js   # Tailwind configuration
├── vite.config.js       # Vite configuration
└── postcss.config.js    # PostCSS configuration
```

## API Configuration

To use the review response generator, you'll need to configure the Anthropic API. The API endpoint is already configured in the `ReviewResponseGenerator` component.

**Note:** For production use, you should implement proper API key management and backend proxying to avoid exposing your API key in the frontend.

## Color Scheme

### Light Mode
- Background: Orange gradient (from-orange-50 via-white to-orange-50)
- Cards: White with shadows
- Text: Gray-900 for headings, Gray-600/700 for body
- Accent: Orange-500/600

### Dark Mode
- Background: Dark gradient (from-gray-900 via-gray-800 to-gray-900)
- Cards: Gray-800 with shadows
- Text: White for headings, Gray-300 for body
- Accent: Orange-500/600 (maintained for consistency)

## License

Copyright © 2025 DeadSet Digital. All rights reserved.
