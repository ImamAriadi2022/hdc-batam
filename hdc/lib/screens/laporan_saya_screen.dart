import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class LaporanSayaScreen extends StatefulWidget {
  const LaporanSayaScreen({Key? key}) : super(key: key);

  @override
  _LaporanSayaScreenState createState() => _LaporanSayaScreenState();
}

class _LaporanSayaScreenState extends State<LaporanSayaScreen> {
  final List<Map<String, dynamic>> laporanSayaList = [
    {'judul': 'Laporan Saya 1', 'tingkatSiaga': 1, 'deskripsi': 'Deskripsi Laporan Saya 1'},
    {'judul': 'Laporan Saya 2', 'tingkatSiaga': 2, 'deskripsi': 'Deskripsi Laporan Saya 2'},
    {'judul': 'Laporan Saya 3', 'tingkatSiaga': 3, 'deskripsi': 'Deskripsi Laporan Saya 3'},
  ];

  File? _imageFile;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
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

  void _showEditFormDialog(BuildContext context, Map<String, dynamic> laporan) {
    final TextEditingController deskripsiController =
        TextEditingController(text: laporan['deskripsi']);
    int tingkatSiaga = laporan['tingkatSiaga'];
    String statusAncaman = 'Aktif';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Formulir Laporan'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonFormField<int>(
                      value: tingkatSiaga,
                      items: [
                        DropdownMenuItem(value: 1, child: Text('Tingkat Siaga 1')),
                        DropdownMenuItem(value: 2, child: Text('Tingkat Siaga 2')),
                        DropdownMenuItem(value: 3, child: Text('Tingkat Siaga 3')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          tingkatSiaga = value!;
                        });
                      },
                      decoration: const InputDecoration(labelText: 'Tingkat Siaga'),
                    ),
                    TextField(
                      controller: deskripsiController,
                      decoration: const InputDecoration(labelText: 'Masukkan Deskripsi Laporan'),
                    ),
                    Row(
                      children: [
                        const Text('Status Ancaman:'),
                        Radio<String>(
                          value: 'Aktif',
                          groupValue: statusAncaman,
                          onChanged: (value) {
                            setState(() {
                              statusAncaman = value!;
                            });
                          },
                        ),
                        const Text('Aktif'),
                        Radio<String>(
                          value: 'Terkendali',
                          groupValue: statusAncaman,
                          onChanged: (value) {
                            setState(() {
                              statusAncaman = value!;
                            });
                          },
                        ),
                        const Text('Terkendali'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: const Text('Upload Foto'),
                    ),
                    if (_imageFile != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Image.file(_imageFile!, height: 100, width: 100, fit: BoxFit.cover),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Hapus'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Simpan perubahan di sini
                    Navigator.of(context).pop();
                    _showSuccessDialog(context);
                  },
                  child: const Text('Edit'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text('Pengeditan berhasil!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
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
        backgroundColor: Color(0xFF0097B2),
        title: const Text('Laporan Saya'),
      ),
      body: ListView.builder(
        itemCount: laporanSayaList.length,
        itemBuilder: (context, index) {
          final laporan = laporanSayaList[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                          laporan['judul'],
                          style: const TextStyle(
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
                              color: i < laporan['tingkatSiaga'] ? getSiagaColor(laporan['tingkatSiaga']) : Colors.grey,
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    laporan['deskripsi'],
                    style: const TextStyle(color: Colors.black54),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Flexible(
                        child: Text(
                          'Rabu, 24-10-2040 Pukul 20.00 WIB',
                          style: TextStyle(fontSize: 12, color: Colors.black45),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      TextButton(
                        onPressed: () => _showEditFormDialog(context, laporan),
                        child: const Text('Lihat Lebih Banyak'),
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
