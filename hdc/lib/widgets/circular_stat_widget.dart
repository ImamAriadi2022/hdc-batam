import 'package:flutter/material.dart';

class CircularStatWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatCard('Laporan', '120', Colors.blue),
        _buildStatCard('Siaga 1', '30', Colors.red),
        _buildStatCard('Siaga 2', '50', Colors.orange),
        _buildStatCard('Siaga 3', '40', Colors.green),
      ],
    );
  }

  Widget _buildStatCard(String title, String count, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: color.withOpacity(0.3),
          child: Text(
            count,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(title),
      ],
    );
  }
}