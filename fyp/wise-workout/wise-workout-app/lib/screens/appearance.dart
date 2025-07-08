import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../themes/theme_notifier.dart';

class AppearanceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final currentMode = themeNotifier.themeMode;
    final theme = Theme.of(context);

    Color _labelColor() => theme.colorScheme.onBackground.withOpacity(0.78);
    Color _descColor() => theme.textTheme.bodySmall?.color?.withOpacity(0.78) ?? _labelColor();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Appearance',
          style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.onBackground),
        ),
        elevation: 0,
        backgroundColor: theme.colorScheme.background,
        foregroundColor: theme.colorScheme.onBackground,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Theme",
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Choose your preferred app appearance.",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: _descColor(),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 2,
              color: theme.colorScheme.surface,
              child: Column(
                children: [
                  RadioListTile<ThemeMode>(
                    value: ThemeMode.light,
                    groupValue: currentMode,
                    onChanged: (mode) => themeNotifier.setThemeMode(mode!),
                    title: Text(
                      "Light",
                      style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                    ),
                    secondary: Icon(Icons.light_mode, color: theme.colorScheme.secondary),
                  ),
                  RadioListTile<ThemeMode>(
                    value: ThemeMode.dark,
                    groupValue: currentMode,
                    onChanged: (mode) => themeNotifier.setThemeMode(mode!),
                    title: Text(
                      "Dark",
                      style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                    ),
                    secondary: Icon(Icons.dark_mode, color: theme.colorScheme.primary),
                  ),
                  RadioListTile<ThemeMode>(
                    value: ThemeMode.system,
                    groupValue: currentMode,
                    onChanged: (mode) => themeNotifier.setThemeMode(mode!),
                    title: Text(
                      "System Default",
                      style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                    ),
                    secondary: Icon(Icons.brightness_auto, color: theme.colorScheme.tertiary ?? theme.colorScheme.primary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: Icon(
                currentMode == ThemeMode.dark
                    ? Icons.dark_mode
                    : currentMode == ThemeMode.light
                    ? Icons.light_mode
                    : Icons.brightness_auto,
                size: 64,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}