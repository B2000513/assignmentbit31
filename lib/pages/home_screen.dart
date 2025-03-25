import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bookingMainScreen.dart';
import '../pages/user_profile_page.dart';
import '../pages/login_page.dart';
import 'admin_profile_page.dart';
import '../pages/waitlist_page.dart';
import 'CheckInSelectionScreen.dart';
import 'add_show.dart';
import '../pages/settings_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../main.dart';

class HomeScreen extends StatefulWidget {
  final Function(Locale) setLocale;

  const HomeScreen({Key? key, required this.setLocale}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userId')!;
    });
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage(setLocale: widget.setLocale)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.welcomeMessage),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      drawer: _buildSidebar(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("User ID: ${userId ?? 'Not Logged In'}"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _navigateTo(BookingMainScreen(setLocale: widget.setLocale)),
              child: Text(AppLocalizations.of(context)!.bookShow),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _navigateTo(AdminProfilePage(setLocale: widget.setLocale)),
              child: Text(AppLocalizations.of(context)!.adminProfile),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _navigateTo(AddShowPage()),
              child: Text(AppLocalizations.of(context)!.addNewShow),
            ),
          ],
        ),
      ),
    );
  }

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
                const SizedBox(height: 10),
                Text(
                  AppLocalizations.of(context)?.event_booking ?? "Event Booking",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
          ),
          _buildDrawerItem(Icons.person, AppLocalizations.of(context)!.profile, UserProfilePage(userId: userId)),
          _buildDrawerItem(Icons.payment, AppLocalizations.of(context)!.payment, null),
          _buildDrawerItem(Icons.settings, AppLocalizations.of(context)!.settings, SettingsPage(setLocale: widget.setLocale)),
          _buildDrawerItem(Icons.list_alt, AppLocalizations.of(context)!.ticket, CheckInSelectionScreen(userId: userId)),
          _buildDrawerItem(Icons.hourglass_bottom, AppLocalizations.of(context)!.waitlist, WaitlistPage()),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(AppLocalizations.of(context)!.logout),
            onTap: _logout,
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, Widget? page) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: page != null ? () => _navigateTo(page) : null,
    );
  }

  void _navigateTo(Widget page) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}