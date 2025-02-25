import 'package:flutter/material.dart';
import 'checkInScreen.dart'; // Import the QR Ticket Page
import '../models/events.dart'; // Import Event Model

class CheckInSelectionScreen extends StatelessWidget {
  const CheckInSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Your Event"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: ListView.separated(
          itemCount: eventList.length,
          separatorBuilder: (context, index) => Divider(height: 1, thickness: 0.5, color: Colors.grey[300]),
          itemBuilder: (context, index) {
            final event = eventList[index];

            return ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset('assets/concert.jpg', width: 60, height: 60, fit: BoxFit.cover),
              ),
              title: Text(event.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              subtitle: Text("Tap to check-in", style: TextStyle(fontSize: 14, color: Colors.grey[600])),
              trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[600]),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              tileColor: Colors.white,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckInScreen(ticketId: event.title.hashCode.toString()),
                  ),
                );
              },
            );
          },
        ),
      ),
      backgroundColor: Colors.grey[100],
    );
  }
}
