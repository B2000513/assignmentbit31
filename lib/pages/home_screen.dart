import 'package:flutter/material.dart';
import 'bookingMainScreen.dart'; // Import your BookingMainScreen
import '../pages/user_profile_page.dart'; // Import UserProfilePage
import '../pages/login_page.dart'; // Import LoginPage
import 'admin_profile_page.dart';
import '../pages/waitlist_page.dart'; // Import Waitlist Page
import 'CheckInSelectionScreen.dart';
import 'add_show.dart'; // Import Add Show Page ✅
import '../pages/settings_page.dart'; // ✅ Import Settings Page
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // ✅ Import AppLocalizations
import '../main.dart'; // ✅ Import LocaleProvider


class HomeScreen extends StatelessWidget {

  final Function(Locale) setLocale; // ✅ Add setLocale parameter

  const HomeScreen({Key? key, required this.setLocale}) : super(key: key); // ✅ Require setLocale

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.welcomeMessage),
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
            Text(
              AppLocalizations.of(context)!.welcomeMessage,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to BookingMainScreen when button is clicked
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BookingMainScreen(setLocale: setLocale)
                  ),
                );
              },
              child: Text(AppLocalizations.of(context)!.bookShow), // ✅ Use localized text
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminProfilePage(setLocale: setLocale)),
                );
              },
              child: Text(AppLocalizations.of(context)!.adminProfile), // ✅ Use localized text
            ),
            SizedBox(height: 10), // ✅ Add some spacing
            ElevatedButton(
              onPressed: () {
                // Navigate to Add Show Page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddShowPage()),
                );
              },
              child: Text(AppLocalizations.of(context)!.addNewShow), // ✅ Use localized text
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
           DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.event, color: Colors.white, size: 50),
                SizedBox(height: 10),
                Text(
                  AppLocalizations.of(context)?.event_booking ?? "Event Booking",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),

              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(AppLocalizations.of(context)!.profile), // ✅ Use localized text
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
            title: Text(AppLocalizations.of(context)!.payment), // ✅ Use localized text
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to Payment Page
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(AppLocalizations.of(context)!.settings), // ✅ Use localized text
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage(setLocale: setLocale), // ✅ Navigate to Settings Page
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.list_alt),
            title: Text(AppLocalizations.of(context)!.ticket), // ✅ Use localized text
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
            title: Text(AppLocalizations.of(context)!.waitlist), // ✅ Use localized text
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
            title: Text(AppLocalizations.of(context)!.logout), // ✅ Use localized text
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage(setLocale: setLocale)),
              );
            },
          ),
        ],
      ),
    );
  }
}

