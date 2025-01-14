import 'dart:convert';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../notification_controller.dart';

class TambahLaporanScreen extends StatefulWidget {
  const TambahLaporanScreen({super.key});

  @override
  State<TambahLaporanScreen> createState() => _TambahLaporanScreenState();
}

class _TambahLaporanScreenState extends State<TambahLaporanScreen> {
  final _formKey = GlobalKey<FormState>();
  String? tingkatSiaga;
  String deskripsi = '';
  String lokasi = '';
  String jumlahPenumpang = '';
  String jenisPesawat = '';
  String statusAncaman = '';
  bool setujuPernyataan = false;
  File? _imageFile;
  List<Map<String, dynamic>> _notifications = [];

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
    NotificationController.startListeningNotificationEvents();
  }

  Future<void> _fetchNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');

    if (token == null || _isTokenExpired(token)) {
      token = await _refreshToken();
      if (token != null) {
        prefs.setString('jwt_token', token);
      } else {
        // Handle token refresh failure
        return;
      }
    }

    final response = await http.get(
      Uri.parse('https://teralab.my.id/hdcback/api/notifications'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        _notifications =
            List<Map<String, dynamic>>.from(json.decode(response.body));
      });

      // Tampilkan notifikasi menggunakan Awesome Notifications
      for (var notification in _notifications) {
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: notification['id'],
            channelKey: 'messaging_channel',
            title: 'Notifikasi Baru',
            body: notification['message'],
            notificationLayout: NotificationLayout.BigText,
            largeIcon: 'resource://drawable/ic_stat_cupertino_icon',
            displayOnForeground: true,
            displayOnBackground: true,
          ),
          actionButtons: [
            NotificationActionButton(
              key: 'READ_NOTIFICATION',
              label: 'Baca Notifikasi',
            ),
          ],
        );
      }
    } else {
      print('Failed to load notifications');
    }
  }

  bool _isTokenExpired(String token) {
    // Implement token expiration check logic here
    return false;
  }

  Future<String?> _refreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? refreshToken = prefs.getString('refresh_token');

    if (refreshToken != null) {
      final response = await http.post(
        Uri.parse('https://teralab.my.id/hdcback/api/refresh-token'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'token': refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['accessToken'];
      } else {
        // Handle error
        return null;
      }
    }
    return null;
  }

  Future<void> _markNotificationAsRead(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');

    if (token == null || _isTokenExpired(token)) {
      token = await _refreshToken();
      if (token != null) {
        prefs.setString('jwt_token', token);
      } else {
        // Handle token refresh failure
        return;
      }
    }

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

  Future<void> _submitLaporan() async {
    if (_formKey.currentState!.validate() && setujuPernyataan) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt_token');
      int? userId = prefs.getInt('user_id');

      if (token == null || userId == null) {
        _showFeedbackDialog(context, 'Token atau userId tidak ditemukan');
        return;
      }

      if (_isTokenExpired(token)) {
        token = await _refreshToken();
        if (token != null) {
          prefs.setString('jwt_token', token);
        } else {
          _showFeedbackDialog(context, 'Gagal memperbarui token');
          return;
        }
      }

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://teralab.my.id/hdcback/api/reports'),
      );

      request.fields['tingkatSiaga'] = tingkatSiaga!;
      request.fields['deskripsi'] = deskripsi;
      request.fields['lokasi'] = lokasi;
      request.fields['jumlahPenumpang'] = jumlahPenumpang;
      request.fields['jenisPesawat'] = jenisPesawat;
      request.fields['statusAncaman'] = statusAncaman;
      request.fields['userId'] = userId.toString();

      if (_imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'imageFile',
          _imageFile!.path,
        ));
      }

      request.headers['Authorization'] = 'Bearer $token';

      try {
        final response = await request.send();

        if (response.statusCode == 201) {
          _showFeedbackDialog(context, 'Laporan berhasil dikirim');
          _createNotification('Laporan baru', 'Laporan baru dengan tingkat siaga $tingkatSiaga telah ditambahkan.');

          List<int> userIds;
          if (tingkatSiaga == '1') {
            userIds = [1, 2, 3];
          } else if (tingkatSiaga == '2') {
            userIds = [1, 2, 3, 4, 5, 6, 7];
          } else if (tingkatSiaga == '3') {
            userIds = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
          } else {
            userIds = [];
          }

          await _sendNotificationToUsers(
            'Laporan baru dengan tingkat siaga $tingkatSiaga',
            'Laporan baru telah ditambahkan dengan tingkat siaga $tingkatSiaga.',
            userIds,
          );
        } else {
          _showFeedbackDialog(context, 'Gagal mengirim laporan. Status kode: ${response.statusCode}');
          print('Gagal mengirim laporan. Status kode: ${response.statusCode}');
        }
      } catch (e) {
        _showFeedbackDialog(context, 'Terjadi kesalahan saat mengirim laporan');
        print('Terjadi kesalahan saat mengirim laporan: $e');
      }
    } else {
      _showFeedbackDialog(context, 'Form tidak valid atau pernyataan belum disetujui');
    }
  }

  Future<void> _createNotification(String title, String body) async {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'messaging_channel',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.BigText,
        largeIcon: 'resource://drawable/ic_stat_cupertino_icon',
        displayOnForeground: true,
        displayOnBackground: true,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'READ_NOTIFICATION',
          label: 'Baca Laporan',
        ),
      ],
    );
    print('Notification displayed successfully');
  }

  Future<void> _sendNotificationToUsers(
      String title, String body, List<int> userIds) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');

    for (int userId in userIds) {
      final response = await http.post(
        Uri.parse('https://teralab.my.id/hdcback/api/notifications'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'userId': userId,
          'title': title,
          'body': body,
        }),
      );

      if (response.statusCode != 200) {
        print('Failed to send notification to user $userId');
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
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
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
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
                validator: (value) =>
                    value == null ? 'Pilih tingkat siaga' : null,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Masukkan Deskripsi Laporan',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) =>
                    value!.isEmpty ? 'Deskripsi harus diisi' : null,
                onChanged: (value) {
                  deskripsi = value;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Masukkan Lokasi Kejadian',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Lokasi harus diisi' : null,
                onChanged: (value) {
                  lokasi = value;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Masukkan Jumlah Penumpang',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Jumlah penumpang harus diisi' : null,
                onChanged: (value) {
                  jumlahPenumpang = value;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Masukkan Jenis Pesawat',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Jenis pesawat harus diisi' : null,
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
                        _pickImage(ImageSource.gallery);
                      },
                      child: const Text('Upload Foto'),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _pickImage(ImageSource.camera);
                      },
                      child: const Text('Ambil Foto'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              if (_imageFile != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Image.file(_imageFile!,
                      height: 100, width: 100, fit: BoxFit.cover),
                ),
              const SizedBox(height: 16.0),
              CheckboxListTile(
                title: const Text('Saya setuju dengan pernyataan di atas'),
                value: setujuPernyataan,
                onChanged: (value) {
                  setState(() {
                    setujuPernyataan = value!;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitLaporan,
                child: const Text('Kirim Laporan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}