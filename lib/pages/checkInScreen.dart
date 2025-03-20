import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CheckInScreen extends StatefulWidget {
  final int ticketId;

  const CheckInScreen({super.key, required this.ticketId});

  @override
  _CheckInScreenState createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  Map<String, dynamic>? ticketDetails;
  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    fetchTicketDetails();
  }

  /// Fetch ticket details from backend
  Future<void> fetchTicketDetails() async {
    final url = Uri.parse("http://192.168.1.6/event_management/api/get_ticket.php?ticket_id=${widget.ticketId}");
    print("Request URL: $url");

    try {
      final response = await http.get(url);
      print("API Response: ${response.body}");  // DEBUGGING LIN
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Decoded Data: $data");
        if (data.containsKey("error")) {
          throw Exception("Ticket not found");
        }
        setState(() {
          ticketDetails = data;
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load ticket details");
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        isError = true;
        isLoading = false;
      });
    }
  }

  /// Convert Column Number to Letter (A-Z) and Combine with Row Number
  String formatSeat(int row, int col) {
    String columnLetter = String.fromCharCode(65 + col - 1); // A-Z for columns
    return "$columnLetter$row"; // Example: B3, D5
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Event Ticket")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: isLoading
              ? const CircularProgressIndicator()
              : isError || ticketDetails == null
              ? const Text("Failed to load ticket details")
              : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                ticketDetails!['event_name'] ?? "Unknown Event",
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                "Time: ${ticketDetails!['event_time']}",
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Text(
                "Seat: ${formatSeat(ticketDetails!['row_number'], ticketDetails!['col_number'])}",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildQrCode(ticketDetails!['ticket_code']),
              const SizedBox(height: 20),
              Text(
                "Ticket ID: ${ticketDetails!['id']}",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget to Generate QR Code
  Widget _buildQrCode(String data) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: QrImageView(
        data: data,
        version: QrVersions.auto,
        size: 200.0,
        gapless: true,
      ),
    );
  }
}
