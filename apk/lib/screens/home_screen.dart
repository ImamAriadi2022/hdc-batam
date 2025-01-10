import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _laporanList = [];
  List<Map<String, dynamic>> _notifications = [];
  int siaga1 = 0;
  int siaga2 = 0;
  int siaga3 = 0;

  @override
  void initState() {
    super.initState();
    _fetchLaporan();
    _fetchNotifications();
  }



  Future<void> _fetchLaporan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');

    final response = await http.get(
      Uri.parse('http://192.168.1.4:5000/api/reports'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      setState(() {
        _laporanList = List<Map<String, dynamic>>.from(data);

      
      print('Data dari api: $_laporanList');
     

      // Cetak jumlah laporan berdasarkan tingkat siaga
      siaga1 = 0;
      siaga2 = 0;
      siaga3 = 0;

      for (var laporan in _laporanList) {
        int tingkatSiaga = int.parse(laporan['tingkatSiaga'].toString());
        print('Tingkat Siaga: $tingkatSiaga (type: ${tingkatSiaga.runtimeType})'); // Debug print for tingkatSiaga

        if (tingkatSiaga == 1) {
          siaga1++;
        } else if (tingkatSiaga == 2) {
          siaga2++;
        } else if (tingkatSiaga == 3) {
          siaga3++;
        }
      }

      print('Jumlah laporan siaga 1: $siaga1');
      print('Jumlah laporan siaga 2: $siaga2');
      print('Jumlah laporan siaga 3: $siaga3');
    });
    } else {
      print('Failed to load laporan');
    }
  }

  Future<void> _fetchNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');

    final response = await http.get(
      Uri.parse('http://192.168.1.4:5000/api/notifications'),
      headers: {
        'Authorization': 'Bearer $token',
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

  void _showLaporanDetailDialog(BuildContext context, Map<String, dynamic> laporan) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Detail Laporan'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Tingkat Siaga: ${laporan['tingkatSiaga'] ?? 'N/A'}'),
                Text('Deskripsi: ${laporan['deskripsi'] ?? 'N/A'}'),
                Text('Lokasi: ${laporan['lokasi'] ?? 'N/A'}'),
                Text('Jumlah Penumpang: ${laporan['jumlahPenumpang'] ?? 'N/A'}'),
                Text('Jenis Pesawat: ${laporan['jenisPesawat'] ?? 'N/A'}'),
                Text('Status Ancaman: ${laporan['statusAncaman'] ?? 'N/A'}'),
                if (laporan['imagePath'] != null && laporan['imagePath'].isNotEmpty)
                  Image.network('http://192.168.1.4:5000${laporan['imagePath']}', height: 100, width: 100, fit: BoxFit.cover)
                else
                  Text('Laporan ini tidak ada lampiran fotonya'),
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
              child: _notifications.isEmpty
                  ? Center(child: Text('Tidak ada notifikasi terbaru'))
                  : ListView.builder(
                      controller: scrollController,
                      itemCount: _notifications.length,
                      itemBuilder: (context, index) {
                        final notification = _notifications[index];
                        return ListTile(
                          title: Text(notification['message'] ?? 'No Title'),
                          trailing: Icon(
                            notification['isRead'] == true ? Icons.check_circle : Icons.circle,
                            color: notification['isRead'] == true ? Colors.green : Colors.red,
                          ),
                          onTap: () async {
                            await _markNotificationAsRead(notification['id']);
                            setState(() {
                              _notifications.removeAt(index);
                            });
                          },
                        );
                      },
                    ),
            );
          },
        );
      },
    );
  }

  Future<void> _markNotificationAsRead(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');

    final response = await http.put(
      Uri.parse('http://192.168.1.4:5000/api/notifications/$id/read'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        _notifications.removeWhere((notification) => notification['id'] == id);
      });
      _showFeedbackDialog(context, 'Terima kasih telah membaca notifikasi ini');
    
    } else {
      print('Failed to mark notification as read');
    }
  }

  void _showFeedbackDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Feedback'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Statistik Laporan',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              _buildStatistikLaporan(),
              SizedBox(height: 32),
              Text(
                'Laporan Terbaru',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              _buildLaporanTerbaru(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatistikLaporan() {
    if (_laporanList.isEmpty) {
      return Center(child: Text('Tidak ada laporan'));
    }

    int totalLaporan = _laporanList.length;

    return CircularStatsWidget(
      totalReports: totalLaporan,
      siaga1Reports: siaga1,
      siaga2Reports: siaga2,
      siaga3Reports: siaga3,
    );
  }

  Widget _buildLaporanTerbaru() {
    if (_laporanList.isEmpty) {
      return Center(child: Text('Tidak ada laporan terbaru'));
    }

    final laporanTerbaru = _laporanList.first;

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
                    'Siaga ${laporanTerbaru['tingkatSiaga']}',
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
                        color: i < int.parse(laporanTerbaru['tingkatSiaga'].toString()) ? getSiagaColor(int.parse(laporanTerbaru['tingkatSiaga'].toString())) : Colors.grey,
                      ),
                    );
                  }),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              laporanTerbaru['deskripsi'],
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
                    laporanTerbaru['lokasi'],
                    style: TextStyle(fontSize: 12, color: Colors.black45),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _showLaporanDetailDialog(context, laporanTerbaru);
                  },
                  child: Text('Lihat Lebih Banyak'),
                ),
              ],
            ),
          ],
        ),
      ),
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

    final double siaga1Angle = totalReports > 0 ? (siaga1Reports / totalReports) * 2 * pi : 0.0;
    final double siaga2Angle = totalReports > 0 ? (siaga2Reports / totalReports) * 2 * pi : 0.0;
    final double siaga3Angle = totalReports > 0 ? (siaga3Reports / totalReports) * 2 * pi : 0.0;

    paint.color = Colors.blue;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2, siaga1Angle, false, paint);

    paint.color = Colors.yellow;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2 + siaga1Angle, siaga2Angle, false, paint);

    paint.color = Colors.red;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2 + siaga1Angle + siaga2Angle, siaga3Angle, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}