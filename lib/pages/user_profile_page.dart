import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  // Sample user data
  String fullName = "John Doe";
  String email = "johndoe@example.com";
  String phone = "+1234567890";

  // Controllers for editing fields
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing user data
    nameController = TextEditingController(text: fullName);
    emailController = TextEditingController(text: email);
    phoneController = TextEditingController(text: phone);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void toggleEdit() {
    setState(() {
      if (isEditing) {
        // Save updated data
        fullName = nameController.text;
        email = emailController.text;
        phone = phoneController.text;
      }
      isEditing = !isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.user_profile)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildTextField(AppLocalizations.of(context)!.full_name, nameController, isEditing),
            const SizedBox(height: 10),
            _buildTextField(AppLocalizations.of(context)!.email, emailController, isEditing),
            const SizedBox(height: 10),
            _buildTextField(AppLocalizations.of(context)!.phone_number, phoneController, isEditing),
            const SizedBox(height: 20),

            // Edit Credentials Button
            Center(
              child: ElevatedButton(
                onPressed: toggleEdit,
                child: Text(isEditing
                    ? AppLocalizations.of(context)!.save_changes
                    : AppLocalizations.of(context)!.edit_credentials),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, bool isEditable) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      enabled: isEditable, // Allows editing only when "Edit Credentials" is clicked
    );
  }
}
