import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final theme = Theme.of(context);

    // Determine current brightness correctly including system default
    final isDarkMode = settingsProvider.themeMode == ThemeMode.dark ||
        (settingsProvider.themeMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            'Appearance',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Toggle dark and light theme'),
            value: isDarkMode,
            onChanged: (value) {
              settingsProvider.setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
            },
            secondary: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
            activeColor: theme.colorScheme.primary,
          ),
          SwitchListTile(
            title: const Text('Dynamic Colors'),
            subtitle: const Text('Match UI colors with your wallpaper (Android 12+)'),
            value: settingsProvider.useDynamicColor,
            onChanged: (value) {
              settingsProvider.setUseDynamicColor(value);
            },
            secondary: const Icon(Icons.color_lens),
            activeColor: theme.colorScheme.primary,
          ),
          const Divider(),
          const SizedBox(height: 16),
          Text(
            'Notifications',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('New Email Notifications'),
            subtitle: const Text('Receive alerts for incoming emails'),
            value: true,
            onChanged: (value) {},
            secondary: const Icon(Icons.notifications),
            activeColor: theme.colorScheme.primary,
          ),
          const Divider(),
          const SizedBox(height: 16),
          Text(
            'About',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            title: const Text('App Version'),
            subtitle: const Text('1.0.0'),
            leading: const Icon(Icons.info_outline),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
