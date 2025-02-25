import 'package:flutter/material.dart';

class WaitlistPage extends StatelessWidget {
  final List<Map<String, String>> waitlistShows = [
    {
      "title": "Opera from KentNg",
      "introduction": "Famous Malaysia opera singer comes to HELP University.",
      "date": "May 31, 2025",
      "time": "8:00 PM",
      "status": "Waiting"
    },
    {
      "title": "Radical Optimisim Tour",
      "introduction": "Dua Lipa's Asia Tour at HELP University.",
      "date": "Nov 23, 2025",
      "time": "8:30 PM",
      "status": "Waiting"
    },
    {
      "title": "Les Misérables",
      "introduction": "A revolutionary tale of justice and redemption.",
      "date": "March 20, 2025",
      "time": "6:30 PM",
      "status": "Waiting"
    },
  ];

  final List<Map<String, String>> availableShows = [
    {
      "title": "Blackpink Concert 2023",
      "introduction": "K-POP Girl Group Sensation in your area.",
      "date": "March 4, 2023",
      "time": "8:00 PM",
      "status": "Available"
    },
    {
      "title": "MAMAMOO Concert 2023",
      "introduction": "MYCON concert exclusive at HELP University.",
      "date": "Feb 11, 2023",
      "time": "8:00 PM",
      "status": "Available"
    },
    {
      "title": "The Book of Mormon",
      "introduction": "A hilarious and satirical Broadway musical.",
      "date": "March 22, 2025",
      "time": "8:00 PM",
      "status": "Available"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Waitlist")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Waitlist Section
            Text("Waitlist", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: waitlistShows.length,
                itemBuilder: (context, index) {
                  final show = waitlistShows[index];
                  return Card(
                    child: ListTile(
                      title: Text(show["title"]!, style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(show["introduction"]!, style: TextStyle(fontSize: 14)),
                          Text("📅 ${show["date"]} | ⏰ ${show["time"]}", style: TextStyle(color: Colors.grey)),
                          Text("Status: ${show["status"]}", style: TextStyle(color: Colors.orange)),
                        ],
                      ),
                      isThreeLine: true,
                    ),
                  );
                },
              ),
            ),
            Divider(),

            // Available Section
            Text("Available", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: availableShows.length,
                itemBuilder: (context, index) {
                  final show = availableShows[index];
                  return Card(
                    child: ListTile(
                      title: Text(show["title"]!, style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(show["introduction"]!, style: TextStyle(fontSize: 14)),
                          Text("📅 ${show["date"]} | ⏰ ${show["time"]}", style: TextStyle(color: Colors.grey)),
                          Text("Status: ${show["status"]}", style: TextStyle(color: Colors.green)),
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
      ),
    );
  }
}
