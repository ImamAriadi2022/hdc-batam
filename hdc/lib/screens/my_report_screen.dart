import 'package:flutter/material.dart';
import '../widgets/header_widget.dart';
import '../widgets/report_list_widget.dart';
import '../utils/dummy_data.dart';

/// A screen that displays the user's reports.
class MyReportsScreen extends StatefulWidget {
  const MyReportsScreen({Key? key}) : super(key: key);

  @override
  State<MyReportsScreen> createState() => _MyReportsScreenState();
}

class _MyReportsScreenState extends State<MyReportsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: HeaderWidget(title: 'Laporan Saya'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ReportListWidget(reports: dummyReports),
      ),
    );
  }
}