class Event {
  final int id;
  final String title;
  final String image;
  final String? description;
  final String? venue;
  final String? time;
  final int availableSeats;

  Event({
    required this.id,
    required this.title,
    required this.image,
    this.description,
    this.venue,
    this.time,
    required this.availableSeats,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],  // No need to parse if already an int
      title: json['title'],
      image: json['poster_image'] ?? 'assets/default.jpg',
      description: json['description'],
      venue: json['venue'],
      time: "${json['event_date']} at ${json['event_time']}",
      availableSeats: json['available_seats'], // No need to parse if already an int
    );
  }
}