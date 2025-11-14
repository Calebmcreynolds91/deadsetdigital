# App Store Submission Checklist

Complete this checklist before submitting your app to the App Store.

## Pre-Submission Requirements

### 1. Apple Developer Account
- [ ] Enrolled in Apple Developer Program ($99/year)
- [ ] Agreed to latest Paid Applications Agreement
- [ ] Configured tax and banking information
- [ ] Set up App Store Connect account

### 2. App Store Connect Setup
- [ ] Created app record in App Store Connect
- [ ] Configured app information (name, description, keywords)
- [ ] Selected primary category and subcategory
- [ ] Set age rating (use the questionnaire)
- [ ] Added app privacy information
- [ ] Uploaded app icon (1024x1024 PNG)
- [ ] Created screenshots for all required device sizes
- [ ] Added app preview video (optional but recommended)

### 3. App Information

#### Basic Information
- [ ] App name (max 30 characters)
- [ ] Subtitle (max 30 characters, optional)
- [ ] Bundle ID matches your Xcode project
- [ ] Version number (semantic versioning: 1.0.0)
- [ ] Copyright information

#### Description
- [ ] Compelling app description (max 4000 characters)
- [ ] What's New in This Version notes
- [ ] Keywords (max 100 characters, comma-separated)
- [ ] Support URL (publicly accessible)
- [ ] Marketing URL (optional)

### 4. App Privacy

- [ ] Completed App Privacy questionnaire in App Store Connect
- [ ] Disclosed all data collection practices
- [ ] Privacy policy URL (publicly accessible, required)
- [ ] Privacy policy linked in app (recommended)
- [ ] Updated Info.plist with accurate permission descriptions
- [ ] Removed unused permission descriptions from Info.plist

### 5. Screenshots and Media

#### Required Screenshots (all device sizes)
- [ ] 6.7" Display (iPhone 14 Pro Max, 15 Pro Max): 1290 x 2796
- [ ] 6.5" Display (iPhone 11 Pro Max, XS Max): 1242 x 2688
- [ ] 5.5" Display (iPhone 8 Plus): 1242 x 2208
- [ ] 12.9" Display (iPad Pro): 2048 x 2732
- [ ] Minimum 3-10 screenshots per device size

#### Optional Media
- [ ] App preview videos (15-30 seconds recommended)
- [ ] Promotional artwork for App Store features

### 6. Technical Requirements

#### App Icons
- [ ] App icon (1024x1024 PNG, no transparency, no alpha channel)
- [ ] All required icon sizes in Assets.xcassets (20, 29, 40, 60, 76, 83.5)
- [ ] Icons follow Apple's design guidelines

#### Build Configuration
- [ ] Deployment target set to iOS 15.0+ (or your minimum)
- [ ] All architectures supported (arm64)
- [ ] App validated in Xcode (Product → Archive → Validate)
- [ ] No compiler warnings or errors
- [ ] Code signing with Distribution certificate
- [ ] Provisioning profile for App Store distribution

#### App Size
- [ ] App binary size optimized
- [ ] Compressed app size under 4GB (hard limit)
- [ ] Consider app thinning for large apps

### 7. Testing

#### Functional Testing
- [ ] Tested on multiple iOS versions (minimum supported to latest)
- [ ] Tested on different device sizes (iPhone SE to Pro Max, iPad)
- [ ] Tested all user flows and features
- [ ] Tested in-app purchases (if applicable)
- [ ] Tested push notifications (if applicable)
- [ ] Tested deep links and universal links (if applicable)

#### Performance Testing
- [ ] App launches quickly (< 20 seconds)
- [ ] No crashes or freezes
- [ ] Smooth scrolling and animations
- [ ] Handles poor network conditions
- [ ] Memory usage is reasonable
- [ ] Battery usage is reasonable

#### UI/UX Testing
- [ ] Follows Human Interface Guidelines
- [ ] Supports both orientations (if applicable)
- [ ] Works with Dynamic Type (accessibility)
- [ ] VoiceOver compatible (accessibility)
- [ ] Dark mode support (if using iOS 13+)
- [ ] All text is readable and properly localized

### 8. Legal and Compliance

