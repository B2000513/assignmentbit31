import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/seats.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddShowPage extends StatefulWidget {
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
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.add_new_show)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Show Name Input
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText:AppLocalizations.of(context)!.show_name),
            ),
            SizedBox(height: 10),

            // Introduction Input
            TextField(
              controller: introController,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.introduction),
              maxLines: 3,
            ),
            SizedBox(height: 10),

            // Date Input
            TextField(
              controller: dateController,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.date),
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
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.time),
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
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.location),
            ),
            SizedBox(height: 10),

            // Row Input
            TextField(
              controller: rowController,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.num_of_rows),
              keyboardType: TextInputType.number,
              onChanged: (value) => setState(() {}),
            ),
            SizedBox(height: 10),

            // Column Input
            TextField(
              controller: colController,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.num_of_columns),
              keyboardType: TextInputType.number,
              onChanged: (value) => setState(() {}),
            ),
            SizedBox(height: 10),

            // Display Total Seats
            Text(
              "${AppLocalizations.of(context)!.total_seats} ${_calculateTotalSeats()}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 10),

            // Poster Upload Button
            Center(
              child: Column(
                children: [
                  _posterImage != null
                      ? Image.file(_posterImage!, height: 150)
                      : Text(AppLocalizations.of(context)!.no_poster_sel),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text(AppLocalizations.of(context)!.select_poster_image),
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
                child: Text(AppLocalizations.of(context)!.add_show),
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
        SnackBar(content: Text(AppLocalizations.of(context)!.please_fill_up)),
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
      SnackBar(content: Text(AppLocalizations.of(context)!.show_added_suc)),
    );

    Navigator.pop(context);
  }
}
