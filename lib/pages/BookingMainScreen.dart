import 'package:flutter/material.dart';
import '../models/events.dart'; // Import Event model
import '../pages/eventDetailPage.dart';
import 'seatSelection.dart';

class BookingMainScreen extends StatelessWidget {
  const BookingMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Book Your Event")),
      drawer: _buildSidebar(context), // 🎯 Sidebar (Drawer)
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: eventList.length,
          itemBuilder: (context, index) {
            final event = eventList[index];

            return GestureDetector(
              onTap: () {
                // 🎯 Navigate to Event Detail Page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventDetailScreen(event: event),
                  ),
                );
              },
              child: Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🎯 Event Image
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.network(
                        event.image,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Text("Image not available", style: TextStyle(color: Colors.red)),
                            ),
                          );
                        },
                      ),
                    ),

                    // 🎯 Event Details & Booking Button
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.title,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),

                          Text(
                            "Available Seats: ${event.availableSeats}",
                            style: TextStyle(
                              fontSize: 16,
                              color: event.availableSeats > 0 ? Colors.green : Colors.red,
                            ),
                          ),
                          const SizedBox(height: 10),

                          if (event.availableSeats > 0)
                            ElevatedButton(
                              onPressed: () {
                                // Navigate to Seat Selection Screen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SeatSelectionScreen(event: event),
                                  ),
                                );
                              },
                              child: const Text("Book Now"),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // 🎯 Sidebar (Drawer) Widget
  Widget _buildSidebar(BuildContext context) {
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
