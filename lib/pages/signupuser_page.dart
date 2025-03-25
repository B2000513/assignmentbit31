import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpUserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.sign_up_user)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.full_name),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.email),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.password),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.confirm_pass),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // 🎯 Navigate back to Login Page after signing up
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.sign_up),
            ),
          ],
        ),
      ),
    );
  }
}
