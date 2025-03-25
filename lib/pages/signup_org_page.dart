import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../main.dart'; // ✅ Import LocaleProvider
import '../pages/settings_page.dart'; // ✅ Import Settings Page

class SignUpOrgPage extends StatelessWidget {

  final Function(Locale) setLocale; // ✅ Accept setLocales

  const SignUpOrgPage({Key? key, required this.setLocale}) : super(key: key); // ✅ Require setLocale

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.sign_up_org)), // ✅ Use localized text
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Allows content to shrink-wrap
              crossAxisAlignment: CrossAxisAlignment.start, // Align text fields to left
              children: [
                TextField(decoration: InputDecoration(labelText: AppLocalizations.of(context)!.full_name)), // ✅ Localized text
                SizedBox(height: 10),
                TextField(decoration: InputDecoration(labelText: AppLocalizations.of(context)!.email)), // ✅ Localized text,
                SizedBox(height: 10),
                TextField(decoration: InputDecoration(labelText: AppLocalizations.of(context)!.phone_number)), // ✅ Localized text
                SizedBox(height: 10),
                TextField(decoration: InputDecoration(labelText: AppLocalizations.of(context)!.org_name)),
                SizedBox(height: 10),
                TextField(decoration: InputDecoration(labelText: AppLocalizations.of(context)!.password), obscureText: true),
                SizedBox(height: 10),
                TextField(decoration: InputDecoration(labelText: AppLocalizations.of(context)!.confirm_pass), obscureText: true),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle Organizer Sign Up Logic
                      Navigator.pop(context); // Return to Admin Profile
                    },
                    child: Text(AppLocalizations.of(context)!.sign_up), // ✅ Localized button text
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