#### App Review Guidelines Compliance
- [ ] No prohibited content (violence, hate speech, etc.)
- [ ] No misleading or false information
- [ ] No copyright or trademark infringement
- [ ] Complies with local laws and regulations
- [ ] Age-appropriate content
- [ ] No manipulation of ratings or reviews

#### Privacy Compliance
- [ ] GDPR compliant (if serving EU users)
- [ ] CCPA compliant (if serving California users)
- [ ] COPPA compliant (if app is for children)
- [ ] Obtains user consent before data collection
- [ ] Provides data deletion mechanism
- [ ] Third-party SDKs are privacy-compliant

#### Additional Requirements
- [ ] Terms of Service (if required for your app)
- [ ] EULA (End User License Agreement, if needed)
- [ ] Content disclaimers (if required)

### 9. In-App Features

#### In-App Purchases (if applicable)
- [ ] Configured in App Store Connect
- [ ] Tested in sandbox environment
- [ ] Restore purchases functionality works
- [ ] Receipt validation implemented
- [ ] Clear pricing information displayed

#### Subscriptions (if applicable)
- [ ] Subscription terms clearly displayed
- [ ] Auto-renewal information shown
- [ ] Cancel subscription option visible
- [ ] Privacy policy and terms of service linked

#### Push Notifications (if applicable)
- [ ] User permission requested appropriately
- [ ] Opt-out mechanism available
- [ ] Test notifications sent successfully
- [ ] APNs certificate configured

#### Sign in with Apple (if applicable)
- [ ] Implemented if other third-party sign-in methods exist
- [ ] Properly handles user authentication

### 10. Metadata and Localization

#### Localization (if supporting multiple languages)
- [ ] App description translated
- [ ] Screenshots localized
- [ ] In-app text localized
- [ ] Keywords localized for each market

### 11. Final Build

#### Archive Creation
- [ ] Scheme set to Release (not Debug)
- [ ] Build target set to "Any iOS Device"
- [ ] Product → Clean Build Folder
- [ ] Product → Archive
- [ ] Archive validated successfully
- [ ] Archive uploaded to App Store Connect

#### Post-Upload
- [ ] Build processing completed in App Store Connect (can take 30-60 min)
- [ ] No issues reported in App Store Connect
- [ ] Build selected for submission
- [ ] Export Compliance Information completed

### 12. Submission

#### Review Information
- [ ] Contact information (name, phone, email)
- [ ] Demo account credentials (if app requires login)
- [ ] Notes for reviewer (if app needs special instructions)
- [ ] Attachment files (if needed to explain functionality)

#### Release Options
- [ ] Release type selected:
  - [ ] Manual release (after approval)
  - [ ] Automatic release (immediately after approval)
  - [ ] Scheduled release (specific date/time)

#### Final Submission
- [ ] All sections complete (green checkmarks in App Store Connect)
- [ ] Pricing and availability configured
- [ ] App Store version ready for submission
- [ ] Clicked "Submit for Review"

## Post-Submission

### Monitoring
- [ ] Check App Store Connect daily for review status
- [ ] Respond to any Metadata Rejected or Developer Rejected status
- [ ] Answer reviewer questions within 24 hours

### Common Rejection Reasons (Be Prepared)

1. **Crashes and bugs** - Test thoroughly
2. **Broken links** - Verify all URLs work
3. **Missing content** - Ensure app is fully functional
4. **Inaccurate descriptions** - Match screenshots to actual app
5. **Privacy violations** - Follow all privacy requirements
6. **Incomplete information** - Fill out all required fields
7. **Guideline violations** - Review App Store Review Guidelines

### After Approval

- [ ] Verify app appears correctly in App Store
- [ ] Test download and installation
- [ ] Monitor user reviews and ratings
- [ ] Respond to user feedback
- [ ] Track analytics and crash reports
- [ ] Plan for updates and bug fixes

## Resources

- [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [App Store Connect Help](https://help.apple.com/app-store-connect/)
- [TestFlight Documentation](https://developer.apple.com/testflight/)
- [Apple Developer Forums](https://developer.apple.com/forums/)

## Estimated Timeline

- **First-time submission**: 24-48 hours review time (average)
- **Updates**: Usually faster than initial submission
- **Expedited review**: Available in rare cases, requires justification

## Notes

- Keep this checklist updated for each version
- Document any issues encountered during submission
- Save reviewer communications for future reference
