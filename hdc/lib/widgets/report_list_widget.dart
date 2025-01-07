import 'package:flutter/material.dart';

class ReportListWidget extends StatelessWidget {
  final List<Map<String, String>> reports;
  final Function(Map<String, String>)? onReportTap;

  const ReportListWidget({
    Key? key,
    required this.reports,
    this.onReportTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return reports.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.folder_off,
                  size: 80,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'Belum ada laporan tersedia.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        : ListView.builder(
            itemCount: reports.length,
            itemBuilder: (ctx, index) {
              final report = reports[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green.withOpacity(0.2),
                    child: Icon(Icons.article, color: Colors.green),
                  ),
                  title: Text(report['title']!),
                  subtitle: Text(
                    'Tanggal: ${report['date']!}\nPenulis: ${report['author']!}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () => onReportTap?.call(report),
                ),
              );
            },
          );
  }
}