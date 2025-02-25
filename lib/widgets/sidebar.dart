import 'package:flutter/material.dart';

class AppSidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Icon(Icons.event, color: Colors.white, size: 50),
                SizedBox(height: 10),
                Text("Event Booking", style: TextStyle(color: Colors.white, fontSize: 20)),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Profile"),
            onTap: () {
              Navigator.pop(context); // Close drawer
              // TODO: Navigate to Profile Page
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
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () {
              Navigator.pop(context);
              // TODO: Handle logout
            },
          ),
        ],
      ),
    );
  }
}
