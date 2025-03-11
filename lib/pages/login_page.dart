import 'package:flutter/material.dart';
import 'signupuser_page.dart';
import 'home_screen.dart'; // Import the new Home Screen

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🚀 Welcome Message
            Text(
              "Welcome to HELP EMS",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20), // Space between title and input fields

            TextField(
              decoration: InputDecoration(labelText: "Email"),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                // Navigate to Home Screen after login
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              child: Text("Login"),
            ),
            SizedBox(height: 10),

            TextButton(
              onPressed: () {
                // Navigate to Sign-Up Page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpUserPage()),
                );
              },
              child: Text("Don't have an account? Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}
