import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

class AddShowPage extends StatefulWidget {
  const AddShowPage({super.key, u});

  @override
  _AddShowPageState createState() => _AddShowPageState();
}

class _AddShowPageState extends State<AddShowPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController introController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController rowController = TextEditingController();
  final TextEditingController colController = TextEditingController();

  File? _posterImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null && mounted) {
      setState(() {
        _posterImage = File(pickedFile.path);
      });
    }
  }

  int _calculateTotalSeats() {
    int rows = int.tryParse(rowController.text) ?? 0;
    int cols = int.tryParse(colController.text) ?? 0;
    return rows * cols;
  }

  Future<void> _submitShow() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    String? base64Image;
    String? fileName;

    if (_posterImage != null) {
      List<int> imageBytes = await _posterImage!.readAsBytes();
      base64Image = base64Encode(imageBytes);
      fileName = p.basename(_posterImage!.path);
    }

    Map<String, dynamic> eventData = {
      "title": nameController.text,
      "description": introController.text,
      "venue": locationController.text,
      "event_date": dateController.text,
      "event_time": timeController.text,
      "available_seats": _calculateTotalSeats(),
      "rows": int.tryParse(rowController.text) ?? 0,
      "cols": int.tryParse(colController.text) ?? 0,
      "poster_image": base64Image,
      "poster_name": fileName,
    };

    try {
      var response = await http.post(
        Uri.parse("http://192.168.1.6/event_management/api/add_event.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(eventData),
      );

      var jsonResponse = jsonDecode(response.body);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(jsonResponse["message"] ?? "Unknown error")),
        );
        if (jsonResponse["success"] == true) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error adding show. Please try again.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add New Show")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Enter Show Details", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                _buildTextField(nameController, "Show Name"),
                _buildTextField(introController, "Introduction", maxLines: 3),
                _buildDatePicker(dateController, "Select Date"),
                _buildTimePicker(timeController, "Select Time"),
                _buildTextField(locationController, "Location"),
                _buildTextField(rowController, "Number of Rows", isNumeric: true),
                _buildTextField(colController, "Number of Columns", isNumeric: true),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Total Seats: ${_calculateTotalSeats()}",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 15),
                Center(
                  child: Column(
                    children: [
                      _posterImage != null
                          ? Image.file(_posterImage!, height: 150)
                          : const Text("No Image Selected"),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.image),
                        label: const Text("Select Poster"),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitShow,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      child: const Text("Add Show"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isNumeric = false, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        maxLines: maxLines,
        validator: (value) => value!.isEmpty ? "$label is required" : null,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildDatePicker(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        validator: (value) => value!.isEmpty ? "Date is required" : null,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2022),
            lastDate: DateTime(2030),
          );
          if (pickedDate != null && mounted) {
            setState(() {
              controller.text = "${pickedDate.toLocal()}".split(' ')[0];
            });
          }
        },
      ),
    );
  }

  Widget _buildTimePicker(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        validator: (value) => value!.isEmpty ? "Time is required" : null,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        onTap: () async {
          TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );
          if (pickedTime != null && mounted) {
            setState(() {
              controller.text = pickedTime.format(context);
            });
          }
        },
      ),
    );
  }
}
