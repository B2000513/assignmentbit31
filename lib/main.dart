import 'package:flutter/material.dart';
import '../pages/login_page.dart';



void main() {
  runApp(TicketBookingApp());
}

class TicketBookingApp extends StatelessWidget {
  const TicketBookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ticket Booking',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(), // Show Login First
    );
  }
}
