import 'package:flutter/material.dart';
import '../widgets/header_widget.dart';
import '../widgets/report_list_widget.dart';
import '../utils/dummy_data.dart';

class ReportListScreen extends StatelessWidget {
  const ReportListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: HeaderWidget(title: 'Daftar Laporan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ReportListWidget(reports: dummyReports),
      ),
    );
  }
}