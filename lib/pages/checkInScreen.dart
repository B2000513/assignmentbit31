import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CheckInScreen extends StatelessWidget {
  final String ticketId; // Ticket ID (Unique)

  const CheckInScreen({super.key, required this.ticketId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Event Ticket")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Show this QR code at entry",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            //    Generate QR Code
            QrImageView(
              data: ticketId, // Ticket ID as QR Data
              version: QrVersions.auto,
              size: 200.0,
            ),

            const SizedBox(height: 20),
            Text("Ticket ID: $ticketId", style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}