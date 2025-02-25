import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class GenRepReportPage extends StatelessWidget {
  final String reportType;
  final String timeframe;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? selectedMonth;
  final List<String> showNames;
  final List<int> ticketSales;
  final List<int> revenue;

  // ✅ Define as class fields
  late final int totalTicketSales;
  late final int totalRevenue;
  final int maxSeatOccupancy = 500;
  late final double seatOccupancyPercentage;

  GenRepReportPage({
    required this.reportType,
    required this.timeframe,
    this.startDate,
    this.endDate,
    this.selectedMonth,
    required this.showNames,
    required this.ticketSales,
    required this.revenue,
  }) {
    // ✅ Initialize these values in the constructor
    totalTicketSales = ticketSales.reduce((a, b) => a + b);
    totalRevenue = revenue.reduce((a, b) => a + b);
    seatOccupancyPercentage = (totalTicketSales / maxSeatOccupancy).clamp(0, 1);
  }

  @override
  Widget build(BuildContext context) {
    double maxY = ([...ticketSales, ...revenue].reduce((a, b) => a > b ? a : b)) * 1.2;

    return Scaffold(
      appBar: AppBar(title: Text('Generated Report')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Report Type: $reportType', style: TextStyle(fontSize: 18)),
            if (timeframe == 'Daily' || timeframe == 'Weekly')
              Text('Date Range: ${startDate?.toLocal()} - ${endDate?.toLocal()}', style: TextStyle(fontSize: 16)),
            if (timeframe == 'Monthly')
              Text('Selected Month: ${selectedMonth?.toLocal()}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Expanded(
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxY,
                  barGroups: List.generate(
                    showNames.length,
                        (index) => BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: ticketSales[index].toDouble(),
                          color: Colors.blue,
                          width: 15,
                        ),
                        BarChartRodData(
                          toY: revenue[index].toDouble(),
                          color: Colors.green,
                          width: 15,
                        ),
                      ],
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) => Text(value.toInt().toString()),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          int index = value.toInt();
                          if (index >= 0 && index < showNames.length) {
                            return Transform.rotate(
                              angle: -0.5,
                              child: Text(
                                showNames[index],
                                style: TextStyle(fontSize: 10),
                              ),
                            );
                          }
                          return Text('');
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  gridData: FlGridData(show: true),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Indicator(color: Colors.blue, text: 'Ticket Sales'),
                SizedBox(width: 20),
                Indicator(color: Colors.green, text: 'Revenue'),
              ],
            ),
            SizedBox(height: 30),
            Text("Revenue Breakdown", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Total Ticket Sales: $totalTicketSales", style: TextStyle(fontSize: 16)),
            Text("Total Revenue: \$${totalRevenue.toStringAsFixed(2)}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text("Total Seat Occupancy: $totalTicketSales / $maxSeatOccupancy seats", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text("Occupancy Rate: ${(seatOccupancyPercentage * 100).toStringAsFixed(1)}%", style: TextStyle(fontSize: 16)),
            SizedBox(height: 5),
            LinearProgressIndicator(
              value: seatOccupancyPercentage,
              backgroundColor: Colors.grey[300],
              color: Colors.orange,
              minHeight: 10,
            ),
            SizedBox(height: 20),

            // PDF Report Button
            Center(
              child: ElevatedButton(
                onPressed: () => _generatePDFReport(context),
                child: Text("Generate PDF Report"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _generatePDFReport(BuildContext context) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Generated Report', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Text('Report Type: $reportType', style: pw.TextStyle(fontSize: 18)),
            if (timeframe == 'Daily' || timeframe == 'Weekly')
              pw.Text('Date Range: ${startDate?.toLocal()} - ${endDate?.toLocal()}'),
            if (timeframe == 'Monthly') pw.Text('Selected Month: ${selectedMonth?.toLocal()}'),
            pw.SizedBox(height: 10),
            pw.Text("Total Ticket Sales: $totalTicketSales", style: pw.TextStyle(fontSize: 16)),
            pw.Text("Total Revenue: \$${totalRevenue.toStringAsFixed(2)}", style: pw.TextStyle(fontSize: 16)),
            pw.SizedBox(height: 10),
            pw.Text("Total Seat Occupancy: $totalTicketSales / $maxSeatOccupancy seats"),
            pw.Text("Occupancy Rate: ${(seatOccupancyPercentage * 100).toStringAsFixed(1)}%"),
            pw.SizedBox(height: 10),
            pw.Divider(),
            pw.Text("Show Breakdown", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 5),
            pw.Column(
              children: List.generate(
                showNames.length,
                    (index) => pw.Text("${showNames[index]} - Sales: ${ticketSales[index]}, Revenue: \$${revenue[index]}"),
              ),
            ),
          ],
        ),
      ),
    );

    try {
      // ✅ Save the PDF file
      File savedFile = await _savePdf(pdf);

      // ✅ Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("PDF Saved at ${savedFile.path}")),
      );

      // ✅ Open the saved PDF file
      Future.delayed(Duration(seconds: 1), () {
        OpenFile.open(savedFile.path);
      });
    } catch (e) {
      // Handle errors if opening fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to open PDF: $e")),
      );
    }
  }



  Future<File> _savePdf(pw.Document pdf) async {
    final directory = await getExternalStorageDirectory(); // ✅ Get external storage
    final path = "${directory?.path}/generated_report.pdf";
    final file = File(path);
    await file.writeAsBytes(await pdf.save());
    return file;
  }

}


class Indicator extends StatelessWidget {
  final Color color;
  final String text;

  Indicator({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 12, height: 12, color: color),
        SizedBox(width: 5),
        Text(text, style: TextStyle(fontSize: 14)),
      ],
    );
  }
}
