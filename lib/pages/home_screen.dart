import 'package:flutter/material.dart';
import 'bookingMainScreen.dart'; // Import your BookingMainScreen
import '../pages/user_profile_page.dart'; // Import UserProfilePage
import '../pages/login_page.dart'; // Import LoginPage
import 'admin_profile_page.dart';
import '../pages/waitlist_page.dart'; // Import Waitlist Page
import 'CheckInSelectionScreen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome to HELP EMS App"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Navigate back to login when logout is clicked
              Navigator.pop(context);
            },
          ),
        ],
      ),
      drawer: _buildSidebar(context), // 🎯 Sidebar
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome to HELP EMS App",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to BookingMainScreen when button is clicked
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BookingMainScreen()),
                );
              },
              child: const Text("Book a Show"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminProfilePage()),
                );
              },
              child: Text("Admin Profile"),
            ),
          ],
        ),
      ),
    );
  }

  // 🎯 Sidebar (Drawer)
  Widget _buildSidebar(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.event, color: Colors.white, size: 50),
                SizedBox(height: 10),
                Text("Event Booking",
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Profile"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserProfilePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text("Payment"),
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to Payment Page
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to Settings Page
            },
          ),
          ListTile(
            leading: const Icon(Icons.list_alt),
            title: const Text("Ticket"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CheckInSelectionScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.hourglass_bottom), // ⏳ Waitlist Icon
            title: const Text("Waitlist"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>
                    WaitlistPage()), // Navigate to Waitlist
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

