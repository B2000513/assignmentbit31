import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'genrep_report.dart';

class GenRepMainPage extends StatefulWidget {
  const GenRepMainPage({super.key});

  @override
  _GenRepMainPageState createState() => _GenRepMainPageState();
}

class _GenRepMainPageState extends State<GenRepMainPage> {
  String selectedReportType = "Ticket Sales";
  String selectedTimeframe = "Daily";
  DateTime? startDate;
  DateTime? endDate;
  DateTime? selectedMonth;
  bool isLoading = false;

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        startDate = picked;
        endDate = picked;
      });
    }
  }

  Future<void> _selectWeek(BuildContext context) async {
    DateTime? pickedStart = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedStart != null) {
      DateTime? pickedEnd = await showDatePicker(
        context: context,
        initialDate: pickedStart,
        firstDate: pickedStart,
        lastDate: pickedStart.add(const Duration(days: 6)),
      );
      if (pickedEnd != null) {
        setState(() {
          startDate = pickedStart;
          endDate = pickedEnd;
        });
      }
    }
  }

  Future<void> _selectMonth(BuildContext context) async {
    DateTime now = DateTime.now();
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 250,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(DateFormat('MMMM').format(DateTime(now.year, index + 1))),
                      onTap: () {
                        setState(() {
                          selectedMonth = DateTime(now.year, index + 1);
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String getSelectedDateText() {
    if (selectedTimeframe == "Daily" && startDate != null) {
      return DateFormat("yyyy-MM-dd").format(startDate!);
    } else if (selectedTimeframe == "Weekly" && startDate != null && endDate != null) {
      return "${DateFormat("yyyy-MM-dd").format(startDate!)} to ${DateFormat("yyyy-MM-dd").format(endDate!)}";
    } else if (selectedTimeframe == "Monthly" && selectedMonth != null) {
      return DateFormat("yyyy-MM").format(selectedMonth!);
    }
    return "No date selected";
  }

  Future<void> _fetchReportData() async {
    if (selectedReportType.isEmpty || selectedTimeframe.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a report type and timeframe")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    String apiUrl = "http://192.168.100.22/event_management/api/fetch_report.php";
    Map<String, String> params = {
      "reportType": selectedReportType,
      "timeframe": selectedTimeframe,
    };

    if (selectedTimeframe == "Daily" && startDate != null) {
      params["startDate"] = DateFormat("yyyy-MM-dd").format(startDate!);
    } else if (selectedTimeframe == "Weekly" && startDate != null && endDate != null) {
      params["startDate"] = DateFormat("yyyy-MM-dd").format(startDate!);
      params["endDate"] = DateFormat("yyyy-MM-dd").format(endDate!);
    } else if (selectedTimeframe == "Monthly" && selectedMonth != null) {
      params["selectedMonth"] = DateFormat("yyyy-MM").format(selectedMonth!);
    }

    try {
      final response = await http.post(Uri.parse(apiUrl), body: params);

      if (response.statusCode != 200) {
        throw Exception("Failed to fetch report data: ${response.body}");
      }

      final List<dynamic> data = jsonDecode(response.body);
      if (data.isEmpty) {
        throw Exception("No data available");
      }

      // ✅ Safe number parsing to avoid FormatException
      List<String> showNames = [];
      List<int> ticketSales = [];
      List<int> revenue = [];

      for (var event in data) {
        showNames.add(event['event_name'].toString());

        int tickets = int.tryParse(event['ticket_sales'].toString()) ?? 0;
        int rev = int.tryParse(event['revenue'].toString()) ?? 0;

        ticketSales.add(tickets);
        revenue.add(rev);
      }

      // ✅ Navigate to `GenMainReport` with the parsed data
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GenMainReport(

          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Generate Report")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Select Report Type", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: selectedReportType,
              isExpanded: true,
              items: ["Ticket Sales", "Revenue", "Seat Occupancy"].map((String report) {
                return DropdownMenuItem<String>(
                  value: report,
                  child: Text(report),
                );
              }).toList(),
              onChanged: (value) => setState(() => selectedReportType = value!),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (selectedTimeframe == "Daily") {
                  _selectDate(context);
                } else if (selectedTimeframe == "Weekly") {
                  _selectWeek(context);
                } else if (selectedTimeframe == "Monthly") {
                  _selectMonth(context);
                }
              },
              child: const Text("Select Date"),
            ),
            const SizedBox(height: 10),
            Text("Selected Date: ${getSelectedDateText()}"),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: isLoading ? null : _fetchReportData,
                child: isLoading ? const CircularProgressIndicator() : const Text("Generate Report"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
