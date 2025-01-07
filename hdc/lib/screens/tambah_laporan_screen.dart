import 'package:flutter/material.dart';

class TambahLaporanScreen extends StatelessWidget {
  final TextEditingController laporanController = TextEditingController();
  final TextEditingController siagaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Laporan')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: laporanController,
              decoration: InputDecoration(labelText: 'Deskripsi Laporan'),
            ),
            TextField(
              controller: siagaController,
              decoration: InputDecoration(labelText: 'Tingkat Siaga (1-3)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Logic untuk menyimpan laporan dan mengirim notifikasi
                int siaga = int.parse(siagaController.text);
                showNotification(context, siaga);
              },
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  void showNotification(BuildContext context, int siaga) {
    String message;
    if (siaga == 1) {
      message = 'Low notification: Siaga 1';
    } else if (siaga == 2) {
      message = 'Medium notification: Siaga 2';
    } else {
      message = 'Very high notification: Siaga 3';
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
