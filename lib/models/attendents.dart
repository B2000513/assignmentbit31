class Attendee {
  final String name;
  final String email;
  bool onWaitlist;

  Attendee({required this.name, required this.email, this.onWaitlist = false});
}

// Sample attendee data
List<Attendee> attendees = [
  Attendee(name: "Alice Johnson", email: "alice@example.com"),
  Attendee(name: "Bob Smith", email: "bob@example.com"),
];
