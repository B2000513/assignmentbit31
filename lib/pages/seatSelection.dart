import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'paymentScreen.dart';
import '../models/events.dart';

class SeatSelectionScreen extends StatefulWidget {
  final Event event;
  const SeatSelectionScreen({super.key, required this.event});

  @override
  _SeatSelectionScreenState createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  /// 2D list of seats; each seat is a Map with keys: "col", "status", "price", "seatLabel"
  List<List<Map<String, dynamic>>> seats = [];

  /// List of selected seat labels (e.g. "A1", "B5")
  List<String> selectedSeats = [];

  /// Accumulates the total cost of all selected seats (computed from seatItems in PaymentScreen)
  double totalPrice = 0.0;

  /// Future for fetching seats once at init
  late Future<void> seatDataFuture;

  @override
  void initState() {
    super.initState();
    seatDataFuture = fetchSeats();
  }

  Future<void> fetchSeats() async {
    try {
      final response = await http.get(
        Uri.parse(
          'http://192.168.1.6/event_management/api/get_seat.php?event_id=${widget.event.id}',
        ),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (!data["success"]) {
          if (mounted) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(data["message"])));
          }
          return;
        }
        Map<int, List<Map<String, dynamic>>> seatMap = {};
        for (var seat in data["seats"]) {
          int row = seat["row_number"];
          int col = seat["col_number"];
          String status = seat["status"] ?? "available"; // Ensure status is not null
          double price = double.tryParse(seat["price"].toString()) ?? 0.0;
          seatMap[row] ??= [];
          seatMap[row]?.add({
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
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Failed to load seats.")));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  /// Toggles a seat's selection. The seat's actual price is used to update the total.
  void toggleSeat(String seatLabel, double seatPrice) {
    setState(() {
      if (selectedSeats.contains(seatLabel)) {
        selectedSeats.remove(seatLabel);
        totalPrice -= seatPrice;
      } else {
        selectedSeats.add(seatLabel);
        totalPrice += seatPrice;
      }
    });
  }

  /// Reserve seats via API and then navigate to PaymentScreen, passing detailed seat data.
  Future<void> reserveSeats() async {
    if (selectedSeats.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select at least one seat!")));
      return;
    }

    // Convert selected seat labels to a list of row & col data for API call.
    List<Map<String, int>> selectedSeatData = selectedSeats.map((seatLabel) {
      int row = seatLabel.codeUnitAt(0) - 65 + 1; // 'A' -> 1, etc.
      int col = int.parse(seatLabel.substring(1));
      return {"row_number": row, "col_number": col};
    }).toList();

    final url =
    Uri.parse('http://192.168.1.6/event_management/api/reserve_seat.php');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "event_id": widget.event.id,
          "seats": selectedSeatData,
        }),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result["success"] == true) {
          // Build a detailed list of seat items for PaymentScreen.
          List<Map<String, dynamic>> seatItems = [];
          for (String seatLabel in selectedSeats) {
            for (var row in seats) {
              final found = row.firstWhere(
                    (s) => s["seatLabel"] == seatLabel,
                orElse: () => {},
              );
              if (found.isNotEmpty) {
                seatItems.add({
                  "seatLabel": found["seatLabel"],
                  "price": found["price"] ?? 0.0,
                });
                break;
              }
            }
          }

          setState(() {
            selectedSeats.clear();
            totalPrice = 0.0;
            seatDataFuture = fetchSeats(); // Refresh seat status
          });

          // Navigate to PaymentScreen, passing seatItems for breakdown.
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentScreen(
                eventId: widget.event.id,
                seatItems: seatItems,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(result["message"])));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Failed to reserve seats. Try again!")));
      }
    } catch (e) {
      debugPrint("Error reserving seats: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
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
          } else if (snapshot.hasError) {
            return Center(child: Text("Failed to load seats."));
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
                      String seatLabel = seat["seatLabel"];
                      String status = seat["status"] ?? "available";
                      double seatPrice = seat["price"] ?? 0.0;
                      bool isBooked = status == "booked";
                      bool isSelected = selectedSeats.contains(seatLabel);

                      return GestureDetector(
                        onTap: isBooked ? null : () => toggleSeat(seatLabel, seatPrice),
                        child: Container(
                          margin: const EdgeInsets.all(6),
                          child: Icon(
                            Icons.event_seat,
                            size: 30,
                            color: isBooked
                                ? Colors.red
                                : (isSelected ? Colors.orange : Colors.green[400]),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Text("Total Price: \$${totalPrice.toStringAsFixed(2)}",
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: reserveSeats,
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30)),
                  child: const Text("Proceed to Payment",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
