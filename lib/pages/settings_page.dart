import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  final Function(Locale) setLocale; // ✅ Accept setLocale function

  const SettingsPage({Key? key, required this.setLocale}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.settings)),
      body: Column(
        children: [
          ListTile(
            title: Text("English"),
            onTap: () {
              setLocale(Locale('en')); // 🌍 Change to English
              Navigator.pop(context); // Close settings page
            },
          ),
          ListTile(
            title: Text("Korean (한국어)"),
            onTap: () {
              setLocale(Locale('ko')); // 🌍 Change to Korean
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text("Bahasa Malaysia"),
            onTap: () {
              setLocale(Locale('ms')); // 🌍 Change to Bahasa Malaysia
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
