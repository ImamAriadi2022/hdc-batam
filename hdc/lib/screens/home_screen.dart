import 'package:flutter/material.dart';
import 'dart:math';
import '../widgets/report_list_widget.dart';
import '../utils/dummy_data.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Contoh data statistik
    final int totalReports = dummyReports.length;
    final int siaga1Reports = dummyReports.where((report) => report['tingkatSiaga'] == '1').length;
    final int siaga2Reports = dummyReports.where((report) => report['tingkatSiaga'] == '2').length;
    final int siaga3Reports = dummyReports.where((report) => report['tingkatSiaga'] == '3').length;

    final List<Map<String, dynamic>> notifications = [
      {'judul': 'Notifikasi 1', 'deskripsi': 'Deskripsi Notifikasi 1', 'dibaca': false},
      {'judul': 'Notifikasi 2', 'deskripsi': 'Deskripsi Notifikasi 2', 'dibaca': true},
      {'judul': 'Notifikasi 3', 'deskripsi': 'Deskripsi Notifikasi 3', 'dibaca': false},
    ];

    void showNotifications(BuildContext context) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return DraggableScrollableSheet(
            initialChildSize: 0.5,
            maxChildSize: 0.8,
            minChildSize: 0.3,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return ListTile(
                      title: Text(notification['judul']),
                      subtitle: Text(notification['deskripsi']),
                      trailing: Icon(
                        notification['dibaca'] ? Icons.check_circle : Icons.circle,
                        color: notification['dibaca'] ? Colors.green : Colors.red,
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0097B2),
        title: Row(
          children: [
            Image.asset(
              'assets/logo/logo.png', // Path to your logo
              height: 100,
            ),
            SizedBox(width: 10),
            Text('Beranda'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              showNotifications(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian Statistik
            Center(
              child: CustomPaint(
                size: Size(200, 200),
                painter: PieChartPainter(
                  totalReports: totalReports,
                  siaga1Reports: siaga1Reports,
                  siaga2Reports: siaga2Reports,
                  siaga3Reports: siaga3Reports,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Laporan Terbaru',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ReportListWidget(reports: dummyReports),
            ),
          ],
        ),
      ),
    );
  }
}

class PieChartPainter extends CustomPainter {
  final int totalReports;
  final int siaga1Reports;
  final int siaga2Reports;
  final int siaga3Reports;

  PieChartPainter({
    required this.totalReports,
    required this.siaga1Reports,
    required this.siaga2Reports,
    required this.siaga3Reports,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    final double totalAngle = 2 * 3.141592653589793;
    final double siaga1Angle = (siaga1Reports / totalReports) * totalAngle;
    final double siaga2Angle = (siaga2Reports / totalReports) * totalAngle;
    final double siaga3Angle = (siaga3Reports / totalReports) * totalAngle;
    final double totalAnglePart = (totalReports / totalReports) * totalAngle;

    double startAngle = -3.141592653589793 / 2;

    paint.color = Colors.blue;
    canvas.drawArc(Rect.fromLTWH(0, 0, size.width, size.height), startAngle, totalAnglePart, true, paint);
    _drawText(canvas, size, startAngle, totalAnglePart, 'Total: $totalReports', Colors.white);
    startAngle += totalAnglePart;

    paint.color = Colors.red;
    canvas.drawArc(Rect.fromLTWH(0, 0, size.width, size.height), startAngle, siaga1Angle, true, paint);
    _drawText(canvas, size, startAngle, siaga1Angle, 'Siaga 1: $siaga1Reports', Colors.white);
    startAngle += siaga1Angle;

    paint.color = Colors.yellow;
    canvas.drawArc(Rect.fromLTWH(0, 0, size.width, size.height), startAngle, siaga2Angle, true, paint);
    _drawText(canvas, size, startAngle, siaga2Angle, 'Siaga 2: $siaga2Reports', Colors.black);
    startAngle += siaga2Angle;

    paint.color = Colors.green;
    canvas.drawArc(Rect.fromLTWH(0, 0, size.width, size.height), startAngle, siaga3Angle, true, paint);
    _drawText(canvas, size, startAngle, siaga3Angle, 'Siaga 3: $siaga3Reports', Colors.white);
  }

  void _drawText(Canvas canvas, Size size, double startAngle, double sweepAngle, String text, Color color) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: 12,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    final double radius = size.width / 2;
    final double angle = startAngle + sweepAngle / 2;
    final Offset offset = Offset(
      radius + radius * 0.5 * cos(angle) - textPainter.width / 2,
      radius + radius * 0.5 * sin(angle) - textPainter.height / 2,
    );

    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}