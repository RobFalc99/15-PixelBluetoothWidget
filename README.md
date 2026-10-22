# Pixel Bluetooth Widget Studio

[![Build and Release](https://github.com/robfalc/PixelBluetoothWidget/actions/workflows/build_and_release.yml/badge.svg)](https://github.com/robfalc/PixelBluetoothWidget/actions/workflows/build_and_release.yml)
![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=flat&logo=Flutter&logoColor=white)
![Android](https://img.shields.io/badge/Android-3DDC84?style=flat&logo=android&logoColor=white)
![License](https://img.shields.io/badge/license-MIT-blue.svg)

## 1. Overview & User Problem
On modern Google Pixel devices, the "Internet" and "Bluetooth" tiles in the Quick Settings panel often require multiple taps and sub-menus to toggle specific connections. This multi-step process disrupts the user flow for those who frequently switch between Bluetooth devices or need instant connectivity.

**Pixel Bluetooth Widget Studio** solves this by providing a **1-tap instant toggle** directly from the home screen. It eliminates the friction of navigating system menus, bringing the convenience of legacy Android toggles back to the modern Pixel experience.

## 2. Pixel Aesthetic
The application and its widgets are designed with a strict adherence to the **Pixel / Material You** design language:
- **Monochrome Grayscale Palette:** Focuses on legibility and system integration without distracting colors.
- **High Contrast UI:** Ensures visibility under various lighting conditions.
- **No Flashy Colors:** Avoids the "bloated" look of third-party utilities, making the widget feel like a native part of the OS.

## 3. In-App Widget Creator
The studio includes a powerful live editor to customize your connectivity tools:
- **Live Interactive Preview:** See changes in real-time before placing the widget.
- **Configurable Grid:** Support for various layouts (1x1, 2x1, etc.) to fit any home screen setup.
- **Background Shades:** 
    - **OLED Pure Black:** Perfect for battery saving and dark themes.
    - **Charcoal & Surface:** Matches the native Android Quick Settings background.
- **Advanced Customization:** Adjust opacity, corner radius, and icon sizes to match your custom launcher or grid density.
- **Presets:** Quick-start templates for immediate deployment.

## 4. ISO 9241 Usability & Ergonomics Compliance
Design choices are backed by international standards for human-computer interaction:
- **ISO 9241-11 (Effectiveness & Efficiency):** Optimized for the minimum number of actions to achieve the primary goal (Bluetooth toggling).
- **ISO 9241-210 (Human-Centered Design):** Iterative design focused on the end-user's tactile experience.
- **Touch Targets:** All interactive elements maintain a minimum size of **48dp** to prevent accidental misses.
- **Contrast Ratios:** Compliant with **WCAG AAA** (>7:1) for critical text and **WCAG AA** (>4.5:1) for UI elements, ensuring accessibility for all users.

## 5. Android Home Screen Widget Architecture
The widget is built using a robust bridge between Flutter and Native Android:
- **RemoteViews:** Efficiently renders the UI in the home screen process.
- **AppWidgetProvider:** Manages the widget lifecycle and updates.
- **SharedPreferences Bridge:** Synchronizes configuration data between the Flutter-based Studio and the Native Widget.
- **PendingIntent:** Ensures ultra-low latency for 1-click toggles by executing actions directly via the Android system services.

## 6. CI/CD GitHub Actions
The project maintains a high-quality delivery pipeline:
- **Automated Builds:** Every push to the `master` branch triggers a Flutter build.
- **APK Release Pipeline:** Automatically generates and signs production-ready APKs.
- **Version Management:** Seamless deployment via GitHub Releases.

---
*Built with ❤️ for the Pixel Community.*
