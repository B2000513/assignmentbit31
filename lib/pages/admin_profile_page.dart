import 'package:flutter/material.dart';
import 'signup_org_page.dart';
import 'genrep_mainpage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../main.dart'; // ✅ Import LocaleProvider
import '../pages/settings_page.dart'; // ✅ Import Settings Page

class AdminProfilePage extends StatefulWidget {

  final Function(Locale) setLocale; // ✅ Accept setLocales

  const AdminProfilePage({Key? key, required this.setLocale}) : super(key: key); // ✅ Require setLocale

  @override
  _AdminProfilePageState createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  bool isEditing = false;
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: ""); // ✅ Initialize with empty text
    emailController = TextEditingController(text: "admin@example.com");
    phoneController = TextEditingController(text: "123456789");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ✅ Update text fields dynamically when language changes
    nameController.text = AppLocalizations.of(context)!.admin_name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.adminProfile)),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.full_name), // ✅ Correct
              enabled: isEditing,
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.email),
              enabled: isEditing,
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.phone_number),
              enabled: isEditing,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isEditing = !isEditing;
                });
              },
              child: Text(isEditing ? AppLocalizations.of(context)!.save_changes
                  : AppLocalizations.of(context)!.edit_credentials), // ✅ Localized
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpOrgPage(setLocale: widget.setLocale)), // ✅ Pass setLocale
                );
              },
              child: Text(AppLocalizations.of(context)!.sign_up_org), // ✅ Localized
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GenRepMainPage()),
                );
              },
              child: Text(AppLocalizations.of(context)!.view_report), // ✅ Localized
            ),
          ],
        ),
      ),
    );
  }
}
