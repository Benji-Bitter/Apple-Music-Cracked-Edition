# Sparkle Auto-Update Integration

This document explains how the Sparkle framework has been integrated into Apple Music Cracked Edition for automatic updates.

## What is Sparkle?

Sparkle is a popular open-source update framework for macOS applications. It allows your app to automatically check for updates and download/install them with user approval.

## Integration Overview

The following components have been added/modified to integrate Sparkle:

### 1. Swift Package Manager Dependency
- Sparkle v2.8.1 has been added as a Swift Package Manager dependency
- Located in: `Apple Music Cracked Edition.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved`

### 2. UpdaterController.swift
- A new class that wraps `SPUStandardUpdaterController`
- Initializes the Sparkle updater when the app launches
- Located in: `Apple Music Cracked Edition/UpdaterController.swift`

### 3. UpdaterCommands.swift
- Adds a "Check for Updates…" menu item to the app menu
- Placed after the "About" menu item (standard macOS convention)
- Located in: `Apple Music Cracked Edition/UpdaterCommands.swift`

### 4. App Configuration
- Modified `Apple_Music_Cracked_EditionApp.swift` to:
  - Initialize the UpdaterController
  - Add UpdaterCommands to the app's command menu

### 5. Info.plist Keys
The following keys have been added to the project's Info.plist (via build settings):
- `SUFeedURL`: URL to the appcast feed (currently set to GitHub releases)
- `SUPublicEDKey`: EdDSA public key for verifying update signatures
- `SUEnableAutomaticChecks`: Enables automatic update checking

## Setup Instructions

To make the auto-update feature fully functional, you need to:

### 1. Generate EdDSA Keys
Sparkle uses EdDSA (Ed25519) signatures to verify updates. Generate a key pair:

```bash
# Install Sparkle CLI tools if not already installed
# (You can find the generate_keys tool in the Sparkle repository)
./bin/generate_keys
```

This will generate:
- A **private key** - Keep this SECRET! Use it to sign your releases
- A **public key** - Include this in your Info.plist

### 2. Update the Public Key
Replace `YOUR_PUBLIC_EDDSA_KEY_HERE` in the project.pbxproj file with your actual public key:
1. Open `Apple Music Cracked Edition.xcodeproj` in Xcode
2. Select the project in the navigator
3. Go to Build Settings
4. Search for "SUPublicEDKey"
5. Replace the placeholder with your public key

### 3. Create an Appcast Feed
The appcast is an XML file that tells Sparkle about available updates. Create a file named `appcast.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<rss version="2.0" xmlns:sparkle="http://www.andymatuschak.org/xml-namespaces/sparkle" xmlns:dc="http://purl.org/dc/elements/1.1/">
  <channel>
    <title>Apple Music Cracked Edition</title>
    <link>https://github.com/DaNoob8157/Apple-Music-Cracked-Edition</link>
    <description>Updates for Apple Music Cracked Edition</description>
    <language>en</language>
    <item>
      <title>Version 3.1.0</title>
      <link>https://github.com/DaNoob8157/Apple-Music-Cracked-Edition</link>
      <sparkle:version>3.1.0</sparkle:version>
      <sparkle:shortVersionString>3.1.0</sparkle:shortVersionString>
      <description>
        <![CDATA[
          <h2>What's New</h2>
          <ul>
            <li>Added automatic update support via Sparkle</li>
            <li>Bug fixes and improvements</li>
          </ul>
        ]]>
      </description>
      <pubDate>Wed, 12 Feb 2026 00:00:00 +0000</pubDate>
      <enclosure 
        url="https://github.com/DaNoob8157/Apple-Music-Cracked-Edition/releases/download/v3.1.0/Apple-Music-Cracked-Edition.zip" 
        sparkle:version="3.1.0" 
        sparkle:shortVersionString="3.1.0"
        length="1234567" 
        type="application/octet-stream"
        sparkle:edSignature="YOUR_SIGNATURE_HERE" />
    </item>
  </channel>
</rss>
```

### 4. Sign Your Releases
When creating a release:

```bash
# Sign the .app bundle or .zip file
./bin/sign_update "Apple Music Cracked Edition.zip" -f path/to/your/private_key
```

This will output a signature that you add to the appcast's `sparkle:edSignature` attribute.

### 5. Host the Appcast
Upload `appcast.xml` to your GitHub releases or another web server at:
```
https://github.com/DaNoob8157/Apple-Music-Cracked-Edition/releases/appcast.xml
```

If using GitHub releases, you can:
1. Create a new release
2. Upload the appcast.xml as a release asset
3. Use the raw URL in your Info.plist

## Testing

To test the update mechanism:
1. Build and run the app
2. Go to the menu: **Apple Music Cracked Edition** → **Check for Updates…**
3. If there's a newer version in your appcast, Sparkle will show an update dialog

## Notes

- The app automatically checks for updates on launch (configurable)
- Users can manually check via the menu item
- Updates are downloaded and installed with user consent
- The app must be code-signed for updates to work properly
- For sandboxed apps, ensure proper entitlements are set

## Resources

- [Sparkle Project on GitHub](https://github.com/sparkle-project/Sparkle)
- [Sparkle Documentation](https://sparkle-project.org/documentation/)
- [Generating Keys](https://sparkle-project.org/documentation/signing/)
- [Creating Appcasts](https://sparkle-project.org/documentation/publishing/)

## Troubleshooting

**"Check for Updates" menu is disabled:**
- Ensure SUFeedURL is properly set
- Check that the appcast URL is accessible

**Updates not showing:**
- Verify the appcast XML is valid
- Check that the version number in the appcast is higher than the current version
- Ensure the appcast URL is correct

**Signature verification failed:**
- Double-check that the public key in Info.plist matches your private key
- Verify the signature in the appcast was generated with the correct private key
- Make sure you're signing the exact file referenced in the appcast
