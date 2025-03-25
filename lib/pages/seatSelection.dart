import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'paymentScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/events.dart';

class SeatSelectionScreen extends StatefulWidget {
  final Event event;
  const SeatSelectionScreen({super.key, required this.event});

  @override
  _SeatSelectionScreenState createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  List<List<Map<String, dynamic>>> seats = [];
  List<Map<String, dynamic>> selectedSeats = [];
  double totalPrice = 0.0;
  late Future<void> seatDataFuture;

  @override
  void initState() {
    super.initState();
    seatDataFuture = fetchSeats();
  }

  Future<int?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  Future<void> fetchSeats() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.100.22/event_management/api/get_seat.php?event_id=${widget.event.id}'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (!data["success"]) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data["message"])));
          }
          return;
        }
        Map<int, List<Map<String, dynamic>>> seatMap = {};
        for (var seat in data["seats"]) {
          int row = seat["row_number"];
          int col = seat["col_number"];
          int seatId = seat["id"];
          String status = seat["status"] ?? "available";
          double price = double.tryParse(seat["price"].toString()) ?? 0.0;

          seatMap[row] ??= [];
          seatMap[row]?.add({
            "id": seatId,
            "col": col,
            "status": status,
            "price": price,
            "seatLabel": "${String.fromCharCode(65 + row - 1)}$col",
          });
        }
        if (mounted) {
          setState(() {
            seats = List.generate(seatMap.length, (i) => seatMap[i + 1] ?? []);
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  void toggleSeat(Map<String, dynamic> seat) {
    setState(() {
      if (selectedSeats.any((s) => s["id"] == seat["id"])) {
        selectedSeats.removeWhere((s) => s["id"] == seat["id"]);
        totalPrice -= seat["price"];
      } else {
        selectedSeats.add(seat);
        totalPrice += seat["price"];
      }
    });
  }

  Future<void> reserveSeats() async {
    if (selectedSeats.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select at least one seat!")),
      );
      return;
    }

    int? userId = await getUserId();
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not found. Please log in again.")),
      );
      return;
    }

    List<int> selectedSeatIds = selectedSeats.map((seat) => seat["id"] as int).toList();

    final url = Uri.parse('http://192.168.100.22/event_management/api/reserve_seat.php');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_id": userId,
          "event_id": widget.event.id,
          "seat_ids": selectedSeatIds,
        }),
      );

      final result = json.decode(response.body);
      if (response.statusCode == 200 && result["success"] == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentScreen(seatItems: selectedSeats, eventId: widget.event.id,),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Reservation failed: ${result["message"]}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error reserving seats: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Seats - ${widget.event.title}")),
      body: FutureBuilder<void>(
        future: seatDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    itemCount: seats.fold(0, (sum, row) => sum! + row.length),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 8,
                      childAspectRatio: 1.2,
                    ),
                    itemBuilder: (context, index) {
                      int row = index ~/ 8;
                      int colIndex = index % 8;
                      if (row >= seats.length || colIndex >= seats[row].length) {
                        return const SizedBox();
                      }
                      var seat = seats[row][colIndex];
                      bool isSelected = selectedSeats.any((s) => s["id"] == seat["id"]);
                      return GestureDetector(
                        onTap: (seat["status"] == "booked" || seat["status"] == "reserved")
                            ? null
                            : () => toggleSeat(seat),
                        child: Container(
                          margin: const EdgeInsets.all(6),
                          child: Icon(
                            Icons.event_seat,
                            size: 30,
                            color: seat["status"] == "booked"
                                ? Colors.red
                                : seat["status"] == "reserved"
                                ? Colors.yellow
                                : (isSelected ? Colors.orange : Colors.green[400]),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: reserveSeats,
                  child: const Text("Proceed to Payment"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
