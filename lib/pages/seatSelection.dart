import 'package:assignmentbit31/models/events.dart';
import 'package:flutter/material.dart';
import 'paymentScreen.dart';
import '../models/seats.dart';

class SeatSelectionScreen extends StatefulWidget {
  final Event event; // 🎯 Accepts Event object

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

  @override
  void initState() {
    super.initState();

    // 🎯 Initialize seats based on event
    seats = List.generate(6, (row) => List.generate(3, (col) {
      return Seat(
        row: row,
        col: col,
        isOccupied: widget.event.seats[row][col].isOccupied, // Load occupied seats
      );
    }));
  }

  void toggleSeat(int row, int col) {
    if (seats[row][col].isOccupied) return; // ❌ Prevent selecting occupied seats
    setState(() {
      seats[row][col].isOccupied = !seats[row][col].isOccupied;
      calculateTotal();
    });
  }

  void calculateTotal() {
    int selectedSeats = seats.expand((row) => row).where((seat) => seat.isOccupied).length;
    totalPrice = selectedSeats * seatPrice * (1 - discount);
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
    final paymentSuccess = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(totalPrice: totalPrice),
      ),
    );

    if (paymentSuccess == true) {
      // 🎯 Confirm booking by marking seats as occupied
      setState(() {
        for (var row in seats) {
          for (var seat in row) {
            if (seat.isOccupied) {
              widget.event.seats[seat.row][seat.col].isOccupied = true;
            }
          }
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Seats successfully booked!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Seats for ${widget.event.title}")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Select Your Seats", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            // 🎯 Scrollable Seat Grid
            Expanded(
              child: SingleChildScrollView(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(), // Prevent nested scrolling
                  itemCount: 6 * 3,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.2,
                  ),
                  itemBuilder: (context, index) {
                    int row = index ~/ 3;
                    int col = index % 3;
                    return GestureDetector(
                      onTap: () => toggleSeat(row, col),
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: seats[row][col].isOccupied ? Colors.red : Colors.grey[300],
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(
                            "Seat ${index + 1}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: seats[row][col].isOccupied ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🎯 Promo Code Input
            TextField(
              controller: promoController,
              decoration: InputDecoration(
                labelText: "Enter Promo Code",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: applyPromoCode,
                ),
              ),
            ),
            const SizedBox(height: 10),

            if (isValidPromo)
              Text("Promo Applied: ${discount * 100}% off!", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            // 🎯 Total Price Display
            Text("Total Price: \$${totalPrice.toStringAsFixed(2)}", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            // 🎯 Proceed Button
            ElevatedButton(
              onPressed: proceedToPayment,
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
              child: const Text("Proceed to Payment", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
