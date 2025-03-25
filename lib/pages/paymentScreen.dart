import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PaymentScreen extends StatelessWidget {
  final double totalPrice;

  const PaymentScreen({super.key, required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.check_out), centerTitle: true),
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
                    Text(AppLocalizations.of(context)!.order_summary,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                      Divider(),
                    Text("${AppLocalizations.of(context)!.total_amount}: \$${totalPrice.toStringAsFixed(2)}",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 30),

            // Payment Methods
          Text(AppLocalizations.of(context)!.select_payment_method, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),

            _buildPaymentButton(context, Icons.payment, AppLocalizations.of(context)!.pay_with_PayPal, Colors.blue[800], _processPayPalPayment),
            SizedBox(height: 10),
            _buildPaymentButton(context, Icons.credit_card, AppLocalizations.of(context)!.pay_with_credit_card, Colors.grey[700], _showCreditCardDialog),

            Spacer(),

            // Cancel Button
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.cancel, style: TextStyle(fontSize: 16, color: Colors.red)),
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
        title: Text(AppLocalizations.of(context)!.payment_successful),
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
        title: Text(AppLocalizations.of(context)!.credit_card_payment),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.enter_your_credit_card_details),
            SizedBox(height: 10),
            TextField(decoration: InputDecoration(labelText: AppLocalizations.of(context)!.card_number), keyboardType: TextInputType.number),
            TextField(decoration: InputDecoration(labelText: AppLocalizations.of(context)!.expiry_date), keyboardType: TextInputType.datetime),
            TextField(decoration: InputDecoration(labelText: AppLocalizations.of(context)!.cvv
            ), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(AppLocalizations.of(context)!.cancel)),
          ElevatedButton(onPressed: () => Navigator.pop(context), child: Text(AppLocalizations.of(context)!.submit)),
        ],
      ),
    );
  }
}