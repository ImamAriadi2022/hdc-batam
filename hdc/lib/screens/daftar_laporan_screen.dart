import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DaftarLaporanScreen extends StatefulWidget {
  const DaftarLaporanScreen({super.key});

  @override
  _DaftarLaporanScreenState createState() => _DaftarLaporanScreenState();
}

class _DaftarLaporanScreenState extends State<DaftarLaporanScreen> {
  List<Map<String, dynamic>> _laporanList = [];

  @override
  void initState() {
    super.initState();
    _fetchLaporan();
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
            Text('Daftar Laporan'),
          ],
        ),
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