import 'package:flutter/material.dart';
import 'checkInScreen.dart'; // Import the QR Ticket Page
import '../models/events.dart'; // Import Event Model

class CheckInSelectionScreen extends StatelessWidget {
  const CheckInSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Your Event")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: eventList.length, // List of events
        itemBuilder: (context, index) {
          final event = eventList[index];

          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: Image.network(event.image, width: 50, height: 50, fit: BoxFit.cover),
              title: Text(event.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                //     Navigate to QR Ticket Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckInScreen(ticketId: event.title.hashCode.toString()), // Generate a unique QR
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}