import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/services/theme_service.dart';
import '../widgets/settings_section.dart';
// Removed the import for settings_tile.dart as it doesn't exist
import '../core/config/app_config.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          SettingsSection(
            title: 'Appearance',
            children: [
              Consumer<ThemeService>(
                builder: (context, themeService, _) {
                  return ListTile( // Changed from SettingsTile to ListTile
                    title: const Text('Dark Mode'), // Added const for optimization
                    subtitle: const Text('Toggle dark theme'), // Added const for optimization
                    trailing: Switch(
                      value: themeService.isDarkMode,
                      onChanged: (value) => themeService.toggleTheme(),
                    ),
                  );
                },
              ),
            ],
          ),
          SettingsSection(
            title: 'About',
            children: [
              ListTile( // Changed from SettingsTile to ListTile
                title: const Text('Version'), // Added const for optimization
                subtitle: Text(AppConfig.appVersion),
              ),
              ListTile( // Changed from SettingsTile to ListTile
                title: const Text('Licenses'), // Added const for optimization
                onTap: () => showLicensePage(
                  context: context,
                  applicationName: AppConfig.appName,
                  applicationVersion: AppConfig.appVersion,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
} 