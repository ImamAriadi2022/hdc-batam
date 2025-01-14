import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; // Tambahkan import untuk intl
import 'package:shared_preferences/shared_preferences.dart';

class LaporanSayaScreen extends StatefulWidget {
  const LaporanSayaScreen({super.key});

  @override
  State<LaporanSayaScreen> createState() => _LaporanSayaScreenState();
}

class _LaporanSayaScreenState extends State<LaporanSayaScreen> {
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
    int? userId = prefs.getInt('user_id');

    print('Fetching laporan for user_id: $userId'); // Debug log

    final response = await http.get(
      Uri.parse('https://teralab.my.id/hdcback/api/reports'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    print('Response status: ${response.statusCode}'); // Debug log
    print('Response body: ${response.body}'); // Debug log

    if (response.statusCode == 200) {
      List<Map<String, dynamic>> allLaporan = List<Map<String, dynamic>>.from(json.decode(response.body));
      setState(() {
        _laporanList = allLaporan.where((laporan) => laporan['userId'] == userId).toList();
        // Urutkan laporan berdasarkan ID dalam urutan menurun
        _laporanList.sort((a, b) => b['id'].compareTo(a['id']));
        print('Laporan Saya: $_laporanList'); // Debug log
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
  
    final response = await http.delete(
      Uri.parse('https://teralab.my.id/hdcback/api/notifications/$id'),
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
      print('Failed to delete notification');
    }
  }

  Future<void> _editLaporan(Map<String, dynamic> laporan) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');

    final response = await http.put(
      Uri.parse('https://teralab.my.id/hdcback/api/reports/${laporan['id']}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(laporan),
    );

    if (response.statusCode == 200) {
      setState(() {
        _laporanList = _laporanList.map((item) {
          if (item['id'] == laporan['id']) {
            return laporan;
          }
          return item;
        }).toList();
      });
      _showFeedbackDialog(context, 'Laporan berhasil diubah!');
    } else {
      print('Failed to edit laporan');
    }
  }

  Future<void> _deleteLaporan(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');

    final response = await http.delete(
      Uri.parse('https://teralab.my.id/hdcback/api/reports/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        _laporanList.removeWhere((item) => item['id'] == id);
      });
      _showFeedbackDialog(context, 'Laporan berhasil dihapus!');
    } else {
      print('Failed to delete laporan');
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
                  Image.network('https://teralab.my.id/hdcback/${laporan['imagePath']}', height: 100, width: 100, fit: BoxFit.cover)
                else
                  Text('Laporan ini tidak ada lampiran fotonya'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Edit'),
              onPressed: () {
                Navigator.of(context).pop();
                _showEditLaporanDialog(context, laporan);
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteLaporan(laporan['id']);
              },
            ),
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

  void _showEditLaporanDialog(BuildContext context, Map<String, dynamic> laporan) {
    final formKey = GlobalKey<FormState>();
    String? tingkatSiaga = laporan['tingkatSiaga'].toString();
    String deskripsi = laporan['deskripsi'];
    String lokasi = laporan['lokasi'];
    String jumlahPenumpang = laporan['jumlahPenumpang'].toString();
    String jenisPesawat = laporan['jenisPesawat'];
    String statusAncaman = laporan['statusAncaman'];
    File? imageFile;

    Future<void> pickImage(ImageSource source) async {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          imageFile = File(pickedFile.path);
        });
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Laporan'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Tingkat Siaga',
                      border: OutlineInputBorder(),
                    ),
                    value: tingkatSiaga,
                    items: ['1', '2', '3'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        tingkatSiaga = value;
                      });
                    },
                    validator: (value) => value == null ? 'Pilih tingkat siaga' : null,
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    initialValue: deskripsi,
                    decoration: const InputDecoration(
                      labelText: 'Masukkan Deskripsi Laporan',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    validator: (value) => value!.isEmpty ? 'Deskripsi harus diisi' : null,
                    onChanged: (value) {
                      deskripsi = value;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    initialValue: lokasi,
                    decoration: const InputDecoration(
                      labelText: 'Masukkan Lokasi Kejadian',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value!.isEmpty ? 'Lokasi harus diisi' : null,
                    onChanged: (value) {
                      lokasi = value;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    initialValue: jumlahPenumpang,
                    decoration: const InputDecoration(
                      labelText: 'Masukkan Jumlah Penumpang',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty ? 'Jumlah penumpang harus diisi' : null,
                    onChanged: (value) {
                      jumlahPenumpang = value;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    initialValue: jenisPesawat,
                    decoration: const InputDecoration(
                      labelText: 'Masukkan Jenis Pesawat',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value!.isEmpty ? 'Jenis pesawat harus diisi' : null,
                    onChanged: (value) {
                      jenisPesawat = value;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  const Text('Status Ancaman:'),
                  RadioListTile(
                    title: const Text('Aktif'),
                    value: 'Aktif',
                    groupValue: statusAncaman,
                    onChanged: (value) {
                      setState(() {
                        statusAncaman = value.toString();
                      });
                    },
                  ),
                  RadioListTile(
                    title: const Text('Terkendali'),
                    value: 'Terkendali',
                    groupValue: statusAncaman,
                    onChanged: (value) {
                      setState(() {
                        statusAncaman = value.toString();
                      });
                    },
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            pickImage(ImageSource.gallery);
                          },
                          child: const Text('Upload Foto'),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            pickImage(ImageSource.camera);
                          },
                          child: const Text('Ambil Foto'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  if (imageFile != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Image.file(imageFile!, height: 100, width: 100, fit: BoxFit.cover),
                    ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Save'),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  setState(() {
                    laporan['tingkatSiaga'] = int.parse(tingkatSiaga!);
                    laporan['deskripsi'] = deskripsi;
                    laporan['lokasi'] = lokasi;
                    laporan['jumlahPenumpang'] = int.parse(jumlahPenumpang);
                    laporan['jenisPesawat'] = jenisPesawat;
                    laporan['statusAncaman'] = statusAncaman;
                    if (imageFile != null) {
                      laporan['imageFile'] = base64Encode(imageFile!.readAsBytesSync());
                    }
                  });
                  Navigator.of(context).pop();
                  _editLaporan(laporan);
                }
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
                          notification['isRead'] == true
                              ? Icons.check_circle
                              : Icons.circle,
                          color: notification['isRead'] == true
                              ? Colors.green
                              : Colors.red,
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

  String _formatDate(String dateStr) {
    try {
      print('Parsing date: $dateStr'); // Log date string before parsing
      final dateTime = DateTime.parse(dateStr).toUtc().add(Duration(hours: 7)); // Convert to UTC and then add 7 hours for WIB
      final formattedDate = DateFormat('EEE, dd MMM yyyy, HH:mm').format(dateTime); // Format with day, date, month, year, and time
      print('Formatted date: $formattedDate'); // Log formatted date
      return formattedDate;
    } catch (e) {
      print('Error parsing date: $e');
      return 'N/A';
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
                    'Dibuat pada: ${_formatDate(laporan['createdAt'] ?? 'N/A')}',
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