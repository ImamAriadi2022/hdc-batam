import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
  String statusAncaman = 'Aktif';
  bool setujuPernyataan = false;
  File? _imageFile;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitLaporan() async {
    if (_formKey.currentState!.validate() && setujuPernyataan) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt_token');
      int? userId = prefs.getInt('user_id'); // Assuming user_id is stored in SharedPreferences

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.1.4:5000/api/reports'),
      );

      request.fields['tingkatSiaga'] = tingkatSiaga!;
      request.fields['deskripsi'] = deskripsi;
      request.fields['lokasi'] = lokasi;
      request.fields['jumlahPenumpang'] = jumlahPenumpang;
      request.fields['jenisPesawat'] = jenisPesawat;
      request.fields['statusAncaman'] = statusAncaman;
      request.fields['userId'] = userId.toString(); // Use userId from SharedPreferences

      if (_imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'imageFile',
          _imageFile!.path,
        ));
      }

      request.headers['Authorization'] = 'Bearer $token';

      final response = await request.send();

      if (response.statusCode == 201) {
        _showSuccessDialog(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengirim laporan')),
        );
      }
    } else if (!setujuPernyataan) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Anda harus menyetujui pernyataan')),
      );
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sukses'),
          content: Text('Laporan berhasil disubmit!'),
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
                itemCount: 3, // Jumlah notifikasi
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Notifikasi ${index + 1}'),
                    subtitle: Text('Deskripsi Notifikasi ${index + 1}'),
                    trailing: Icon(
                      index % 2 == 0 ? Icons.check_circle : Icons.circle,
                      color: index % 2 == 0 ? Colors.green : Colors.red,
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16.0), // Padding top
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Tingkat Siaga',
                    border: OutlineInputBorder(),
                  ),
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
                if (_imageFile != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Image.file(_imageFile!, height: 100, width: 100, fit: BoxFit.cover),
                  ),
                CheckboxListTile(
                  title: const Text(
                    'Saya Bertanggung Jawab Atas Laporan yang saya tulis adalah kebenaran dan benar',
                  ),
                  value: setujuPernyataan,
                  onChanged: (value) {
                    setState(() {
                      setujuPernyataan = value!;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _submitLaporan,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: const Text('Laporkan'),
                ),
                const SizedBox(height: 16.0), // Padding bottom
              ],
            ),
          ),
        ),
      ),
    );
  }
}