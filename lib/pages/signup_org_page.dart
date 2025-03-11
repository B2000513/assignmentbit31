import 'package:flutter/material.dart';

class SignUpOrgPage extends StatelessWidget {
  const SignUpOrgPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up Organizer")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Allows content to shrink-wrap
              crossAxisAlignment: CrossAxisAlignment.start, // Align text fields to left
              children: [
                TextField(decoration: InputDecoration(labelText: "Full Name")),
                SizedBox(height: 10),
                TextField(decoration: InputDecoration(labelText: "Email")),
                SizedBox(height: 10),
                TextField(decoration: InputDecoration(labelText: "Phone Number")),
                SizedBox(height: 10),
                TextField(decoration: InputDecoration(labelText: "Organizer Name")),
                SizedBox(height: 10),
                TextField(decoration: InputDecoration(labelText: "Password"), obscureText: true),
                SizedBox(height: 10),
                TextField(decoration: InputDecoration(labelText: "Confirm Password"), obscureText: true),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle Organizer Sign Up Logic
                      Navigator.pop(context); // Return to Admin Profile
                    },
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
