import 'package:flutter/material.dart';
import 'daftar_laporan_screen.dart';
import 'laporan_saya_screen.dart';
import 'tambah_laporan_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(child: Text('Selamat Datang di Laporan Siaga')),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text('Daftar Laporan'),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DaftarLaporanScreen())),
            ),
            ListTile(
              title: Text('Laporan Saya'),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LaporanSayaScreen())),
            ),
            ListTile(
              title: Text('Tambah Laporan'),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TambahLaporanScreen())),
            ),
          ],
        ),
      ),
    );
  }
}
