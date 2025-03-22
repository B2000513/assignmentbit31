import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'signup_org_page.dart';
import 'genrep_mainpage.dart';

class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({super.key});

  @override
  _AdminProfilePageState createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  bool isEditing = false;
  bool isLoading = false;
  int? userId;  // User ID as int

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> saveUserId(int userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("user_id", userId); // Store as int
    print("✅ User ID Saved: $userId");
  }

  Future<void> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? storedUserId = prefs.getInt("user_id");  // Retrieve as int

    if (storedUserId == null) {
      print("⚠️ User ID is null!");
    } else {
      print("✅ User ID Retrieved: $storedUserId");
    }
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? storedUserId = prefs.getInt("user_id"); // Retrieve as int

    if (storedUserId != null) {
      setState(() {
        userId = storedUserId;
      });
      fetchUserDetails(userId!);
    } else {
      print("⚠️ No User ID Found!");
    }
  }

  Future<void> fetchUserDetails(int userId) async {
    final url = Uri.parse("http://192.168.1.6/event_management/api/get_user.php?user_id=$userId");

    try {
      final response = await http.get(url);
      print("📢 Full API Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["user"] != null) {
          setState(() {
            nameController.text = data["user"]["name"] ?? "Unknown";
            emailController.text = data["user"]["email"] ?? "Unknown";
            phoneController.text = data["user"]["phone"] ?? "Unknown";
          });
        } else {
          print("⚠️ No user data found in API response");
        }
      } else {
        print("❌ API Error: Status Code ${response.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to fetch user details")));
      }
    } catch (e) {
      print("🚨 Error Fetching User Data: $e");
    }
  }

  Future<void> updateUserDetails() async {
    if (userId == null) return;

    setState(() => isLoading = true);
    final url = Uri.parse("http://192.168.1.6/event_management/api/edit_user.php");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_id": userId,
          "name": nameController.text,
          "email": emailController.text,
          "phone": phoneController.text,
          "role": "organizer"
        }),
      );

      setState(() => isLoading = false);
      print("📢 Full Update Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["success"] == true) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Profile Updated!")));
          setState(() => isEditing = false);
        } else {
          print("⚠️ Update Failed: ${data["error"]}");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data["error"] ?? "Update Failed")));
        }
      } else {
        print("❌ API Error: Status Code ${response.statusCode}");
      }
    } catch (e) {
      print("🚨 Error Updating User: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin Profile")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (userId == null)
              Center(child: CircularProgressIndicator())
            else ...[
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Full Name"),
                enabled: isEditing,
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Email"),
                enabled: isEditing,
              ),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: "Phone Number"),
                enabled: isEditing,
              ),
              SizedBox(height: 20),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: () {
                  if (isEditing) {
                    updateUserDetails();
                  } else {
                    setState(() => isEditing = true);
                  }
                },
                child: Text(isEditing ? "Save Changes" : "Edit Credentials"),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpOrgPage()));
                },
                child: Text("Sign Up Organizer"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => GenRepMainPage()));
                },
                child: Text("View Report"),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
