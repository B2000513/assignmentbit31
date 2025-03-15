import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentScreen extends StatelessWidget {
  final int eventId;
  final List<Map<String, dynamic>> seatItems;

  const PaymentScreen({
    super.key,
    required this.eventId,
    required this.seatItems,
  });

  /// Dynamically compute totalPrice from seatItems
  double get totalPrice {
    double sum = 0.0;
    for (var seat in seatItems) {
      sum += (seat["price"] ?? 0.0) as double;
    }
    return sum;
  }

  /// The number of seats booked is simply the length of seatItems
  int get seatsBooked => seatItems.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Checkout"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Summary Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Order Summary",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const Divider(),

                    // List each seat & price
                    for (var seat in seatItems) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Seat ${seat["seatLabel"]}"),
                          Text("\$${(seat["price"] ?? 0.0).toStringAsFixed(2)}"),
                        ],
                      ),
                    ],

                    const SizedBox(height: 10),
                    // Display total
                    Text(
                      "Total Amount: \$${totalPrice.toStringAsFixed(2)}",
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Payment Methods
            const Text("Select Payment Method",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            _buildPaymentButton(context, Icons.payment, "Pay with PayPal", Colors.blue[800],
                    () => _processPayment(context)),
            const SizedBox(height: 10),
            _buildPaymentButton(context, Icons.credit_card, "Pay with Credit Card", Colors.grey[700],
                    () => _showCreditCardDialog(context)),

            const Spacer(),

            // Cancel Button
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(fontSize: 16, color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentButton(BuildContext context, IconData icon, String text, Color? color, VoidCallback onPressed) {
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

  void _processPayment(BuildContext context) async {
    final url = Uri.parse('http://192.168.1.6/event_management/api/process_payment.php');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_id": 1, // Replace with the actual logged-in user ID
        "event_id": eventId,
        "total_price": totalPrice,
        "seats": seatItems.map((seat) => seat["seat_id"]).toList(), // List of seat IDs
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData["status"] == "success") {
        // ✅ Call create ticket function after successful payment
        await _createTicket(context, responseData["payment_id"]);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData["message"])),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Payment failed. Please try again.")),
      );
    }
  }

  /// ✅ Function to Create Ticket After Successful Payment
  Future<void> _createTicket(BuildContext context, String paymentId) async {
    final url = Uri.parse('http://192.168.1.6/event_management/api/create_ticket.php');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_id": 1, // Replace with actual logged-in user ID
        "event_id": eventId,
        "seats": seatItems.map((seat) => seat["seat_id"]).toList(), // List of seat IDs
        "price_paid": totalPrice,
        "payment_id": paymentId, // Track payment ID for reporting
      }),
    );

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Ticket Confirmed"),
          content: Text(
            "Your ticket has been created successfully!\nTotal Paid: \$${totalPrice.toStringAsFixed(2)}",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to create ticket. Please try again.")),
      );
    }
  }

  void _showCreditCardDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Credit Card Payment"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Enter your credit card details."),
            const SizedBox(height: 10),
            TextField(decoration: const InputDecoration(labelText: "Card Number"), keyboardType: TextInputType.number),
            TextField(decoration: const InputDecoration(labelText: "Expiry Date"), keyboardType: TextInputType.datetime),
            TextField(decoration: const InputDecoration(labelText: "CVV"), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _processPayment(context); // Reuse the same logic after CC payment
            },
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }
}
