import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  final double totalPrice;

  const PaymentScreen({super.key, required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Checkout"), centerTitle: true),
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
                    Text("Order Summary", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Divider(),
                    Text("Total Amount: \$${totalPrice.toStringAsFixed(2)}",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green)),
                  ],
                ),
              ),
            ),

            SizedBox(height: 30),

            // Payment Methods
            Text("Select Payment Method", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),

            _buildPaymentButton(context, Icons.payment, "Pay with PayPal", Colors.blue[800], _processPayPalPayment),
            SizedBox(height: 10),
            _buildPaymentButton(context, Icons.credit_card, "Pay with Credit Card", Colors.grey[700], _showCreditCardDialog),

            Spacer(),

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

  Widget _buildPaymentButton(BuildContext context, IconData icon, String text, Color? color, Function(BuildContext) onPressed) {
    return ElevatedButton(
      onPressed: () => onPressed(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white),
          SizedBox(width: 10),
          Text(text, style: TextStyle(fontSize: 16, color: Colors.white)),
        ],
      ),
    );
  }

  void _processPayPalPayment(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Payment Successful"),
        content: Text("Your payment of \$${totalPrice.toStringAsFixed(2)} has been processed via PayPal."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showCreditCardDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Credit Card Payment"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Enter your credit card details."),
            SizedBox(height: 10),
            TextField(decoration: InputDecoration(labelText: "Card Number"), keyboardType: TextInputType.number),
            TextField(decoration: InputDecoration(labelText: "Expiry Date"), keyboardType: TextInputType.datetime),
            TextField(decoration: InputDecoration(labelText: "CVV"), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          ElevatedButton(onPressed: () => Navigator.pop(context), child: Text("Submit")),
        ],
      ),
    );
  }
}