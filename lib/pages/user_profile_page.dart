import 'package:flutter/material.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

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
      appBar: AppBar(title: Text("User Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildTextField("Full Name", nameController, isEditing),
            const SizedBox(height: 10),
            _buildTextField("Email", emailController, isEditing),
            const SizedBox(height: 10),
            _buildTextField("Phone Number", phoneController, isEditing),
            const SizedBox(height: 20),

            // Edit Credentials Button
            Center(
              child: ElevatedButton(
                onPressed: toggleEdit,
                child: Text(isEditing ? "Save Changes" : "Edit Credentials"),
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
