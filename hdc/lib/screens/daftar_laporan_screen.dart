import 'package:flutter/material.dart';

class DaftarLaporanScreen extends StatelessWidget {
  const DaftarLaporanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> laporanList = [
      {'judul': 'Siaga 1', 'tingkatSiaga': 1, 'deskripsi': 'Deskripsi Siaga 1'},
      {'judul': 'Siaga 2', 'tingkatSiaga': 2, 'deskripsi': 'Deskripsi Siaga 2'},
      {'judul': 'Siaga 3', 'tingkatSiaga': 3, 'deskripsi': 'Deskripsi Siaga 3'},
    ];

    final List<Map<String, dynamic>> notifications = [
      {'judul': 'Notifikasi 1', 'deskripsi': 'Deskripsi Notifikasi 1', 'dibaca': false},
      {'judul': 'Notifikasi 2', 'deskripsi': 'Deskripsi Notifikasi 2', 'dibaca': true},
      {'judul': 'Notifikasi 3', 'deskripsi': 'Deskripsi Notifikasi 3', 'dibaca': false},
    ];

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

    void showDetailDialog(BuildContext context, Map<String, dynamic> laporan) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(laporan['judul']),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tingkat Siaga: ${laporan['tingkatSiaga']}'),
                SizedBox(height: 10),
                Text('Deskripsi: ${laporan['deskripsi']}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Tutup'),
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
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0097B2),
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
        itemCount: laporanList.length,
        itemBuilder: (context, index) {
          final laporan = laporanList[index];
          return Card(
            child: ListTile(
              title: Text(
                laporan['judul'],
                style: TextStyle(
                  color: getSiagaColor(laporan['tingkatSiaga']),
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: ElevatedButton(
                onPressed: () {
                  showDetailDialog(context, laporan);
                },
                child: Text('Detail Laporan'),
              ),
            ),
          );
        },
      ),
    );
  }
}