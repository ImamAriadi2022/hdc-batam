import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class LaporanSayaScreen extends StatefulWidget {
  const LaporanSayaScreen({Key? key}) : super(key: key);

  @override
  State<LaporanSayaScreen> createState() => _LaporanSayaScreenState();
}

class _LaporanSayaScreenState extends State<LaporanSayaScreen> {
  final List<Map<String, dynamic>> _laporanList = [
    {
      'tingkatSiaga': '1',
      'deskripsi': 'Deskripsi Laporan Siaga 1',
      'lokasi': 'Lokasi 1',
      'jumlahPenumpang': '100',
      'jenisPesawat': 'Jenis 1',
      'statusAncaman': 'Aktif',
      'imageFile': null,
    },
    {
      'tingkatSiaga': '2',
      'deskripsi': 'Deskripsi Laporan Siaga 2',
      'lokasi': 'Lokasi 2',
      'jumlahPenumpang': '200',
      'jenisPesawat': 'Jenis 2',
      'statusAncaman': 'Terkendali',
      'imageFile': null,
    },
    {
      'tingkatSiaga': '3',
      'deskripsi': 'Deskripsi Laporan Siaga 3',
      'lokasi': 'Lokasi 3',
      'jumlahPenumpang': '300',
      'jenisPesawat': 'Jenis 3',
      'statusAncaman': 'Aktif',
      'imageFile': null,
    },
  ];

  final List<Map<String, dynamic>> _notifications = [
    {'judul': 'Notifikasi 1', 'deskripsi': 'Deskripsi Notifikasi 1', 'dibaca': false},
    {'judul': 'Notifikasi 2', 'deskripsi': 'Deskripsi Notifikasi 2', 'dibaca': true},
    {'judul': 'Notifikasi 3', 'deskripsi': 'Deskripsi Notifikasi 3', 'dibaca': false},
  ];

  void _showLaporanDetailDialog(BuildContext context, Map<String, dynamic> laporan) {
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
                  Image.file(laporan['imageFile'], height: 100, width: 100, fit: BoxFit.cover),
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
                setState(() {
                  _laporanList.remove(laporan);
                });
                Navigator.of(context).pop();
                _showFeedbackDialog(context, 'Laporan berhasil dihapus!');
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
    final _formKey = GlobalKey<FormState>();
    String? tingkatSiaga = laporan['tingkatSiaga'];
    String deskripsi = laporan['deskripsi'];
    String lokasi = laporan['lokasi'];
    String jumlahPenumpang = laporan['jumlahPenumpang'];
    String jenisPesawat = laporan['jenisPesawat'];
    String statusAncaman = laporan['statusAncaman'];
    File? imageFile = laporan['imageFile'];

    Future<void> _pickImage(ImageSource source) async {
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
              key: _formKey,
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
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    laporan['tingkatSiaga'] = tingkatSiaga;
                    laporan['deskripsi'] = deskripsi;
                    laporan['lokasi'] = lokasi;
                    laporan['jumlahPenumpang'] = jumlahPenumpang;
                    laporan['jenisPesawat'] = jenisPesawat;
                    laporan['statusAncaman'] = statusAncaman;
                    laporan['imageFile'] = imageFile;
                  });
                  Navigator.of(context).pop();
                  _showFeedbackDialog(context, 'Laporan berhasil diubah!');
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
              child: ListView.builder(
                controller: scrollController,
                itemCount: _notifications.length,
                itemBuilder: (context, index) {
                  final notification = _notifications[index];
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
                          'Laporan ${index + 1}',
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
                              color: i < int.parse(laporan['tingkatSiaga']) ? getSiagaColor(int.parse(laporan['tingkatSiaga'])) : Colors.grey,
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