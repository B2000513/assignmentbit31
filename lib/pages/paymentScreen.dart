import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentScreen extends StatefulWidget {
  final int eventId;
  final List<Map<String, dynamic>> seatItems;

  const PaymentScreen({
    super.key,
    required this.eventId,
    required this.seatItems,
  });

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int? userId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt("user_id");
      isLoading = false;
    });
  }

  double get totalPrice =>
      widget.seatItems.fold(0.0, (sum, seat) => sum + (seat["price"] ?? 0.0));

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Checkout"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderSummary(),
            const SizedBox(height: 30),
            const Text("Select Payment Method",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildPaymentButton(Icons.payment, "Confirm Payment",
                Colors.blue[800], _processPayment),
            const Spacer(),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel",
                  style: TextStyle(fontSize: 16, color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Order Summary",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            ...widget.seatItems.map((seat) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Seat ${seat["seatLabel"]}"),
                Text("\$${(seat["price"] ?? 0.0).toStringAsFixed(2)}"),
              ],
            )),
            const SizedBox(height: 10),
            Text(
              "Total: \$${totalPrice.toStringAsFixed(2)}",
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentButton(
      IconData icon, String text, Color? color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 10),
          Text(text, style: const TextStyle(fontSize: 16, color: Colors.white)),
        ],
      ),
    );
  }

  void _processPayment() async {
    if (userId == null) {
      _showSnackBar("User ID not found. Please log in again.");
      return;
    }

    List<int> validSeats = widget.seatItems
        .where((seat) => seat.containsKey("id") && seat["id"] != null)
        .map((seat) => seat["id"] as int)
        .toList();

    if (validSeats.isEmpty) {
      _showSnackBar("No valid seats selected.");
      return;
    }

    final requestBody = jsonEncode({
      "user_id": userId,
      "event_id": widget.eventId,
      "amount_paid": totalPrice,  // Match PHP field
      "seats": validSeats,
    });

    try {
      final response = await http.post(
        Uri.parse('http://192.168.100.22/event_management/api/process_payment.php'),
        headers: {"Content-Type": "application/json"},
        body: requestBody,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData["success"] == true) {
          String paymentId = responseData["payment_id"]; // Extract payment ID
          await _createTicket(paymentId, validSeats);
        } else {
          _showSnackBar(responseData["message"] ?? "Payment failed.");
        }
      } else {
        _showSnackBar("Payment failed. Please try again.");
      }
    } catch (e) {
      _showSnackBar("An error occurred. Please check your connection and try again.");
    }
  }


  Future<void> _createTicket(String paymentId, List<int> seatIds) async {
    final ticketData = jsonEncode({
      "user_id": userId,
      "event_id": widget.eventId,
      "price_paid": totalPrice,
      "seats": seatIds,
      "payment_id": paymentId, // Include payment ID
    });

    try {
      final ticketResponse = await http.post(
        Uri.parse('http://192.168.100.22/event_management/api/create_ticket.php'),
        headers: {"Content-Type": "application/json"},
        body: ticketData,
      );

      if (ticketResponse.statusCode == 200) {
        final ticketResponseData = jsonDecode(ticketResponse.body);

        if (ticketResponseData["status"] == "success") {
          _showSuccessDialog(paymentId);
        } else {
          _showSnackBar(ticketResponseData["message"] ?? "Ticket creation failed.");
        }
      } else {
        _showSnackBar("Ticket creation failed. Please try again.");
      }
    } catch (e) {
      _showSnackBar("An error occurred while creating the ticket.");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _showSuccessDialog(String paymentId) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Success"),
        content: Text("Payment successful!\nPayment ID: $paymentId\nTotal: \$${totalPrice.toStringAsFixed(2)}"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(context, '/bookingMainScreen', (route) => false);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
