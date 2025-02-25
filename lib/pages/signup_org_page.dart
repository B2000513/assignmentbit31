import 'package:flutter/material.dart';

class SignUpOrgPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up Organizer")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
            ElevatedButton(
              onPressed: () {
                // Handle Organizer Sign Up Logic
                Navigator.pop(context); // Return to Admin Profile
              },
              child: Text("Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}
