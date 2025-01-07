import 'package:flutter/material.dart';

class AppConstants {
  // Application-wide constants
  static const String appName = "Emergency Response";

  // Colors
  static const Color primaryColor = Color(0xFF1E88E5); // Blue
  static const Color secondaryColor = Color(0xFF42A5F5); // Light Blue
  static const Color accentColor = Color(0xFFF4511E); // Orange

  // Padding and Margins
  static const double defaultPadding = 16.0;
  static const double defaultMargin = 16.0;

  // Text Styles
  static const TextStyle headerTextStyle = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle subtitleTextStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    color: Colors.black54,
  );

  // Notification Settings
  static const int notificationDuration = 5; // in seconds

  // API Endpoints (Dummy for now)
  static const String apiBaseUrl = "https://api.example.com";
  static const String getReportsEndpoint = "/reports";
  static const String createReportEndpoint = "/reports/create";
}