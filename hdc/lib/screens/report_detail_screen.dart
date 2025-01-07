import 'package:flutter/material.dart';

class ReportDetailWidget extends StatelessWidget {
  final List<Map<String, String>> reports;

  const ReportDetailWidget({required this.reports});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: reports.length,
      itemBuilder: (ctx, index) {
        return Card(
          child: ListTile(
            title: Text(reports[index]['title']!),
            subtitle: Text(reports[index]['date']!),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // Handle navigation to report detail
            },
          ),
        );
      },
    );
  }
}