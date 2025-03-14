import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'paymentScreen.dart';
import '../models/events.dart';
import '../pages/eventDetailPage.dart';
import 'seatSelection.dart';
import 'waitlistScreen.dart';
import 'CheckInSelectionScreen.dart';
import '../pages/user_profile_page.dart';
import '../pages/login_page.dart';

class BookingMainScreen extends StatefulWidget {
  const BookingMainScreen({super.key});

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

  Future<List<Event>> fetchEvents() async {
    final url = Uri.parse("http://192.168.1.6/event_management/api/get_event.php");
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
      drawer: _buildSidebar(context),
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
                                          builder: (context) => WaitlistScreen(),
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
          _buildSidebarItem(context, Icons.person, "Profile", UserProfilePage()),
          _buildSidebarItem(context, Icons.payment, "Payment", null),
          _buildSidebarItem(context, Icons.settings, "Settings", null),
          _buildSidebarItem(context, Icons.list_alt, "Ticket", CheckInSelectionScreen()),
          _buildSidebarItem(context, Icons.hourglass_bottom, "Waitlist", WaitlistScreen()),
          const Divider(),
          _buildSidebarItem(context, Icons.logout, "Logout", LoginPage(), isLogout: true),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(BuildContext context, IconData icon, String title, Widget? page, {bool isLogout = false}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        if (isLogout) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page!));
        } else if (page != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => page));
        }
      },
    );
  }
}
