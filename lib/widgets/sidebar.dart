import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../pages/user_profile_page.dart';
import '../pages/login_page.dart';
import '../pages/CheckInSelectionScreen.dart';
import '../pages/waitlist_page.dart';

class SidebarWidget extends StatefulWidget {
  const SidebarWidget({super.key});

  @override
  _SidebarWidgetState createState() => _SidebarWidgetState();
}

class _SidebarWidgetState extends State<SidebarWidget> {
  int? userId;
  String userName = "User Name";
  String userEmail = "Email not found";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Debug: Print all keys stored in SharedPreferences
    debugPrint("SharedPreferences Keys: ${prefs.getKeys()}");

    // Debug: Print stored user_id value
    debugPrint("Stored user_id: ${prefs.get("user_id")}");

    int? storedUserId;

    if (prefs.containsKey("user_id")) {
      try {
        dynamic userIdValue = prefs.get("user_id");

        if (userIdValue is int) {
          storedUserId = userIdValue;
        } else if (userIdValue is String) {
          storedUserId = int.tryParse(userIdValue);
        }

        if (storedUserId == null) {
          debugPrint("Error: user_id exists but has invalid format.");
        }
      } catch (e) {
        debugPrint("Error parsing user_id: $e");
        storedUserId = null;
      }
    } else {
      debugPrint("Error: user_id key does not exist in SharedPreferences.");
    }

    if (storedUserId == null) {
      setState(() => isLoading = false);
      return;
    }

    if (mounted) {
      setState(() => userId = storedUserId);
      await _fetchUserDetails(storedUserId);
    }
  }


  /// Fetch user details from API
  Future<void> _fetchUserDetails(int userId) async {
    final url = Uri.parse("http://192.168.100.22/event_management/api/get_user.php?user_id=$userId");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data["success"] == true && data["user"] != null) {
          if (mounted) {
            setState(() {
              userName = data["user"]["name"] ?? "Unknown User";
              userEmail = data["user"]["email"] ?? "No Email";
              isLoading = false;
            });
          }
        } else {
          debugPrint("API Error: User not found");
        }
      } else {
        debugPrint("API Error: Failed to fetch user data, Status Code: ${response.statusCode}");
      }
    } catch (error) {
      debugPrint("Exception: Error fetching user details: $error");
    }

    if (mounted) setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildDrawerHeader(),
            if (userId != null) ...[
              _buildSidebarItem(Icons.person, "Profile", UserProfilePage(userId: userId!)),
              _buildSidebarItem(Icons.list_alt, "Ticket", CheckInSelectionScreen(userId: userId!)),
            ],
            _buildSidebarItem(Icons.settings, "Settings", null),
            _buildSidebarItem(Icons.hourglass_bottom, "Waitlist", const WaitlistPage()),
            const Divider(),
            _buildSidebarItem(Icons.logout, "Logout", LoginPage(), isLogout: true),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return DrawerHeader(
      decoration: const BoxDecoration(color: Colors.blue),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.event, color: Colors.white, size: 50),
          const SizedBox(height: 10),
          Text(userName, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          Text(userEmail, style: const TextStyle(color: Colors.white70, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(IconData icon, String title, Widget? page, {bool isLogout = false}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        if (isLogout) {
          _logout();
        } else if (page != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => page));
        }
      },
    );
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear stored user data
    if (mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }
}
