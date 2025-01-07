import 'package:flutter/material.dart';
import '../widgets/header_widget.dart';

class AddReportScreen extends StatelessWidget {
  const AddReportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: HeaderWidget(title: 'Tambahkan Laporan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            DropdownButtonFormField(
              decoration: InputDecoration(labelText: 'Tingkat Siaga'),
              items: ['Siaga 1', 'Siaga 2', 'Siaga 3']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {},
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Deskripsi Laporan'),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Jenis Pesawat'),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Lokasi Kejadian'),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Jumlah Penumpang'),
            ),
            DropdownButtonFormField(
              decoration: InputDecoration(labelText: 'Status Ancaman'),
              items: ['Sudah Ditangani', 'Belum Ditangani']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {},
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle submit report
              },
              child: Text('Simpan Laporan'),
            ),
          ],
        ),
      ),
    );
  }
}