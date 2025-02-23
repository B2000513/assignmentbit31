class Seat {
  final int row;
  final int col;
  bool isOccupied;

  Seat({required this.row, required this.col, this.isOccupied = false});
}