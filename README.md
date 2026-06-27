# 📧 MailDUDE - Real-Time Email Manager

A beautiful, **real-time email management application** built with Flutter and Firebase. Automatically captures emails from Gmail and displays them in a stunning Material 3 UI with instant synchronization across all devices.

![Flutter](https://img.shields.io/badge/Flutter-3.22.0-blue?style=flat-square&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0-blue?style=flat-square&logo=dart)
![Firebase](https://img.shields.io/badge/Firebase-Realtime%20DB-yellow?style=flat-square&logo=firebase)
![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Windows%20%7C%20macOS-lightgrey?style=flat-square)

---

## 🌟 Features

### Core Functionality
- ✅ **Real-Time Email Sync** - Emails appear instantly via Firebase Realtime Database
- ✅ **Gmail Integration** - Automatic email capture using Relay automation
- ✅ **Cross-Platform** - Works on Android, iOS, Web, Windows, and macOS
- ✅ **Offline Support** - Local caching and sync when connection returns
- ✅ **Search & Filter** - Find emails by sender, subject, or email address
- ✅ **Material 3 Design** - Beautiful, expressive UI with smooth animations

### User Interface
- 🎨 **Material 3 Theming** - Cyan primary color with light/dark mode support
- 🎬 **Smooth Animations** - Staggered list entrance, ripple effects, transitions
- 📱 **Responsive Design** - Adapts perfectly to phone, tablet, and desktop
- 🌓 **Dark Mode** - Full dark mode support with WCAG AA contrast compliance
- ♿ **Accessibility** - WCAG 2.1 AA compliant, supports text scaling up to 200%

### Email Features
- 👤 **Sender Avatars** - Circle avatars with sender initials
- 📧 **Full Email Details** - From, subject, body, date, and timestamp
- 🔔 **Unread Indicator** - Visual distinction for unread emails
- 🔄 **Pull-to-Refresh** - Manual refresh with smooth animation
- 🗑️ **Delete/Archive** - Manage emails directly from the app
- ⭐ **Star/Favorite** - Mark important emails for quick access

### Developer Features
- 🔥 **Firebase Realtime DB** - Instant synchronization across devices
- 🏗️ **Clean Architecture** - Separation of concerns (Models, Services, Screens)
- 📦 **Provider State Management** - Simple and scalable state management
- 🧪 **Error Handling** - Graceful error handling with user-friendly messages
- 📚 **Well-Documented** - Comprehensive code comments and documentation

---

## 🚀 Getting Started

### Prerequisites
- **Flutter 3.22+** - [Install Flutter](https://flutter.dev/docs/get-started/install)
- **Dart 3.0+** - Comes with Flutter
- **Firebase Account** - [Create free account](https://firebase.google.com)
- **Gmail Account** - For receiving emails
- **Relay Account** - [Create free account](https://relay.app)

### Installation

#### 1. Clone the Repository
```bash
git clone https://github.com/yourusername/mail_dude.git
cd mail_dude
```

#### 2. Install Dependencies
```bash
flutter pub get
```

#### 3. Setup Firebase

**Option A: Automatic (Recommended)**
```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase project
flutterfire configure --project maildude-c856b

# Select platforms: Android, iOS, macOS, Web, Windows
```

**Option B: Manual**
1. Download `google-services.json` from Firebase Console
2. Place in `android/app/google-services.json`
3. Download `GoogleService-Info.plist` from Firebase Console
4. Place in `ios/Runner/GoogleService-Info.plist`

#### 4. Setup Email Automation (Relay)

1. **Create Relay Automation**:
   - Trigger: Gmail - "Email received"
   - Action 1: Add row to Google Sheets (optional, for backup)
   - Action 2: Custom HTTP Request (POST to Firebase)

2. **Firebase HTTP Request Details**:
   ```
   URL: https://your-firebase-db.firebaseio.com/emails.json
   Method: POST
   Encoding: JSON (application/json)
   
   Body:
   {
     "date": [Gmail Send date/time],
     "from": [Gmail Name],
     "fromEmail": [Gmail Email],
     "subject": [Gmail Subject],
     "body": [Gmail Body],
     "isRead": false
   }
   ```

3. **Test the automation** by sending a test email to your Gmail account

#### 5. Run the App

```bash
# Run on default device
flutter run

# Run on specific device
flutter run -d chrome      # Web
flutter run -d windows     # Windows
flutter run -d android     # Android emulator
flutter run -d ios         # iOS simulator

# Run with release build
flutter run --release
```

---

## 📁 Project Structure

```
mail_dude/
├── lib/
│   ├── main.dart                          # App entry point & Firebase init
│   ├── firebase_options.dart              # Auto-generated Firebase config
│   │
│   ├── models/
│   │   ├── email_model.dart               # Email data model
│   │   └── app_state.dart                 # Global app state
│   │
│   ├── services/
│   │   ├── firebase_service.dart          # Firebase Realtime DB operations
│   │   └── search_service.dart            # Email search logic
│   │
│   ├── screens/
│   │   ├── email_list_screen.dart         # Main email list (home)
│   │   ├── email_detail_screen.dart       # Email detail/full view
│   │   ├── search_screen.dart             # Search results
│   │   ├── settings_screen.dart           # App settings
│   │   └── compose_screen.dart            # Compose new email (optional)
│   │
│   ├── widgets/
│   │   ├── email_card.dart                # Individual email card
│   │   ├── empty_state_widget.dart        # Empty inbox state
│   │   ├── loading_skeleton_card.dart     # Loading shimmer animation
│   │   ├── custom_app_bar.dart            # Custom AppBar widget
│   │   ├── sender_info_card.dart          # Sender details card
│   │   └── animated_email_list.dart       # Animated list wrapper
│   │
│   └── themes/
│       └── app_theme.dart                 # Material 3 theme config
│
├── android/                               # Android native code
├── ios/                                   # iOS native code
├── web/                                   # Web build files
├── windows/                               # Windows native code
├── macos/                                 # macOS native code
│
├── pubspec.yaml                           # Project dependencies
├── pubspec.lock                           # Locked dependency versions
├── README.md                              # This file
├── LICENSE                                # MIT License
└── .gitignore                             # Git ignore rules
```

---

## 🔧 Configuration

### Firebase Realtime Database Rules

Set your Firebase database rules to test mode initially:

```json
{
  "rules": {
    ".read": true,
    ".write": true
  }
}
```

**For Production**, use proper authentication:

```json
{
  "rules": {
    ".read": "auth != null",
    ".write": "auth != null",
    "emails": {
      ".indexOn": ["date", "from"]
    }
  }
}
```

### Environment Variables (Optional)

Create a `.env` file in the project root:

```
FIREBASE_PROJECT_ID=maildude-c856b
FIREBASE_API_KEY=your_api_key_here
FIREBASE_AUTH_DOMAIN=maildude-c856b.firebaseapp.com
FIREBASE_DATABASE_URL=https://maildude-c856b-default-rtdb.asia-southeast1.firebasedatabase.app
```

---

## 📦 Dependencies

### Core Dependencies
```yaml
firebase_core: ^2.24.0           # Firebase initialization
firebase_database: ^10.2.0        # Realtime database
provider: ^6.0.0                  # State management
intl: ^0.19.0                     # Internationalization & date formatting
```

### UI/UX Dependencies
```yaml
google_fonts: ^6.1.0              # Material 3 fonts
shimmer: ^3.0.0                   # Loading shimmer animation
smooth_page_indicator: ^1.1.0     # Page indicator
```

### Utility Dependencies
```yaml
connectivity_plus: ^5.0.0         # Network connectivity check
```

See `pubspec.yaml` for complete list of dependencies.

---

## 🎨 Design System

### Color Palette (Material 3)
| Color | Hex | Usage |
|-------|-----|-------|
| **Primary (Cyan)** | `#00BCD4` | AppBar, main buttons, accents |
| **Secondary (Light Blue)** | `#64B5F6` | Supporting elements |
| **Tertiary (Green)** | `#81C784` | Success states, positive actions |
| **Error (Red)** | `#EF5350` | Errors, delete actions |
| **Neutral (Gray)** | `#6C757D` | Secondary text, dividers |

### Typography
- **Display Large**: 57sp, bold
- **Headline Medium**: 28sp, semibold
- **Title Large**: 22sp, semibold
- **Body Large**: 16sp, regular
- **Label Small**: 12sp, medium

### Spacing
- Standard padding: 16px
- Card elevation: 1-5dp (Material 3)
- Border radius: 12dp (cards), 28dp (buttons)

---

## 🚦 Firebase Setup Tutorial

### Step 1: Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click "Create a project"
3. Name it `maildude`
4. Skip Google Analytics (or enable if you want)

### Step 2: Enable Realtime Database
1. In Firebase Console, click "Build" → "Realtime Database"
2. Click "Create Database"
3. Choose region closest to you (e.g., `asia-south1` for India)
4. Start in **test mode**

### Step 3: Register Your App
1. Click project settings ⚙️
2. Under "Your apps", click "Add app"
3. Select platforms: Android, iOS, macOS, Web, Windows
4. Follow the setup instructions for each platform

### Step 4: Download Configurations
- Android: `google-services.json`
- iOS: `GoogleService-Info.plist`
- Web: Automatically generated in Firebase Console

---

## 🔐 Security Considerations

### Production Checklist
- [ ] Update Firebase security rules (don't use test mode in production)
- [ ] Implement user authentication (Firebase Auth)
- [ ] Add data encryption at rest
- [ ] Enable HTTPS everywhere
- [ ] Review and limit API access
- [ ] Set up backup and disaster recovery
- [ ] Enable Firebase monitoring and logging
- [ ] Add rate limiting to prevent abuse

### Privacy & Compliance
- [ ] Privacy policy on your website
- [ ] GDPR compliance (if serving EU users)
- [ ] Data retention policy
- [ ] User consent for data collection
- [ ] Secure deletion of user data

---

## 📱 Screenshots

### Email List Screen
```
Light Mode                          Dark Mode
┌─────────────────────┐            ┌─────────────────────┐
│ mailDUDE      🔍  ⚙️ │            │ mailDUDE      🔍  ⚙️ │
├─────────────────────┤            ├─────────────────────┤
│ [Search emails...]  │            │ [Search emails...]  │
├─────────────────────┤            ├─────────────────────┤
│ A Sabarivasan...   │            │ A Sabarivasan...   │
│   Senior Associate..│            │   Senior Associate..│
│   Jun 27 • 2:35 PM │            │   Jun 27 • 2:35 PM │
│                    │            │                    │
│ E Edelweiss Mutual │            │ E Edelweiss Mutual │
│   Join us for...   │            │   Join us for...   │
│   Jun 27 • 1:42 PM │            │   Jun 27 • 1:42 PM │
└─────────────────────┘            └─────────────────────┘
```

### Email Detail Screen
```
┌─────────────────────────┐
│ ← Email           [•••] │
├─────────────────────────┤
│ Senior Associate Data   │
│ Scientist opening...    │
│                         │
│ From                    │
│ SABARIVASAN S M         │
│ sabarivasan@kongu.edu  │
│ Sent: Jun 27 • 2:35 PM │
├─────────────────────────┤
│ Dear Sabarivasan,       │
│                         │
│ We are excited to...    │
│                         │
│ [↩️ Reply] [⇨ Forward]  │
└─────────────────────────┘
```

---

## 🧪 Testing

### Running Tests
```bash
# Run all unit tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/services/firebase_service_test.dart
```

### Manual Testing Checklist
- [ ] Email list loads and displays correctly
- [ ] Search filters emails by sender and subject
- [ ] Real-time updates work (send email, watch app update)
- [ ] Dark mode toggle works smoothly
- [ ] Email detail screen displays full content
- [ ] Actions (Reply, Forward, Share) work
- [ ] Pull-to-refresh updates email list
- [ ] App works offline and syncs online
- [ ] No console errors or warnings
- [ ] Performance smooth on low-end devices

---

## 🐛 Troubleshooting

### Firebase Connection Issues
```
Error: "No Firebase App '[DEFAULT]' has been created"
Solution: Run `flutterfire configure` and ensure firebase_options.dart exists
```

### Email Not Appearing
```
1. Check Relay automation is enabled
2. Verify Firebase database URL is correct
3. Check Firebase security rules allow reads/writes
4. Test Relay automation with "Test" button
5. Check email data in Firebase Console
```

### Dark Mode Not Working
```
Check: lib/themes/app_theme.dart has darkTheme configured
Solution: Ensure ThemeMode is set to system or dark in main.dart
```

### Performance Issues
```
Solutions:
- Use release build: flutter run --release
- Reduce animation durations in themes/app_theme.dart
- Implement pagination for large email lists
- Use image caching for avatars
```

---

## 🤝 Contributing

Contributions are welcome! Here's how to contribute:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Style
- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful variable names
- Add comments for complex logic
- Keep functions small and focused
- Run `dart format .` before committing

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2024 Vasan

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
```

---

## 👨‍💻 Author

**Vasan**
- GitHub: [@Sabari-Vasan-SM](https://github.com/Sabari-Vasan-SM)
- Portfolio: [vasan.app](https://vasan.app)
- LinkedIn: [Vasan](https://linkedin.com/in/vasan)
- Email: sabarivasan1239@gmail.com

---

## 🙏 Acknowledgments

- [Flutter Documentation](https://flutter.dev/docs)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Material Design 3](https://m3.material.io/)
- [Relay Email Automation](https://relay.app)
- [Provider Package](https://pub.dev/packages/provider)

---

## 📞 Support

### Need Help?
1. Check the [Troubleshooting](#-troubleshooting) section
2. Search [GitHub Issues](https://github.com/yourusername/mail_dude/issues)
3. Create a new issue with detailed description
4. Contact: sabarivasan1239@gmail.com

### Report a Bug
Please [create an issue](https://github.com/yourusername/mail_dude/issues/new) with:
- Clear description of the bug
- Steps to reproduce
- Expected vs. actual behavior
- Screenshots/logs if applicable
- Device and Flutter version info

---

## 🎯 Roadmap

### v1.0 (Current)
- ✅ Real-time email sync
- ✅ Material 3 UI
- ✅ Search functionality
- ✅ Dark mode support

### v1.1 (Planned)
- 📅 Email scheduling
- 📎 Attachment support
- 🔔 Push notifications
- ⭐ Star/favorite emails

### v2.0 (Future)
- 👥 Multiple account support
- 💬 Email conversations/threading
- 🔐 End-to-end encryption
- 🤖 AI-powered email categorization

---

## ⭐ Show Your Support

Give a ⭐ if this project helped you! It motivates me to improve and maintain it.

---

## 📚 Resources

- [Flutter Official Documentation](https://flutter.dev/docs)
- [Firebase Realtime Database Guide](https://firebase.google.com/docs/database)
- [Material Design 3 Spec](https://m3.material.io/)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Relay Automation Platform](https://relay.app)

---

## 🔗 Related Projects

- [QuickClix](https://github.com/Sabari-Vasan-SM/quickclix) - Cross-platform clipboard sharing
- [Billventory](https://github.com/Sabari-Vasan-SM/billventory) - Inventory management system

---

<div align="center">

**Made with ❤️ by Vasan**

[⬆ back to top](#-maildude---real-time-email-manager)

</div>
