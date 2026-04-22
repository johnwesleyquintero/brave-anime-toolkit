// ==UserScript==
// @name         Brave Anime Site Fixer
// @namespace    WesAI Systems
// @version      1.0.0
// @description  Auto-apply Brave compatibility fixes for anime streaming sites
// @author       John Wesley Quintero (WesAI)
// @license      MIT
// @match        *://aniwave.to/*
// @match        *://gogoanime*.net/*
// @match        *://animeheaven.eu/*
// @match        *://*.hidive.com/*
// @match        *://*.crunchyroll.com/*
// @grant        none
// @run-at       document-start
// ==/UserScript==

(function() {
    'use strict';

    // Neutralize Brave detection vectors
    if (navigator.brave) {
        Object.defineProperty(navigator, 'brave', {
            get: () => undefined,
            configurable: true
        });
    }

    // Patch common anti-Brave player checks
    const patchPlayer = () => {
        // Override common detection functions
        window.__braveDetected = false;
        window.isBrave = () => false;
        
        // Fix HTML5 player constraints
        const originalQuery = HTMLMediaElement.prototype.canPlayType;
        HTMLMediaElement.prototype.canPlayType = function(type) {
            if (type.includes('video/mp4') || type.includes('video/webm')) {
                return 'probably';
            }
            return originalQuery.apply(this, arguments);
        };
    };

    // Apply fixes on load + dynamic content
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', patchPlayer);
    } else {
        patchPlayer();
    }

    // Optional: Console confirmation (dev-only)
    // console.log('[WesAI] Brave Anime Fix active for:', location.hostname);
})();