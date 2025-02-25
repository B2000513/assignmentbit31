import 'seats.dart';

class Event {
  final String title;
  final String image;
  final String? description; // Optional description
  final String? venue; // 🆕 Optional venue
  final String? time; // 🆕 Optional time
  List<List<Seat>> seats; // 🆕 Each event manages its own seats

  Event({
    required this.title,
    required this.image,
    this.description,
    this.venue,
    this.time,
    required this.seats,
  });

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

List<Event> eventList = [
  Event(
    title: "Concert A",
    image: "assets/concert.jpg",
    description: "An electrifying music concert featuring top artists.",
    venue: "Stadium XYZ",
    time: "7:30 PM, June 15, 2025",
    seats: List.generate(6, (row) => List.generate(3, (col) => Seat(
        row: row,
        col: col,
        isOccupied: (row == 0 && col == 1) || (row == 2 && col == 2) || (row == 4 && col == 0)
    ))),
  ),

  Event(
    title: "Movie B",
    image: "https://source.unsplash.com/400x200/?movie,cinema",
    description: "A thrilling movie night experience with premium seating.",
    venue: "Cinema Hall 5, City Mall",
    time: "9:00 PM, July 3, 2025",
    seats: List.generate(6, (row) => List.generate(3, (col) => Seat(
        row: row,
        col: col,
        isOccupied: (row == 1 && col == 0) || (row == 3 && col == 2) || (row == 5 && col == 1)
    ))),
  ),

  Event(
    title: "Sports Match C",
    image: "https://source.unsplash.com/400x200/?sports,stadium",
    description: "Catch the live action of an exciting sports match.",
    venue: "National Sports Arena",
    time: "5:00 PM, August 10, 2025",
    seats: List.generate(6, (row) => List.generate(3, (col) => Seat(
        row: row,
        col: col,
        isOccupied: (row == 2 && col == 1) || (row == 3 && col == 0) || (row == 4 && col == 2)
    ))),
  ),

  Event(
    title: "Music Fest 2025",
    image: "https://via.placeholder.com/400",
    description: "A grand festival celebrating music with renowned artists.",
    venue: "Open Grounds, Downtown",
    time: "4:00 PM - 11:00 PM, September 20, 2025",
    seats: List.generate(6, (row) => List.generate(3, (col) => Seat(
      row: row,
      col: col,
      isOccupied: true, // Sold out - triggers "Join Waitlist"
    ))),
  ),
];
