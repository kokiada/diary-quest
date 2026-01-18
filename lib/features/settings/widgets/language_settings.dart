import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// 言語設定画面
class LanguageSettings extends StatefulWidget {
  const LanguageSettings({super.key});

  @override
  State<LanguageSettings> createState() => _LanguageSettingsState();
}

class _LanguageSettingsState extends State<LanguageSettings> {
  String _selectedLanguage = 'ja';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('言語'),
      ),
      body: ListView(
        children: [
          RadioListTile<String>(
            value: 'ja',
            groupValue: _selectedLanguage,
            title: const Text('日本語'),
            subtitle: const Text('日本語'),
            onChanged: (value) {
              setState(() => _selectedLanguage = value!);
              // TODO: 言語変更処理
            },
            activeColor: AppColors.secondary,
          ),
          RadioListTile<String>(
            value: 'en',
            groupValue: _selectedLanguage,
            title: const Text('English'),
            subtitle: const Text('英語'),
            onChanged: (value) {
              setState(() => _selectedLanguage = value!);
              // TODO: 言語変更処理
            },
            activeColor: AppColors.secondary,
          ),
        ],
      ),
    );
  }
}
