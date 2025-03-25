import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CheckInScreen extends StatelessWidget {
  final String ticketId; // Ticket ID (Unique)

  const CheckInScreen({super.key, required this.ticketId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.your_event_ticket)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Text(
              AppLocalizations.of(context)!.show_qr,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            //    Generate QR Code
            QrImageView(
              data: ticketId, // Ticket ID as QR Data
              version: QrVersions.auto,
              size: 200.0,
            ),

            const SizedBox(height: 20),
            Text(
              "${AppLocalizations.of(context)!.ticket_id} $ticketId",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}