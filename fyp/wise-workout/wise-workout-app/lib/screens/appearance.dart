import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../themes/theme_notifier.dart';

class AppearanceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final currentMode = themeNotifier.themeMode;

    return Scaffold(
      appBar: AppBar(title: Text('Appearance')),
      body: Column(
        children: [
          RadioListTile<ThemeMode>(
            value: ThemeMode.light,
            groupValue: currentMode,
            onChanged: (mode) => themeNotifier.setThemeMode(mode!),
            title: Text("Light"),
            secondary: Icon(Icons.light_mode),
          ),
          RadioListTile<ThemeMode>(
            value: ThemeMode.dark,
            groupValue: currentMode,
            onChanged: (mode) => themeNotifier.setThemeMode(mode!),
            title: Text("Dark"),
            secondary: Icon(Icons.dark_mode),
          ),
          RadioListTile<ThemeMode>(
            value: ThemeMode.system,
            groupValue: currentMode,
            onChanged: (mode) => themeNotifier.setThemeMode(mode!),
            title: Text("System Default"),
            secondary: Icon(Icons.brightness_auto),
          ),
        ],
      ),
    );
  }
}