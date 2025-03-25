import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/events.dart';
import '../pages/eventDetailPage.dart';
import 'seatSelection.dart';
import '../pages/waitListScreen.dart';
import 'CheckInSelectionScreen.dart';
import '../pages/user_profile_page.dart';
import '../pages/login_page.dart';
import '../widgets/sidebar.dart';

class BookingMainScreen extends StatefulWidget {
  const BookingMainScreen({super.key, required Function(Locale p1) setLocale});

  @override
  _BookingMainScreenState createState() => _BookingMainScreenState();
}



class _BookingMainScreenState extends State<BookingMainScreen> {
  late Future<List<Event>> eventsFuture;



  @override
  void initState() {
    super.initState();
    eventsFuture = fetchEvents();
  }



  Future<int?> _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("user_id");
  }





  Future<List<Event>> fetchEvents() async {
    final url = Uri.parse("http://192.168.100.22/event_management/api/get_event.php");
    try {
      final response = await http.get(url);
      print("Response Code: ${response.statusCode}");
      print("Response Body: ${response.body}");
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((event) => Event(
          id: event['id'],
          title: event['title'],
          image: event['poster_image'] ?? "https://via.placeholder.com/400",
          description: event['description'],
          venue: event['venue'],
          time: "${event['event_date']} at ${event['event_time']}",
          availableSeats: int.tryParse(event['available_seats'].toString()) ?? 0,
        )).toList();
      } else {
        throw Exception("Failed to load events");
      }
    } catch (e) {
      print("Error: $e");
      throw Exception("Error: $e");
    }
  }

  Future<void> _refreshEvents() async {
    setState(() {
      eventsFuture = fetchEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Book Your Event")),
      drawer: const SidebarWidget(),
      body: RefreshIndicator(
        onRefresh: _refreshEvents,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<List<Event>>(
            future: eventsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error loading events"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("No events available"));
              }
              final events = snapshot.data!;
              return ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  return GestureDetector(
                    onTap: () {
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
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SeatSelectionScreen(event: event),
                                        ),
                                      );
                                    },
                                    child: const Text("Book Now"),
                                  )
                                else
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => WaitlistScreen(eventId: event.id), // Pass event.id here
                                        ),
                                      );
                                    },
                                    child: const Text("Join Waitlist"),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
