import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class WaitlistPage extends StatefulWidget {
  const WaitlistPage({super.key});

  @override
  _WaitlistPageState createState() => _WaitlistPageState();
}

class _WaitlistPageState extends State<WaitlistPage> {
  List<Map<String, dynamic>> waitlistShows = [];
  List<Map<String, dynamic>> availableShows = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWaitlistData();
  }

  Future<void> fetchWaitlistData() async {
    final response = await http.get(Uri.parse("http://192.168.100.22/event_management/api/get_waitlist.php"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        waitlistShows = List<Map<String, dynamic>>.from(data["waitlist"]);
        availableShows = List<Map<String, dynamic>>.from(data["available"]);
        isLoading = false;
      });
    } else {
      throw Exception("Failed to load data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Waitlist")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection("Waitlist", waitlistShows, Colors.orange),
            const Divider(),
            _buildSection("Available", availableShows, Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Map<String, dynamic>> shows, Color statusColor) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: shows.length,
              itemBuilder: (context, index) {
                final show = shows[index];
                return Card(
                  child: ListTile(
                    title: Text(show["title"], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(show["introduction"], style: const TextStyle(fontSize: 14)),
                        Text("📅 ${show["date"]} | ⏰ ${show["time"]}", style: const TextStyle(color: Colors.grey)),
                        Text("Status: ${show["status"]}", style: TextStyle(color: statusColor)),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
