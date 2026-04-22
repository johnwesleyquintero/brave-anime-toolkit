# Brave Anime Toolkit - PowerShell Installation Script
# This script automates the installation process for the Brave Anime Toolkit.
# It creates a dedicated Brave profile, imports preferences, and sets up the userscript.

Function Set-BravePreference {
    param (
        [string]$PrefPath,
        [string]$ProfileName,
        [string]$PrefKey,
        $PrefValue
    )

    $BraveUserDataPath = "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data"
    $ProfilePath = Join-Path $BraveUserDataPath $ProfileName
    $PreferencesFilePath = Join-Path $ProfilePath "Preferences"

    if (-not (Test-Path $PreferencesFilePath)) {
        Write-Warning "Preferences file not found for profile 	'$ProfileName	'. Ensure the profile exists and Brave has been launched at least once."
        return
    }

    $content = Get-Content $PreferencesFilePath | Out-String | ConvertFrom-Json
    $content.$PrefKey = $PrefValue

    $content | ConvertTo-Json -Depth 100 | Set-Content $PreferencesFilePath -Force
    Write-Host "Set preference 	'$PrefKey	' to 	'$PrefValue	' for profile 	'$ProfileName	'."
}

# Step 1: Create Dedicated Profile (Manual Step with Guidance)
Write-Host "`nStep 1: Create Dedicated Profile (Manual Step)`n"
Write-Host "Please ensure Brave is closed before proceeding."
Write-Host "1. Open Brave and go to brave://settings/manageProfile"
Write-Host "2. Click 'Add Profile' -> Name: 'Anime' -> Icon: 🎌"
Write-Host "3. Toggle OFF 'Sync' and 'Usage Stats' for sovereignty."
Write-Host "4. Launch the new 'Anime' profile at least once to generate its preferences file."
Read-Host "Press Enter to continue after creating the 'Anime' profile and launching it once..."

# Step 2: Import Preferences
Write-Host "`nStep 2: Importing Profile Preferences`n"
$profilePrefsJsonPath = Join-Path $PSScriptRoot "profile_prefs.json"
if (Test-Path $profilePrefsJsonPath) {
    $profilePrefs = Get-Content $profilePrefsJsonPath | Out-String | ConvertFrom-Json
    $animeProfileName = $profilePrefs.profile.name

    # Iterate through the profile preferences and set them
    $profilePrefs.profile.PSObject.Properties | ForEach-Object {
        $key = $_.Name
        $value = $_.Value
        
        # Special handling for nested objects like privacy, content_settings, site_overrides
        if ($value -is [PSCustomObject]) {
            $value.PSObject.Properties | ForEach-Object {
                $nestedKey = $_.Name
                $nestedValue = $_.Value
                Set-BravePreference -ProfileName $animeProfileName -PrefKey "$key.$nestedKey" -PrefValue $nestedValue
            }
        } else {
            Set-BravePreference -ProfileName $animeProfileName -PrefKey $key -PrefValue $value
        }
    }
    Write-Host "Profile preferences imported successfully for the '$animeProfileName' profile."
} else {
    Write-Warning "profile_prefs.json not found. Skipping profile preference import."
}

# Step 3: Install Userscript
Write-Host "`nStep 3: Installing Userscript`n"
$userscriptPath = Join-Path $PSScriptRoot "anime-brave-fix.user.js"

# Determine Brave installation path (common locations)
$braveInstallPath = "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\Application"
$braveVersionDir = Get-ChildItem -Path $braveInstallPath -Directory | Where-Object {$_.Name -match '^\d+\.\d+\.\d+\.\d+$'} | Select-Object -Last 1

if ($braveVersionDir) {
    $extensionsDir = Join-Path $braveVersionDir.FullName "resources\brave_extension\user_data\Default\Extensions"
    # This part requires more advanced interaction or Brave API to load unpacked extension programmatically
    # For now, guide the user to manually load it.
    Write-Host "
Userscript installation (manual steps):
    a. Tampermonkey (Recommended):
        1. Install Tampermonkey for Brave from the Chrome Web Store.
        2. Click the Tampermonkey extension icon -> 'Create new script'.
        3. Paste the content of '$userscriptPath' into the editor and save.

    b. Native Brave Userscripts (Developer Mode):
        1. Open Brave -> brave://extensions
        2. Enable 'Developer mode' (top right corner).
        3. Click 'Load unpacked' and select the directory containing the 'anime-brave-fix.user.js' file.
"
} else {
    Write-Warning "Could not determine Brave installation path. Please follow manual userscript installation steps."
}

Write-Host "`nInstallation script finished. Please complete any manual steps as instructed above.`n"