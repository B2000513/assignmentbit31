import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;

class GenMainReport extends StatefulWidget {
  @override
  _GenMainReportState createState() => _GenMainReportState();
}

class _GenMainReportState extends State<GenMainReport> {
  final String apiUrl = "http://192.168.100.22/event_management/api/fetch_report.php";

  List<EventReport> reports = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchReportData();
  }

  Future<void> fetchReportData() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          reports = data.map((e) => EventReport.fromJson(e)).toList();
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load data");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "Error loading report: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Event Reports")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage.isNotEmpty
            ? Center(child: Text(errorMessage, style: const TextStyle(color: Colors.red)))
            : ListView(
          children: [
            _buildChartSection("Ticket Sales", _buildBarChart(reports.map((e) => e.ticketSales).toList(), Colors.blue)),
            _buildChartSection("Revenue", _buildBarChart(reports.map((e) => e.revenue.toInt()).toList(), Colors.green)),
            ...reports.map((e) => _buildChartSection(e.eventName, _buildPieChart(e))),
          ],
        ),
      ),
    );
  }

  Widget _buildChartSection(String title, Widget chart) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            SizedBox(height: 300, child: chart),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart(List<int> data, Color color) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: (data.isNotEmpty ? data.reduce((a, b) => a > b ? a : b) : 1) * 1.2,
        barGroups: List.generate(
          reports.length,
              (index) => BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(toY: data[index].toDouble(), color: color, width: 20, borderRadius: BorderRadius.circular(6)),
            ],
          ),
        ),
        titlesData: _getTitlesData(),
        borderData: FlBorderData(show: false),
      ),
    );
  }

  Widget _buildPieChart(EventReport report) {
    int booked = report.bookedSeats;
    int available = report.totalSeats - booked;
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            value: booked.toDouble(),
            title: "$booked Booked",
            color: Colors.blue,
            radius: 80,
            titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          PieChartSectionData(
            value: available.toDouble(),
            title: "$available Available",
            color: Colors.green,
            radius: 80,
            titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
        sectionsSpace: 2,
        centerSpaceRadius: 40,
      ),
    );
  }

  FlTitlesData _getTitlesData() {
    return FlTitlesData(
      leftTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: true, reservedSize: 40),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            int index = value.toInt();
            return index >= 0 && index < reports.length
                ? Transform.rotate(angle: -0.5, child: Text(reports[index].eventName, style: TextStyle(fontSize: 10)))
                : const Text('');
          },
        ),
      ),
    );
  }
}

class EventReport {
  final String eventName;
  final int ticketSales;
  final double revenue;
  final int bookedSeats;
  final int totalSeats;

  EventReport({
    required this.eventName,
    required this.ticketSales,
    required this.revenue,
    required this.bookedSeats,
    required this.totalSeats,
  });

  factory EventReport.fromJson(Map<String, dynamic> json) {
    return EventReport(
      eventName: json['event_name'].toString(),
      ticketSales: int.tryParse(json['ticket_sales'].toString()) ?? 0,
      revenue: double.tryParse(json['revenue'].toString()) ?? 0.0,
      bookedSeats: int.tryParse(json['booked_seats'].toString()) ?? 0,
      totalSeats: int.tryParse(json['total_seats'].toString()) ?? 0,
    );
  }
}
