import 'package:flutter/material.dart';
import 'package:assignmentbit31/models/events.dart';
import 'paymentScreen.dart';
import '../models/seats.dart';

class SeatSelectionScreen extends StatefulWidget {
  final Event event;

  const SeatSelectionScreen({super.key, required this.event});

  @override
  _SeatSelectionScreenState createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  late List<List<Seat>> seats;
  double seatPrice = 20.0;
  double totalPrice = 0.0;
  TextEditingController promoController = TextEditingController();
  double discount = 0.0;
  bool isValidPromo = false;
  List<String> selectedSeats = [];

  @override
  void initState() {
    super.initState();

    // Ensure event.seats has the correct dimensions
    seats = List.generate(6, (row) => List.generate(8, (col) {
      bool isOccupied = false;

      if (row < widget.event.seats.length && col < widget.event.seats[row].length) {
        isOccupied = widget.event.seats[row][col].isOccupied;
      }

      return Seat(
        row: row,
        col: col,
        isOccupied: isOccupied,
      );
    }));
  }

  String getSeatLabel(int row, int col) {
    String rowLetter = String.fromCharCode(65 + row);
    return "$rowLetter${col + 1}";
  }

  void toggleSeat(int row, int col) {
    if (seats[row][col].isOccupied) return;

    setState(() {
      String seatLabel = getSeatLabel(row, col);
      if (selectedSeats.contains(seatLabel)) {
        selectedSeats.remove(seatLabel);
      } else {
        selectedSeats.add(seatLabel);
      }
      calculateTotal();
    });
  }

  void calculateTotal() {
    totalPrice = selectedSeats.length * seatPrice * (1 - discount);
  }

  void applyPromoCode() {
    String code = promoController.text.trim().toUpperCase();
    setState(() {
      if (code == "DISCOUNT10") {
        discount = 0.10;
        isValidPromo = true;
      } else if (code == "DISCOUNT20") {
        discount = 0.20;
        isValidPromo = true;
      } else {
        discount = 0.0;
        isValidPromo = false;
      }
      calculateTotal();
    });
  }

  void proceedToPayment() async {
    if (selectedSeats.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select at least one seat!")),
      );
      return;
    }

    final paymentSuccess = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(totalPrice: totalPrice),
      ),
    );

    if (paymentSuccess == true) {
      setState(() {
        for (var seatLabel in selectedSeats) {
          int row = seatLabel.codeUnitAt(0) - 65;
          int col = int.parse(seatLabel.substring(1)) - 1;
          seats[row][col].isOccupied = true;
        }
        selectedSeats.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Seats successfully booked!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Seats - ${widget.event.title}")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(" ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              height: 5,
              width: double.infinity,
              color: Colors.black,
            ),

            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: 6 * 8,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, index) {
                  int row = index ~/ 8;
                  int col = index % 8;
                  bool isOccupied = seats[row][col].isOccupied;
                  String seatLabel = getSeatLabel(row, col);

                  return GestureDetector(
                    onTap: () => toggleSeat(row, col),
                    child: Container(
                      margin: const EdgeInsets.all(6),
                      child: Icon(
                        Icons.event_seat,
                        size: 30,
                        color: isOccupied
                            ? Colors.red
                            : (selectedSeats.contains(seatLabel)
                            ? Colors.orange
                            : Colors.green[400]),
                      ),
                    ),
                  );
                },
              ),
            ),

            if (selectedSeats.isNotEmpty)
              Column(
                children: [
                  const Text(
                    "Selected Seats:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    selectedSeats.join(", "),
                    style: const TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                  const SizedBox(height: 10),
                ],
              ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: promoController,
                decoration: InputDecoration(
                  hintText: "Enter Promo Code",
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.check, color: Colors.blue),
                    onPressed: applyPromoCode,
                  ),
                ),
              ),
            ),

            if (isValidPromo)
              Text(
                "Promo Applied: ${discount * 100}% off!",
                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),

            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Total Price: \$${totalPrice.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: proceedToPayment,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text(
                "Proceed to Payment",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}