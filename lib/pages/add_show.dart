import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/seats.dart';

class AddShowPage extends StatefulWidget {
  const AddShowPage({super.key, u});

  @override
  _AddShowPageState createState() => _AddShowPageState();
}

class _AddShowPageState extends State<AddShowPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController introController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController rowController = TextEditingController();
  final TextEditingController colController = TextEditingController();

  File? _posterImage;
  final ImagePicker _picker = ImagePicker();

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _posterImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add New Show")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Show Name Input
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Show Name"),
            ),
            SizedBox(height: 10),

            // Introduction Input
            TextField(
              controller: introController,
              decoration: InputDecoration(labelText: "Introduction"),
              maxLines: 3,
            ),
            SizedBox(height: 10),

            // Date Input
            TextField(
              controller: dateController,
              decoration: InputDecoration(labelText: "Date"),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2022),
                  lastDate: DateTime(2030),
                );
                if (pickedDate != null) {
                  setState(() {
                    dateController.text = "${pickedDate.toLocal()}".split(' ')[0];
                  });
                }
              },
              readOnly: true,
            ),
            SizedBox(height: 10),

            // Time Input
            TextField(
              controller: timeController,
              decoration: InputDecoration(labelText: "Time"),
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  setState(() {
                    timeController.text = pickedTime.format(context);
                  });
                }
              },
              readOnly: true,
            ),
            SizedBox(height: 10),

            // Location Input
            TextField(
              controller: locationController,
              decoration: InputDecoration(labelText: "Location"),
            ),
            SizedBox(height: 10),

            // Row Input
            TextField(
              controller: rowController,
              decoration: InputDecoration(labelText: "Number of Rows"),
              keyboardType: TextInputType.number,
              onChanged: (value) => setState(() {}),
            ),
            SizedBox(height: 10),

            // Column Input
            TextField(
              controller: colController,
              decoration: InputDecoration(labelText: "Number of Columns"),
              keyboardType: TextInputType.number,
              onChanged: (value) => setState(() {}),
            ),
            SizedBox(height: 10),

            // Display Total Seats
            Text(
              "Total Seats: ${_calculateTotalSeats()}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Poster Upload Button
            Center(
              child: Column(
                children: [
                  _posterImage != null
                      ? Image.file(_posterImage!, height: 150)
                      : Text("No poster selected"),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text("Select Poster Image"),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Submit Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _submitShow();
                },
                child: Text("Add Show"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to calculate total seats
  int _calculateTotalSeats() {
    int rows = int.tryParse(rowController.text) ?? 0;
    int cols = int.tryParse(colController.text) ?? 0;
    return rows * cols;
  }

  // Function to handle form submission
  void _submitShow() {
    String showName = nameController.text;
    String introduction = introController.text;
    String date = dateController.text;
    String time = timeController.text;
    String location = locationController.text;
    int rows = int.tryParse(rowController.text) ?? 0;
    int cols = int.tryParse(colController.text) ?? 0;
    int totalSeats = _calculateTotalSeats();

    if (showName.isEmpty || date.isEmpty || time.isEmpty || location.isEmpty || rows == 0 || cols == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all fields correctly")),
      );
      return;
    }

    // Example of creating seat objects
    List<Seat> seats = [];
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        seats.add(Seat(row: r, col: c));
      }
    }

    // Print data for now (You can replace this with actual data submission logic)
    print("Show Added: $showName, $date, $time, $location, Seats: $totalSeats");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Show Added Successfully!")),
    );

    Navigator.pop(context);
  }
}
