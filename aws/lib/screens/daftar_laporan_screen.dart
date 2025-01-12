import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; // Tambahkan import untuk intl

class DaftarLaporanScreen extends StatefulWidget {
  const DaftarLaporanScreen({super.key});

  @override
  State<DaftarLaporanScreen> createState() => _DaftarLaporanScreenState();
}

class _DaftarLaporanScreenState extends State<DaftarLaporanScreen> {
  List<Map<String, dynamic>> _laporanList = [];
  List<Map<String, dynamic>> _notifications = [];

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
      Uri.parse('https://teralab.my.id/hdcback/api/reports'),
      headers: {
        'Authorization': 'Bearer $token',
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');

    final response = await http.get(
      Uri.parse('https://teralab.my.id/hdcback/api/notifications'),
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

  Future<void> _markNotificationAsRead(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');

    final response = await http.put(
      Uri.parse('https://teralab.my.id/hdcback/api/notifications/$id/read'),
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
                  Image.network('https://teralab.my.id/hdcback/${laporan['imagePath']}', height: 100, width: 100, fit: BoxFit.cover)
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

  String _formatDate(String dateStr) {
    try {
      final dateTime = DateTime.parse(dateStr);
      return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
    } catch (e) {
      print('Error parsing date: $e');
      return 'N/A';
    }
  }

  Color getSiagaColor(int tingkatSiaga) {
    switch (tingkatSiaga) {
      case 1:
        return Colors.blue;
      case 2:
        return Colors.yellow;
      case 3:
        return Colors.red;
      default:
        return Colors.grey;
    }
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
      body: ListView.builder(
        itemCount: _laporanList.length,
        itemBuilder: (context, index) {
          final laporan = _laporanList[index];
          // Cari notifikasi yang sesuai dengan laporan
          final notification = _notifications.firstWhere(
            (notif) => notif['message']?.contains('Laporan baru dengan tingkat siaga ${laporan['tingkatSiaga']}') ?? false,
            orElse: () => {},
          );

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
                          'Siaga ${laporan['tingkatSiaga']}',
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
                              color: i < int.parse(laporan['tingkatSiaga'].toString()) ? getSiagaColor(int.parse(laporan['tingkatSiaga'].toString())) : Colors.grey,
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    laporan['deskripsi'],
                    style: TextStyle(color: Colors.black54),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Dibuat pada: ${_formatDate(notification['createdAt'] ?? 'N/A')}',
                    style: TextStyle(color: Colors.black54),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          laporan['lokasi'],
                          style: TextStyle(fontSize: 12, color: Colors.black45),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          _showLaporanDetailDialog(context, laporan);
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
    );
  }
}