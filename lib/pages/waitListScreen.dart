import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class WaitlistScreen extends StatefulWidget {
  final int eventId; // Event ID passed to the screen

  const WaitlistScreen({super.key, required this.eventId});  // Ensure eventId is required here

  @override
  _WaitlistScreenState createState() => _WaitlistScreenState();
}

class _WaitlistScreenState extends State<WaitlistScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool isSubmitting = false;
  bool isSubmitted = false;

  Future<void> _joinWaitlist() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please enter your name and email."),
        backgroundColor: Colors.red,
      ));
      return;
    }

    setState(() => isSubmitting = true);

    final url = Uri.parse("http://192.168.1.6/event_management/api/add_to_waitlist.php");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "name": _nameController.text,
        "email": _emailController.text,
        "event_id": widget.eventId, // Pass event_id here
      }),
    );

    final data = json.decode(response.body);

    if (data["success"]) {
      setState(() {
        isSubmitted = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error: ${data['message']}"),
        backgroundColor: Colors.red,
      ));
    }

    setState(() => isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Join Waitlist")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isSubmitted
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 20),
            const Text(
              "You've been added to the waitlist!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text("We'll notify you if tickets become available."),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Back to Events"),
            ),
          ],
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "This event is sold out. Join the waitlist to be notified if tickets become available.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: isSubmitting ? null : _joinWaitlist,
                child: isSubmitting
                    ? const CircularProgressIndicator()
                    : const Text("Join Waitlist"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
