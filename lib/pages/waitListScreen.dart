import 'package:flutter/material.dart';

class WaitlistScreen extends StatefulWidget {
  const WaitlistScreen({super.key});

  @override
  _WaitlistScreenState createState() => _WaitlistScreenState();
}

class _WaitlistScreenState extends State<WaitlistScreen> {
  final TextEditingController emailController = TextEditingController();
  final List<String> sampleWaitlist = ["user1@example.com", "user2@example.com"];

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Waitlist")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🎯 Static Waitlist Header
            const Text("Join the waitlist",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            // 🎯 Input Field
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Enter your email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            // 🎯 Join Button (No Real Functionality)
            ElevatedButton(
              onPressed: () => _showDialog("Info", "Feature not active in UI preview."),
              child: const Text("Join Waitlist"),
            ),
            const SizedBox(height: 20),

            // 🎯 Sample Waitlist
            const Text("Current Waitlist:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: sampleWaitlist.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(sampleWaitlist[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () => _showDialog("Info", "Remove feature disabled in UI preview."),
                    ),
                  );
                },
              ),
            ),

            // 🎯 Notify Attendee Button
            ElevatedButton(
              onPressed: () => _showDialog("Info", "Notification feature disabled in UI preview."),
              child: const Text("Notify Next Attendee"),
            ),
          ],
        ),
      ),
    );
  }
}
