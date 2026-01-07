<br />
<p align="center">
  <img src="icon.png" alt="Logo" width="150" height="150">

  <h1 align="center">Apple Music: Cracked Edition</h1>

  <p align="center">
    A lightweight, web-based alternative to the native Apple Music app for macOS.
  </p>
</p>

<details open="open">
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
        <li><a href="#features">Features</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#disclaimer">Disclaimer</a></li>
    <li><a href="#credits">Credits</a></li>
    <li><a href="#license">License</a></li>
  </ol>
</details>

## About The Project

**Apple Music: Cracked Edition** is a lightweight wrapper for the official Apple Music web player. It was designed to provide a faster, streamlined alternative to the heavy built-in Music app on macOS. 

This app works entirely online, giving you access to the full Apple Music library while connected to the internet, without the resource overhead of the standard desktop client.

### Features
* **Lightweight**: Minimal resource usage compared to the native app.
* **Native Feel**: Wraps `music.apple.com` in a dedicated macOS window.
* **Media Controls**: Press `Space` to Play/Pause music instantly.
* **Modern Support**: Uses a custom User Agent to ensure the full desktop interface loads correctly on Apple Silicon and Intel Macs.

### Built With
* [Swift](https://swift.org)
* [WebKit](https://developer.apple.com/documentation/webkit)
* [SwiftUI](https://developer.apple.com/swiftui/)

## Getting Started

To get up and running, download a [release]() or follow these simple steps to get a local copy.

### Installation

1.  **Clone the repo**
    ```sh
    git clone [https://github.com/apmckelvey/Apple-Music-Cracked-Edition.git](https://github.com/apmckelvey/Apple-Music-Cracked-Edition.git)
    ```
2.  **Open in Xcode**
    * Double-click `Apple Music Cracked Edition.xcodeproj`.
3.  **Configure Signing**
    * Go to the **Signing & Capabilities** tab.
    * Select your **Personal Team** (your Apple ID).
    * Ensure "App Sandbox" is enabled.
4.  **Build and Run**
    * Press `Cmd + R` to launch the app.

## Usage

Once the app is running:
1.  **Log in** with your Apple ID (safe, as it uses the official Apple web login).
2.  **Browse** your library just like on the website.
3.  **Control** playback using the on-screen buttons or the `Spacebar` shortcut.

## ⚠️ Disclaimer

**This project is NOT affiliated, associated, authorized, endorsed by, or in any way officially connected with Apple Inc., or any of its subsidiaries or its affiliates.**

The official Apple Music website can be found at [music.apple.com](https://music.apple.com). The name "Apple Music" as well as related names, marks, emblems, and images are registered trademarks of their respective owners. This application is an **unofficial** web wrapper and is provided for *educational* and *personal* use only.

## Credits

* **Icon Design**: [FuzzyIdeas/MusicDecoy](https://github.com/FuzzyIdeas/MusicDecoy) - Thank you for the visual assets!
* **Original Inspiration**: The desire for a lighter music player.

## License

Distributed under the MIT License. See `LICENSE` for more information.
