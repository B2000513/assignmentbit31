import 'package:flutter/material.dart';
import 'checkInScreen.dart'; // QR Ticket Page
import '../models/events.dart'; // Event Model
import 'dart:convert';
import 'package:http/http.dart' as http;

class CheckInSelectionScreen extends StatefulWidget {
  final int userId;

  const CheckInSelectionScreen({super.key, required this.userId});

  @override
  _CheckInSelectionScreenState createState() => _CheckInSelectionScreenState();
}

class _CheckInSelectionScreenState extends State<CheckInSelectionScreen> {
  late Future<List<Event>> futureEvents;

  @override
  void initState() {
    super.initState();
    futureEvents = fetchUserEvents(widget.userId);
  }

  Future<int> fetchUserTicketId(int userId, int eventId) async {
    final url = Uri.parse("http://192.168.1.6/event_management/api/get_ticket_id.php?user_id=$userId&event_id=$eventId");

    try {
      final response = await http.get(url);
      debugPrint("API Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.containsKey("ticket_id")) {
          return data["ticket_id"];
        }
      }
      return 0; // Return 0 if ticket not found
    } catch (e) {
      debugPrint("API Error: $e");
      return 0;
    }
  }

  Future<List<Event>> fetchUserEvents(int userId) async {
    final url = Uri.parse("http://192.168.1.6/event_management/api/get_user_event.php?user_id=$userId");

    try {
      final response = await http.get(url);
      debugPrint("API Response: ${response.body}"); // ✅ Debug API Response

      if (response.statusCode != 200) {
        throw Exception("Failed to load user-specific events");
      }

      final List<dynamic> eventList = json.decode(response.body); // ✅ Expect a List, not a Map

      return eventList.map((event) => Event(
        id: event['id'] ?? 0, // ✅ Keep ID as int
        title: event['title'] ?? "No Title",
        image: (event['poster_image'] != null && event['poster_image'].isNotEmpty)
            ? event['poster_image']
            : "https://via.placeholder.com/400", // ✅ Fallback Image
        description: event['description'] ?? "No Description Available",
        venue: event['venue'] ?? "Unknown Venue",
        time: "${event['event_date']} at ${event['event_time']}" ?? "No Time",
        availableSeats: event['available_seats'] ?? 0, // ✅ Handle Null Seats
      )).toList();

    } catch (e) {
      debugPrint("API Error: $e");
      return []; // ✅ Return empty list instead of crashing
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Your Event"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Event>>(
          future: futureEvents,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return const Center(child: Text("No events available"));
            }

            return ListView.separated(
              itemCount: snapshot.data!.length,
              separatorBuilder: (_, __) => Divider(color: Colors.grey[300]),
              itemBuilder: (context, index) {
                final event = snapshot.data![index];
                return ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      event.image,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Image.asset(
                        'assets/concert.jpg', // ✅ Local Fallback Image
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text(
                    event.title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    "Tap to check-in",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.blue[600]),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  tileColor: Colors.white,
                  onTap: () async {
                    int ticketId = await fetchUserTicketId(widget.userId, event.id); // ✅ Fetch the correct ticket

                    if (ticketId != 0) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckInScreen(ticketId: ticketId),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Ticket not found!")),
                      );
                    }
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
