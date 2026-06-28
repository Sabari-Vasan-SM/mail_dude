# Firebase Cloud Messaging Setup for MailDUDE

## What was done
1. **Environment Setup**: Created a `.env` file to securely store the `FIREBASE_SERVER_API_KEY` and updated `.gitignore` to prevent it from being committed.
2. **Dependencies**: Added `firebase_messaging` and `flutter_dotenv` to the project.
3. **Android Configuration**: Added the `POST_NOTIFICATIONS` permission and default notification icon/color meta-data to `AndroidManifest.xml`.
4. **Notification Service**: Created `lib/services/notification_service.dart` to handle:
   - Requesting permissions (especially for Android 13+).
   - Fetching and printing the FCM device token.
   - Subscribing the device to the `new_emails` topic.
   - Registering a top-level background message handler (`_firebaseMessagingBackgroundHandler`).
5. **Initialization**: Updated `main.dart` to load the `.env` variables and initialize the `NotificationService` immediately after Firebase initialization.
6. **Foreground Handling**: Updated `EmailListScreen` to listen to `FirebaseMessaging.onMessage` and display a `SnackBar` when a push notification arrives while the app is active.

## How to test

### Testing Foreground Notifications
1. Run the app on a physical device or emulator (must have Google Play Services).
2. Keep the app open on the `EmailListScreen`.
3. Go to the **Firebase Console** -> **Cloud Messaging** (or **Messaging** under Engage).
4. Create a new campaign (Notification message).
5. Set the Title and Text.
6. Send a test message using the FCM token printed in your debug console (`FCM Token: ...`).
7. You should see a SnackBar appear at the bottom of the app.

### Testing Background Notifications
1. Minimize the app or lock the device.
2. Send another test message from the Firebase Console.
3. You should see a standard system push notification appear in the device's notification tray.
4. Tapping the notification will bring the app to the foreground.

### Sending to Topics
Instead of a single token, you can also send a message to the Topic `new_emails` from the Firebase Console to broadcast to all installations of the app.

## How to deploy
When deploying the app:
1. Ensure the `.env` file is present in your build environment (e.g., set up as a secret in your CI/CD pipeline if you use one, like GitHub Actions).
2. Ensure you have added your **SHA-1** and **SHA-256** fingerprints to the Android app configuration in the Firebase Console.
3. For iOS, ensure you have uploaded your APNs Authentication Key to the Firebase Console under Project Settings -> Cloud Messaging.

## Troubleshooting tips
- **No notifications arriving?** Check if the device has Google Play Services installed. Emulators without Google APIs will not receive FCM messages.
- **Permissions missing?** On Android 13+, the app must ask for permission. Ensure you see the permission dialog when you first launch the app.
- **Background messages not logging?** Ensure the `_firebaseMessagingBackgroundHandler` is a top-level function (not inside a class) and has the `@pragma('vm:entry-point')` annotation.
- **Topic subscription failing?** It can take up to 24 hours for a new topic to become available in the Firebase Console drop-down, but you can manually type `new_emails` to target it immediately.
