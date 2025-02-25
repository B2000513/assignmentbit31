import 'package:flutter/material.dart';
import '../models/events.dart'; // Import Event model

class EventDetailScreen extends StatelessWidget {
  final Event event;

  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(event.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //      Event Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                event.image,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Text("Image not available"));
                },
              ),
            ),
            const SizedBox(height: 16),

            //      Event Title
            Text(
              event.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            //      Available Seats
            Text(
              "Available Seats: ${event.availableSeats}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            //      Buy Seat Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (event.availableSeats > 0) {
                    // TODO: Navigate to seat selection screen
                  }
                },
                child: Text(event.availableSeats > 0 ? "Buy Seat" : "Sold Out"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
