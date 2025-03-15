import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class UserProfilePage extends StatefulWidget {
  final int userId;

  const UserProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  Map<String, dynamic>? user;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  /// Fetch user details from API
  Future<void> _fetchUser() async {
    final url = Uri.parse("http://192.168.1.6/event_management/api/get_user.php?user_id=${widget.userId}");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data["success"] && data["user"] != null) {
          setState(() {
            user = data["user"];
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = data["message"] ?? "User not found.";
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = "Failed to fetch user data. Please try again.";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error: $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(),
          isLoading
              ? const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()))
              : errorMessage != null
              ? Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 16)),
          )
              : _buildUserProfile(),
        ],
      ),
    );
  }

  /// Sidebar Drawer Header
  Widget _buildDrawerHeader() {
    return DrawerHeader(
      decoration: const BoxDecoration(color: Colors.blue),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.account_circle, color: Colors.white, size: 50),
          const SizedBox(height: 10),
          Text(
            user?["name"] ?? "User Name",
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            user?["email"] ?? "Email not available",
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  /// User Profile Information List
  Widget _buildUserProfile() {
    return Column(
      children: [
        _buildListTile(Icons.phone, "Phone", user?["phone"] ?? "N/A"),
        _buildListTile(Icons.person, "Role", user?["role"] ?? "Unknown"),
        _buildListTile(Icons.event, "Joined", user?["created_at"] ?? "N/A"),
      ],
    );
  }

  /// Custom ListTile for Profile Data
  Widget _buildListTile(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(value),
    );
  }
}
