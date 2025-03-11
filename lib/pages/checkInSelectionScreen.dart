import 'package:flutter/material.dart';
import 'checkInScreen.dart'; // Import the QR Ticket Page
import '../models/events.dart'; // Import Event Model
import 'dart:convert';
import 'package:http/http.dart' as http;

class CheckInSelectionScreen extends StatefulWidget {
  const CheckInSelectionScreen({super.key});

  @override
  _CheckInSelectionScreenState createState() => _CheckInSelectionScreenState();
}

class _CheckInSelectionScreenState extends State<CheckInSelectionScreen> {
  late Future<List<Event>> futureEvents;

  @override
  void initState() {
    super.initState();
    futureEvents = fetchEvents(); // Fetch events on screen load
  }

  Future<List<Event>> fetchEvents() async {
    final url = Uri.parse("http://192.168.1.6/event_management/api/get_events.php");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((event) => Event(
          id: event['id'],
          title: event['title'],
          image: event['poster_image'] ?? "https://via.placeholder.com/400",
          description: event['description'],
          venue: event['venue'],
          time: "${event['event_date']} at ${event['event_time']}",
          availableSeats: event['available_seats'], // Fetch seat count directly
        )).toList();
      } else {
        throw Exception("Failed to load events");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

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
        child: FutureBuilder<List<Event>>(
          future: futureEvents,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No events available"));
            }

            final events = snapshot.data!;
            return ListView.separated(
              itemCount: events.length,
              separatorBuilder: (context, index) => Divider(height: 1, thickness: 0.5, color: Colors.grey[300]),
              itemBuilder: (context, index) {
                final event = events[index];

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      event.image,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset('assets/concert.jpg', width: 60, height: 60, fit: BoxFit.cover);
                      },
                    ),
                  ),
                  title: Text(event.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  subtitle: Text("Tap to check-in", style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.blue[600]),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  tileColor: Colors.white,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckInScreen(ticketId: event.id.toString()),
                      ),
                    );
                  },
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
