/**
 * BookThesis Landing Page - Main JavaScript
 * Modular structure for easy maintenance and extension
 */

// ===== CONFIGURATION =====
const CONFIG = {
    debug: false,
    enableAnalytics: false, // Set to true if you want to track downloads
    animationDuration: 300
};

// ===== UTILITY FUNCTIONS =====
const Utils = {
    /**
     * Log message if debug is enabled
     */
    log: (message, data = null) => {
        if (CONFIG.debug) {
            console.log(`[BookThesis] ${message}`, data || '');
        }
    },

    /**
     * Check if user prefers reduced motion
     */
    prefersReducedMotion: () => {
        return window.matchMedia('(prefers-reduced-motion: reduce)').matches;
    }
};

// ===== DOWNLOAD TRACKING =====
const DownloadTracker = {
    /**
     * Track download events
     */
    trackDownload: (fileName, category = 'PDF') => {
        Utils.log('Download tracked', { fileName, category });

        // You can integrate with analytics here (Google Analytics, Plausible, etc.)
        if (CONFIG.enableAnalytics && typeof gtag !== 'undefined') {
            gtag('event', 'download', {
                'event_category': category,
                'event_label': fileName
            });
        }
    },

    /**
     * Initialize download tracking on all download buttons
     */
    init: () => {
        const downloadButtons = document.querySelectorAll('[download]');

        downloadButtons.forEach(button => {
            button.addEventListener('click', (e) => {
                const href = e.currentTarget.getAttribute('href');
                const fileName = href.split('/').pop();
                DownloadTracker.trackDownload(fileName);
            });
        });

        Utils.log('Download tracking initialized', {
            buttonsFound: downloadButtons.length
        });
    }
};

// ===== EXTERNAL LINKS HANDLER =====
const ExternalLinks = {
    /**
     * Add external link icon or indicator
     */
    init: () => {
        const externalLinks = document.querySelectorAll('a[target="_blank"]');

        externalLinks.forEach(link => {
            // Ensure security attributes are present
            if (!link.hasAttribute('rel')) {
                link.setAttribute('rel', 'noopener noreferrer');
            }
        });

        Utils.log('External links processed', {
            linksFound: externalLinks.length
        });
    }
};

// ===== ACCESSIBILITY ENHANCEMENTS =====
const A11y = {
    /**
     * Enhance keyboard navigation
     */
    enhanceKeyboardNav: () => {
        const buttons = document.querySelectorAll('.btn');

        buttons.forEach(button => {
            button.addEventListener('keydown', (e) => {
                // Allow Enter and Space to trigger button clicks
                if (e.key === 'Enter' || e.key === ' ') {
                    e.preventDefault();
                    button.click();
                }
            });
        });

        Utils.log('Keyboard navigation enhanced');
    },

    /**
     * Add focus visible indicators
     */
    init: () => {
        A11y.enhanceKeyboardNav();
    }
};

// ===== ANIMATIONS =====
const Animations = {
    /**
     * Add fade-in animation to main content
     */
    fadeInContent: () => {
        if (Utils.prefersReducedMotion()) {
            Utils.log('Animations disabled - user prefers reduced motion');
            return;
        }

        const container = document.querySelector('.container');
        if (container) {
            container.style.opacity = '0';
            container.style.transform = 'translateY(20px)';
            container.style.transition = `opacity ${CONFIG.animationDuration}ms ease, transform ${CONFIG.animationDuration}ms ease`;

            // Trigger animation on next frame
            requestAnimationFrame(() => {
                requestAnimationFrame(() => {
                    container.style.opacity = '1';
                    container.style.transform = 'translateY(0)';
                });
            });
        }

        Utils.log('Fade-in animation applied');
    },

    init: () => {
        Animations.fadeInContent();
    }
};

// ===== THEME DETECTION =====
const Theme = {
    /**
     * Detect and log current theme preference
     */
    detectTheme: () => {
        const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
        Utils.log('Theme detected', { isDark: prefersDark });
        return prefersDark ? 'dark' : 'light';
    },

    /**
     * Listen for theme changes
     */
    watchThemeChanges: () => {
        const darkModeQuery = window.matchMedia('(prefers-color-scheme: dark)');

        darkModeQuery.addEventListener('change', (e) => {
            Utils.log('Theme changed', { isDark: e.matches });
        });
    },

    init: () => {
        Theme.detectTheme();
        Theme.watchThemeChanges();
    }
};

// ===== APP INITIALIZATION =====
const App = {
    /**
     * Initialize all modules
     */
    init: () => {
        Utils.log('Initializing BookThesis Landing Page');

        // Initialize modules
        DownloadTracker.init();
        ExternalLinks.init();
        A11y.init();
        Animations.init();
        Theme.init();

        Utils.log('Initialization complete');
    }
};

// ===== AUTO-INITIALIZATION =====
// Wait for DOM to be ready
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', App.init);
} else {
    // DOM is already ready
    App.init();
}

// Export for potential external use
if (typeof module !== 'undefined' && module.exports) {
    module.exports = {
        App,
        Utils,
        DownloadTracker,
        ExternalLinks,
        A11y,
        Animations,
        Theme,
        CONFIG
    };
}
