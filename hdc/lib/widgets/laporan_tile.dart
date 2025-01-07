import 'package:flutter/material.dart';

class LaporanTile extends StatelessWidget {
  final String deskripsi;
  final int tingkatSiaga;

  LaporanTile({required this.deskripsi, required this.tingkatSiaga});

  @override
  Widget build(BuildContext context) {
    Color getSiagaColor(int siaga) {
      if (siaga == 1) {
        return Colors.green;
      } else if (siaga == 2) {
        return Colors.orange;
      } else {
        return Colors.red;
      }
    }

    String getSiagaText(int siaga) {
      if (siaga == 1) {
        return 'Siaga 1: Low';
      } else if (siaga == 2) {
        return 'Siaga 2: Medium';
      } else {
        return 'Siaga 3: High';
      }
    }

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: getSiagaColor(tingkatSiaga),
          child: Text(
            '$tingkatSiaga',
            style: TextStyle(color: Colors.white),
          ),
        ),
        title: Text(deskripsi),
        subtitle: Text(getSiagaText(tingkatSiaga)),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Laporan dengan Siaga $tingkatSiaga dipilih')),
          );
        },
      ),
    );
  }
}
