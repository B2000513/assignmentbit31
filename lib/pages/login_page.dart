import 'package:flutter/material.dart';
import 'signupuser_page.dart';
import 'home_screen.dart'; // Import Home Screen
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatelessWidget {

  final Function(Locale) setLocale; // ✅ Accept setLocales

  const LoginPage({Key? key, required this.setLocale}) : super(key: key); // ✅ Require setLocale

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.login)), // Use localized text
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🚀 Welcome Message
            Text(
              AppLocalizations.of(context)!.welcomeMessage, // Localized text
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20), // Space between title and input fields

            TextField(
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.email),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.password),
              obscureText: true,
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                // Navigate to Home Screen after login
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen(setLocale: setLocale)
                  ),
                );
              },
              child: Text(AppLocalizations.of(context)!.login), // Localized text
            ),
            const SizedBox(height: 10),

            TextButton(
              onPressed: () {
                // Navigate to Sign-Up Page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpUserPage()),
                );
              },
              child: Text(AppLocalizations.of(context)!.signupPrompt), // Localized text
            ),
          ],
        ),
      ),
    );
  }
}
