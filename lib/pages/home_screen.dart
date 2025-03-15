import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Ensure SharedPreferences is imported
import 'bookingMainScreen.dart';
import '../pages/user_profile_page.dart';
import '../pages/login_page.dart';
import 'admin_profile_page.dart';
import '../pages/waitlist_page.dart';
import 'CheckInSelectionScreen.dart';
import 'add_show.dart';
import '../l10n/app_localizations.dart';// Import Localization
import '../widgets/sidebar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.translate("welcome")),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      drawer: const SidebarWidget(), // ✅ Updated to fetch user ID properly
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              localization.translate("welcome"),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildButton(
              context,
              localization.translate("bookShow"),
              BookingMainScreen(),
            ),
            _buildButton(
              context,
              localization.translate("adminProfile"),
              AdminProfilePage(),
            ),
            _buildButton(
              context,
              localization.translate("addNewShow"),
              AddShowPage(),
            ),
          ],
        ),
      ),
    );
  }

  // 🎯 Fetch userId from SharedPreferences
  Future<int?> _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("user_id");
  }



  // 🎯 Reusable Button Builder
  Widget _buildButton(BuildContext context, String text, Widget page) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        ),
        child: Text(text),
      ),
    );
  }

  // 🎯 Reusable ListTile
  Widget _buildListTile(BuildContext context, IconData icon, String title, Widget page, {bool isLogout = false}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        if (isLogout) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page));
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (context) => page));
        }
      },
    );
  }
}
