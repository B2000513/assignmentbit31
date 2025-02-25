import 'seats.dart'; // Import Seat class

class Event {
  final String title;
  final String image;
  List<List<Seat>> seats; // 🆕 Each event manages its own seats

  Event({required this.title, required this.image, required this.seats});

  // 🆕 Dynamically calculate available seats
  int get availableSeats =>
      seats.expand((row) => row).where((seat) => !seat.isOccupied).length;

  // 🆕 Check if the event is sold out
  bool get isSoldOut => availableSeats == 0;

  // 🆕 Lock seat after successful payment
  void bookSeat(int row, int col) {
    if (!seats[row][col].isOccupied) {
      seats[row][col].isOccupied = true;
    }
  }
}

// 🎯 Sample Data: Events with Seat Layouts
List<Event> eventList = [
  Event(
    title: "Concert A",
    image: "https://source.unsplash.com/400x200/?concert,music",
    seats: List.generate(6, (row) => List.generate(3, (col) => Seat(
        row: row,
        col: col,
        isOccupied: (row == 0 && col == 1) || (row == 2 && col == 2) || (row == 4 && col == 0)
    ))),
  ),

  Event(
    title: "Movie B",
    image: "https://source.unsplash.com/400x200/?movie,cinema",
    seats: List.generate(6, (row) => List.generate(3, (col) => Seat(
        row: row,
        col: col,
        isOccupied: (row == 1 && col == 0) || (row == 3 && col == 2) || (row == 5 && col == 1)
    ))),
  ),

  Event(
    title: "Sports Match C",
    image: "https://source.unsplash.com/400x200/?sports,stadium",
    seats: List.generate(6, (row) => List.generate(3, (col) => Seat(
        row: row,
        col: col,
        isOccupied: (row == 2 && col == 1) || (row == 3 && col == 0) || (row == 4 && col == 2)
    ))),
  ),

  Event(
    title: "Music Fest 2025",
    image: "https://via.placeholder.com/400",
    seats: List.generate(6, (row) => List.generate(3, (col) => Seat(
row: row,
col: col,
isOccupied: true, // Sold out - triggers "Join Waitlist"
  ))),
  ),

];
