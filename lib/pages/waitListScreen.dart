import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WaitlistScreen extends StatefulWidget {
  final String eventTitle; // Accept event title to display in the waitlist screen

  const WaitlistScreen ({super.key, required this.eventTitle});

  @override
  State<WaitlistScreen> createState() => _WaitlistScreenState();
}

class _WaitlistScreenState extends State<WaitlistScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool isSubmitted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.eventTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isSubmitted
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 20),
            Text(AppLocalizations.of(context)!.you_been_added_to_the_waitlist, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(AppLocalizations.of(context)!.we_notify_you_if_tickets_become_available),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child:  Text(AppLocalizations.of(context)!.back_to_events),
            ),
          ],
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(AppLocalizations.of(context)!.event_sold_out_mes,
                style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.name),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.email),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    isSubmitted = true;
                  });
                },
                child: Text(AppLocalizations.of(context)!.join_waitlist),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
