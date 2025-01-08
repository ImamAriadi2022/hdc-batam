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
              height: 30,
            ),
            SizedBox(width: 10),
            Text(''),
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
              child: CircularStatsWidget(
                totalReports: totalReports,
                siaga1Reports: siaga1Reports,
                siaga2Reports: siaga2Reports,
                siaga3Reports: siaga3Reports,
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

class CircularStatsWidget extends StatelessWidget {
  final int totalReports;
  final int siaga1Reports;
  final int siaga2Reports;
  final int siaga3Reports;

  const CircularStatsWidget({
    required this.totalReports,
    required this.siaga1Reports,
    required this.siaga2Reports,
    required this.siaga3Reports,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 200,
          height: 200,
          child: CustomPaint(
            painter: CircularChartPainter(
              totalReports: totalReports,
              siaga1Reports: siaga1Reports,
              siaga2Reports: siaga2Reports,
              siaga3Reports: siaga3Reports,
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.report,
              color: Colors.blueAccent,
              size: 50,
            ),
            SizedBox(height: 8),
            Text(
              'Total: $totalReports',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CircularChartPainter extends CustomPainter {
  final int totalReports;
  final int siaga1Reports;
  final int siaga2Reports;
  final int siaga3Reports;

  CircularChartPainter({
    required this.totalReports,
    required this.siaga1Reports,
    required this.siaga2Reports,
    required this.siaga3Reports,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double totalAngle = 2 * pi;
    final double siaga1Angle = (siaga1Reports / totalReports) * totalAngle;
    final double siaga2Angle = (siaga2Reports / totalReports) * totalAngle;
    final double siaga3Angle = (siaga3Reports / totalReports) * totalAngle;

    double startAngle = -pi / 2;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 40;

    // Siaga 1
    paint.color = Colors.red;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: 80),
      startAngle,
      siaga1Angle,
      false,
      paint,
    );

    // Siaga 2
    paint.color = Colors.yellow;
    startAngle += siaga1Angle;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: 80),
      startAngle,
      siaga2Angle,
      false,
      paint,
    );

    // Siaga 3
    paint.color = Colors.green;
    startAngle += siaga2Angle;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: 80),
      startAngle,
      siaga3Angle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
