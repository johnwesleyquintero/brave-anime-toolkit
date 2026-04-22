# 🎌 Brave Anime Toolkit — Quick Install

## Step 1: Create Dedicated Profile
1. Open Brave → `brave://settings/manageProfile`
2. Click "Add Profile" → Name: `Anime` → Icon: 🎌
3. Toggle OFF "Sync" and "Usage Stats" for sovereignty

## Step 2: Import Preferences (Optional)
1. Go to `brave://settings/importData`
2. Select "Import from JSON" → paste `profile_prefs.json` content
3. Confirm site overrides are applied

## Step 3: Install Userscript
### Option A: Tampermonkey (Recommended)
1. Install [Tampermonkey for Brave](https://chrome.google.com/webstore/detail/tampermonkey/dhdgffkkebhmkfjojejmpbldmpobfkfo)
2. Click extension → "Create new script"
3. Paste `anime-brave-fix.user.js` content → Save (Ctrl+S)

### Option B: Native Brave Userscripts
1. Go to `brave://extensions`
2. Enable "Developer mode"
3. Click "Load unpacked" → point to folder containing the .user.js file

## Step 4: Test
1. Open new "Anime" profile window
2. Visit [aniwave.to](https://aniwave.to) or [gogoanime3.net](https://gogoanime3.net)
3. Play any episode — should load without Brave warnings ✅

## Troubleshooting
- Player still blocked? → Click Shields icon → Temporarily set to "Aggressive" → Refresh
- Cookies issue? → `brave://settings/content/cookies` → Allow first-party for domain
- Clear cache: `Ctrl+Shift+Del` → "Cached images/files" only

## Uninstall
- Delete profile: `brave://settings/manageProfile` → "Remove"
- Remove userscript: Tampermonkey dashboard → Trash icon