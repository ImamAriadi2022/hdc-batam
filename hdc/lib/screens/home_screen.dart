import 'package:flutter/material.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _laporanList = [];
  List<Map<String, dynamic>> _notifications = [];
  String user = "User"; // Ganti dengan nama user yang sesuai

  @override
  void initState() {
    super.initState();
    _fetchLaporan();
    _fetchNotifications();
  }

  Future<void> _fetchLaporan() async {
    final response = await http.get(
      Uri.parse('http://192.168.1.4:5000/api/reports'),
      headers: {
        'Authorization': 'Bearer imam123',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        _laporanList = List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    } else {
      print('Failed to load laporan');
    }
  }

  Future<void> _fetchNotifications() async {
    final response = await http.get(
      Uri.parse('http://192.168.1.4:5000/api/notifications'),
      headers: {
        'Authorization': 'Bearer imam123',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        _notifications = List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    } else {
      print('Failed to load notifications');
    }
  }

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
                itemCount: _notifications.length,
                itemBuilder: (context, index) {
                  final notification = _notifications[index];
                  return ListTile(
                    title: Text(notification['judul']),
                    subtitle: Text(notification['deskripsi']),
                    trailing: Icon(
                      notification['isRead'] ? Icons.check_circle : Icons.circle,
                      color: notification['isRead'] ? Colors.green : Colors.red,
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

  Color getSiagaColor(int tingkatSiaga) {
    switch (tingkatSiaga) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.yellow;
      case 3:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void showDetailDialog(BuildContext context, Map<String, dynamic> laporan) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Detail Laporan'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Tingkat Siaga: ${laporan['tingkatSiaga']}'),
                Text('Deskripsi: ${laporan['deskripsi']}'),
                Text('Lokasi: ${laporan['lokasi']}'),
                Text('Jumlah Penumpang: ${laporan['jumlahPenumpang']}'),
                Text('Jenis Pesawat: ${laporan['jenisPesawat']}'),
                Text('Status Ancaman: ${laporan['statusAncaman']}'),
                if (laporan['imageFile'] != null)
                  Image.memory(base64Decode(laporan['imageFile']), height: 100, width: 100, fit: BoxFit.cover),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final int totalReports = _laporanList.length;
    final int siaga1Reports = _laporanList.where((report) => report['tingkatSiaga'] == '1').length;
    final int siaga2Reports = _laporanList.where((report) => report['tingkatSiaga'] == '2').length;
    final int siaga3Reports = _laporanList.where((report) => report['tingkatSiaga'] == '3').length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0097B2),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Selamat Datang $user',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            CircularStatsWidget(
              totalReports: totalReports,
              siaga1Reports: siaga1Reports,
              siaga2Reports: siaga2Reports,
              siaga3Reports: siaga3Reports,
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _laporanList.length,
                itemBuilder: (context, index) {
                  final laporan = _laporanList[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  laporan['judul'] ?? 'Judul tidak tersedia',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Row(
                                children: List.generate(3, (i) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                    child: Icon(
                                      Icons.circle,
                                      size: 12,
                                      color: i < int.parse(laporan['tingkatSiaga'] ?? '0') ? getSiagaColor(int.parse(laporan['tingkatSiaga'] ?? '0')) : Colors.grey,
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            laporan['deskripsi'] ?? 'Deskripsi tidak tersedia',
                            style: TextStyle(color: Colors.black54),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  'Rabu, 24-10-2040 Pukul 20.00 WIB',
                                  style: TextStyle(fontSize: 12, color: Colors.black45),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  showDetailDialog(context, laporan);
                                },
                                child: Text('Lihat Lebih Banyak'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
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

  const CircularStatsWidget({super.key, 
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
        CustomPaint(
          size: Size(200, 200),
          painter: CircularChartPainter(
            totalReports: totalReports,
            siaga1Reports: siaga1Reports,
            siaga2Reports: siaga2Reports,
            siaga3Reports: siaga3Reports,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$totalReports',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text('Total Laporan'),
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
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;

    final radius = min(size.width / 2, size.height / 2);
    final center = Offset(size.width / 2, size.height / 2);

    final siaga1Angle = (siaga1Reports / totalReports) * 2 * pi;
    final siaga2Angle = (siaga2Reports / totalReports) * 2 * pi;
    final siaga3Angle = (siaga3Reports / totalReports) * 2 * pi;

    paint.color = Colors.red;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2, siaga1Angle, false, paint);

    paint.color = Colors.yellow;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2 + siaga1Angle, siaga2Angle, false, paint);

    paint.color = Colors.green;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2 + siaga1Angle + siaga2Angle, siaga3Angle, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}