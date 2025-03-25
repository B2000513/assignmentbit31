import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'signupuser_page.dart';
import 'home_screen.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  /// Login function: Sends email & password to API
  Future<void> _login() async {
    setState(() {
      isLoading = true;
      errorMessage = null; // Reset error message
    });

    final String apiUrl = "http://192.168.100.22/event_management/api/login.php"; // Replace with your actual API URL
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "email": _emailController.text.trim(),
        "password": _passwordController.text.trim(),
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (data.containsKey("success")) {
        // Extract user data
        final user = data["user"];
        int userId = user["id"];
        String userName = user["name"];
        String userRole = user["role"];

        // Store in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt("user_id", userId);
        await prefs.setString("user_name", userName);
        await prefs.setString("user_role", userRole);

        debugPrint("✅ User ID saved: $userId");

        // Navigate to HomeScreen
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen(setLocale: (Locale ) {  },)),
          );
        }
      } else {
        setState(() {
          errorMessage = data["error"] ?? "Login failed";
        });
      }
    } else {
      setState(() {
        errorMessage = "Server error. Please try again later.";
      });
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome to HELP EMS",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),

            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            SizedBox(height: 20),

            if (errorMessage != null)
              Text(
                errorMessage!,
                style: TextStyle(color: Colors.red),
              ),

            SizedBox(height: 10),

            isLoading
                ? CircularProgressIndicator() // Show loading spinner
                : ElevatedButton(
              onPressed: _login,
              child: Text("Login"),
            ),

            SizedBox(height: 10),

            TextButton(
              onPressed: () {
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
