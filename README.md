# DeadSet iOS App

A modern iOS application built with Swift and SwiftUI, ready for Xcode and App Store submission.

## Requirements

- Xcode 15.0 or later
- iOS 15.0 or later
- macOS 12.0 or later (for development)
- Apple Developer Account (for App Store submission)

## Getting Started

### Opening the Project

1. Clone this repository
2. Navigate to the project directory
3. Open `DeadSetApp/DeadSetApp.xcodeproj` in Xcode
4. Select your development team in the project settings
5. Build and run (⌘+R)

### Project Structure

```
DeadSetApp/
├── DeadSetApp.xcodeproj/       # Xcode project file
└── DeadSetApp/                 # Main application code
    ├── DeadSetAppApp.swift     # App entry point
    ├── ContentView.swift       # Main view
    ├── Info.plist              # App configuration
    ├── Assets.xcassets/        # Images and colors
    └── Preview Content/        # SwiftUI preview assets
```

## Configuration

### Bundle Identifier

The default bundle identifier is `com.deadsetdigital.DeadSetApp`. Update this in:
- Xcode project settings → General → Identity
- Or modify in `project.pbxproj` directly

### App Name

To change the app display name:
1. Open `Info.plist`
2. Modify the `CFBundleDisplayName` value
3. Or update in Xcode project settings → General → Display Name

### App Icon

Add your app icon to `DeadSetApp/Assets.xcassets/AppIcon.appiconset/`:
- Required sizes: 20x20, 29x29, 40x40, 60x60, 76x76, 83.5x83.5, 1024x1024
- All sizes should be provided in @1x, @2x, and @3x variants (where applicable)
- Use PNG format with no transparency

## Apple Developer Compliance

This project is pre-configured with App Store compliance features:

### Privacy Permissions

All standard privacy permission descriptions are included in `Info.plist`. Update the usage descriptions to match your app's actual functionality:

- Camera access
- Photo library access
- Microphone access
- Location services
- Contacts
- Calendar
- Reminders
- Motion sensors
- Health data
- Bluetooth
- Speech recognition
- Face ID

**Important:** Remove permission descriptions for features your app doesn't use.

### App Transport Security

- ATS is enabled by default
- Only HTTPS connections are allowed
- Modify `NSAppTransportSecurity` in `Info.plist` if you need to allow HTTP

### File Sharing

- File sharing is disabled by default
- Enable in `Info.plist` if your app needs to share files via iTunes

## Building for Release

### Before Submission

1. **Update Version Numbers**
   - Marketing Version: `MARKETING_VERSION` in project settings
   - Build Number: `CURRENT_PROJECT_VERSION` in project settings

2. **Add App Icons**
   - All required sizes must be present
   - No transparency or alpha channels

3. **Review Privacy Permissions**
   - Remove unused permission descriptions
   - Ensure all descriptions are accurate and user-friendly

4. **Test on Real Devices**
   - Test on multiple iOS versions
   - Test on different device sizes (iPhone, iPad)

5. **Review Privacy Policy**
   - Update `PRIVACY.md` with your actual privacy practices
   - Host privacy policy on a public URL for App Store submission

6. **Code Signing**
   - Select your development team
   - Configure provisioning profiles
   - Use App Store distribution certificate for release

### Archive and Upload

1. Select "Any iOS Device" as the build target
2. Product → Archive
3. Open Organizer (Window → Organizer)
4. Select your archive and click "Distribute App"
5. Follow the App Store Connect upload wizard

## App Store Submission Checklist

See `APP_STORE_CHECKLIST.md` for a detailed submission checklist.

## SwiftUI Features

This app uses modern SwiftUI features:
- SwiftUI App lifecycle (no AppDelegate/SceneDelegate needed)
- SwiftUI previews for rapid development
- Native iOS design patterns
- Dark mode support (automatic)
- Dynamic type support
- Accessibility features

## Development

### Adding New Views

Create new SwiftUI views in the `DeadSetApp` folder:

```swift
import SwiftUI

struct MyNewView: View {
    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    MyNewView()
}
```

### Navigation

Use SwiftUI's NavigationView and NavigationLink for navigation:

```swift
NavigationView {
    List {
        NavigationLink("Settings", destination: SettingsView())
    }
    .navigationTitle("Home")
}
```

### State Management

Use SwiftUI property wrappers for state:
- `@State` for local view state
- `@StateObject` for observable objects owned by the view
- `@ObservedObject` for observable objects passed to the view
- `@EnvironmentObject` for app-wide state

## Testing

### Running Tests

1. Product → Test (⌘+U)
2. Or use Test Navigator (⌘+6)

### Adding Tests

Create test files in a new test target (if needed):
- Unit tests for business logic
- UI tests for user interface testing

## Support

For issues or questions:
- Review Apple's [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- Check [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- Visit [Apple Developer Forums](https://developer.apple.com/forums/)

## License

Copyright © 2025 DeadSet Digital. All rights reserved.
