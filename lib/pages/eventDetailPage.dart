import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/events.dart';
import '../pages/seatSelection.dart';

class EventDetailScreen extends StatefulWidget {
  final Event event;

  const EventDetailScreen({super.key, required this.event});

  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  late Event event;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    event = widget.event;
    _fetchEventDetails();
  }

  Future<void> _fetchEventDetails() async {
    final url = Uri.parse("http://192.168.100.22/event_management/api/get_event.php?id=${event.id}");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          event = Event(
            id: data['id'],
            title: data['title'],
            image: data['poster_image'] ?? "https://via.placeholder.com/400",
            description: data['description'],
            venue: data['venue'],
            time: "${data['event_date']} at ${data['event_time']}",
            availableSeats: int.tryParse(data['available_seats'].toString()) ?? 0,
          );
          isLoading = false;
        });
      } else {
        throw Exception("Failed to fetch event details");
      }
    } catch (e) {
      print("Error fetching event details: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(event.title)),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: event.image.startsWith("http")
                  ? Image.network(
                event.image,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Text("Image not available"));
                },
              )
                  : Image.asset(
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
            Text(
              event.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              event.description ?? "No description available",
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Text(
              "📍 Venue: ${event.venue ?? "To be announced"}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "⏰ Time: ${event.time ?? "To be announced"}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Available Seats: ${event.availableSeats}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: event.availableSeats > 0
                    ? () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                      builder: (context) => SeatSelectionScreen(event: event),
                  ),
                  );
                }
                    : null,
                child: Text(event.availableSeats > 0 ? "Buy Seat" : "Sold Out"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
