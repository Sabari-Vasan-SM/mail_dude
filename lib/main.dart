import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'services/notification_service.dart';

import 'themes/app_theme.dart';
import 'providers/settings_provider.dart';
import 'services/firebase_service.dart' as local_db;
import 'screens/email_list_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // Initialize Firebase Messaging
    await NotificationService().initialize();
  } catch (e) {
    print('Firebase initialization error: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider(prefs)),
        Provider(create: (_) => local_db.FirebaseService()),
      ],
      child: const MailDudeApp(),
    ),
  );
}

class MailDudeApp extends StatelessWidget {
  const MailDudeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightColorScheme;
        ColorScheme darkColorScheme;

        if (lightDynamic != null && darkDynamic != null && settingsProvider.useDynamicColor) {
          // On Android S+ devices, use the dynamic color scheme
          lightColorScheme = lightDynamic.harmonized();
          darkColorScheme = darkDynamic.harmonized();
        } else {
          // Otherwise, use fallback scheme
          lightColorScheme = ColorScheme.fromSeed(
            seedColor: AppTheme.primaryColor,
            brightness: Brightness.light,
          );
          darkColorScheme = ColorScheme.fromSeed(
            seedColor: AppTheme.primaryColor,
            brightness: Brightness.dark,
          );
        }

        return MaterialApp(
          title: 'mailDUDE',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.getLightTheme(lightColorScheme),
          darkTheme: AppTheme.getDarkTheme(darkColorScheme),
          themeMode: settingsProvider.themeMode,
          home: const EmailListScreen(),
        );
      },
    );
  }
}
