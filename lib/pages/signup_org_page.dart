import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'login_page.dart';

class SignUpOrgPage extends StatefulWidget {
  const SignUpOrgPage({super.key});

  @override
  _SignUpOrgPageState createState() => _SignUpOrgPageState();
}

class _SignUpOrgPageState extends State<SignUpOrgPage> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController orgNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool isLoading = false;

  Future<void> registerOrganizer() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    setState(() => isLoading = true);

    final response = await http.post(
      Uri.parse("http://192.168.1.6//php/signup.php"),
      body: {
        "full_name": fullNameController.text,
        "email": emailController.text,
        "phone": phoneController.text,
        "organizer_name": orgNameController.text,
        "password": passwordController.text,
      },
    );

    final data = json.decode(response.body);

    if (data["success"] != null) {
      // Show success message & redirect to login
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Account created successfully!")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data["error"])),
      );
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up Organizer")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(controller: fullNameController, decoration: InputDecoration(labelText: "Full Name")),
                SizedBox(height: 10),
                TextField(controller: emailController, decoration: InputDecoration(labelText: "Email")),
                SizedBox(height: 10),
                TextField(controller: phoneController, decoration: InputDecoration(labelText: "Phone Number")),
                SizedBox(height: 10),
                TextField(controller: orgNameController, decoration: InputDecoration(labelText: "Organizer Name")),
                SizedBox(height: 10),
                TextField(controller: passwordController, decoration: InputDecoration(labelText: "Password"), obscureText: true),
                SizedBox(height: 10),
                TextField(controller: confirmPasswordController, decoration: InputDecoration(labelText: "Confirm Password"), obscureText: true),
                SizedBox(height: 20),
                Center(
                  child: isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                    onPressed: registerOrganizer,
                    child: Text("Sign Up"),
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
