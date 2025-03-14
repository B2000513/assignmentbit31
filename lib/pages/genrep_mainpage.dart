import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../pages/genrep_report.dart';

class GenRepMainPage extends StatefulWidget {
  const GenRepMainPage({super.key});

  @override
  _GenerateReportMainPageState createState() => _GenerateReportMainPageState();
}

class _GenerateReportMainPageState extends State<GenRepMainPage> {
  String selectedReportType = "Ticket Sales"; // Default report type
  String selectedTimeframe = "Daily"; // Default timeframe
  DateTime? startDate;
  DateTime? endDate;
  DateTime? selectedMonth;

  // Function to show the date picker for Daily reports
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
        endDate = picked; // For daily reports, start and end date are the same
      });
    }
  }

  // Function to show the date range picker for Weekly reports
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
        lastDate: pickedStart.add(Duration(days: 6)), // Limit to 7 days max
      );
      if (pickedEnd != null) {
        setState(() {
          startDate = pickedStart;
          endDate = pickedEnd;
        });
      }
    }
  }

  // Function to show month picker (only year and month)
  Future<void> _selectMonth(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime initialDate = selectedMonth ?? now;

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light(),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedMonth = DateTime(picked.year, picked.month);
      });
    }
  }

  // Display selected date
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Generate Report")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Select Report Type", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: selectedReportType,
              isExpanded: true,
              items: ["Ticket Sales", "Revenue", "Seat Occupancy"].map((String report) {
                return DropdownMenuItem<String>(
                  value: report,
                  child: Text(report),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedReportType = value!;
                });
              },
            ),
            SizedBox(height: 20),
            Text("Select Timeframe", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: selectedTimeframe,
              isExpanded: true,
              items: ["Daily", "Weekly", "Monthly"].map((String timeframe) {
                return DropdownMenuItem<String>(
                  value: timeframe,
                  child: Text(timeframe),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedTimeframe = value!;
                  startDate = null;
                  endDate = null;
                  selectedMonth = null;
                });
              },
            ),
            SizedBox(height: 20),
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
              child: Text("Select Date"),
            ),
            SizedBox(height: 10),
            Text("Selected Date: ${getSelectedDateText()}"),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (selectedReportType.isEmpty || selectedTimeframe.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please select a report type and timeframe")),
                    );
                    return;
                  }

                  // Dummy data for now
                  List<String> showNames = ["Show A", "Show B", "Show C"];
                  List<int> ticketSales = [120, 95, 150];
                  List<int> revenue = [12000, 9500, 15000];

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GenRepReportPage(
                        reportType: selectedReportType,
                        timeframe: selectedTimeframe,
                        startDate: startDate,
                        endDate: endDate,
                        selectedMonth: selectedMonth,
                        showNames: showNames,
                        ticketSales: ticketSales,
                        revenue: revenue,
                      ),
                    ),
                  );
                },
                child: const Text("Generate Report"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
