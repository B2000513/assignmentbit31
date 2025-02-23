import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  final double totalPrice;

  const PaymentScreen({super.key, required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Payment")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),

            // 🎯 Total Amount
            Text(
              "Total Amount: \$${totalPrice.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 20),

            // 🎯 Payment Options
            Text(
              "Choose Payment Method:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 10),

            // PayPal Payment Button
            ElevatedButton(
              onPressed: () {
                _processPayPalPayment(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.payment, color: Colors.white),
                  SizedBox(width: 10),
                  Text("Pay with PayPal", style: TextStyle(fontSize: 16, color: Colors.white)),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Cancel Button
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: TextStyle(fontSize: 16, color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }

  // 🎯 Mock PayPal Payment Processing
  void _processPayPalPayment(BuildContext context) {
    // Simulate payment processing
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Payment Successful"),
        content: Text("Your payment of \$${totalPrice.toStringAsFixed(2)} has been processed via PayPal."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Go back to main screen
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }
}
