import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LanguageSettingsScreen extends StatefulWidget {
  const LanguageSettingsScreen({super.key});

  @override
  State<LanguageSettingsScreen> createState() => _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState extends State<LanguageSettingsScreen> {
  final _storage = const FlutterSecureStorage();
  String _selectedLang = 'en';

  final List<Map<String, String>> languages = [
    {'code': 'en', 'name': 'English', 'flag': '🇬🇧'},
    {'code': 'id', 'name': 'Bahasa Indonesia', 'flag': '🇮🇩'},
    {'code': 'zh', 'name': 'Chinese', 'flag': '🇨🇳'},
    {'code': 'ms', 'name': 'Malay', 'flag': '🇲🇾'},
  ];

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final code = await _storage.read(key: 'language_code');
    if (code != null && mounted) {
      setState(() {
        _selectedLang = code;
      });
    }
  }

  Future<void> _selectLanguage(String code) async {
    await _storage.write(key: 'language_code', value: code);
    if (!mounted) return;
    setState(() {
      _selectedLang = code;
    });
    Navigator.pop(context); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Language Settings')),
      body: ListView(
        children: languages.map((lang) {
          final isSelected = lang['code'] == _selectedLang;
          return ListTile(
            leading: Text(lang['flag']!, style: const TextStyle(fontSize: 22)),
            title: Text(lang['name']!),
            trailing: isSelected ? const Icon(Icons.check, color: Colors.amber) : null,
            onTap: () => _selectLanguage(lang['code']!),
          );
        }).toList(),
      ),
    );
  }
}
