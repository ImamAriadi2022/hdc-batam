import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter_background_service/flutter_background_service.dart';

class NotificationController {
  static ReceivedAction? initialAction;
  static List<Map<String, dynamic>> _notifications = [];

  static Future<void> initializeLocalNotifications() async {
    await AwesomeNotifications().initialize(
      null, 
      [
        NotificationChannel(
          channelKey: 'messaging_channel',
          channelName: 'Messaging Notifications',
          channelDescription: 'Notification channel for messaging',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          playSound: true,
          enableVibration: true,
          enableLights: true,
        )
      ],
      debug: true,
    );

    initialAction = await AwesomeNotifications()
        .getInitialNotificationAction(removeFromActionEvents: false);
  }

  static Future<void> startListeningNotificationEvents() async {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
    );
  }

  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    if (receivedAction.buttonKeyPressed == 'READ_NOTIFICATION') {
      await _markNotificationAsRead(receivedAction.id!);
    }
  }

  static Future<void> _markNotificationAsRead(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await _getValidToken();

    final response = await http.delete(
      Uri.parse('https://kenedy.cbraind.my.id/hdcback/api/notifications/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      _notifications.removeWhere((notification) => notification['id'] == id);
    }
  }

  static Future<void> _fetchNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await _getValidToken();

    final response = await http.get(
      Uri.parse('https://kenedy.cbraind.my.id/hdcback/api/notifications'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      _notifications = List<Map<String, dynamic>>.from(json.decode(response.body));

      for (var notification in _notifications) {
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: notification['id'],
            channelKey: 'messaging_channel',
            title: 'Notifikasi Baru',
            body: notification['message'],
            notificationLayout: NotificationLayout.BigText,
            displayOnForeground: true,
            displayOnBackground: true,
          ),
          actionButtons: [
            NotificationActionButton(
              key: 'READ_NOTIFICATION',
              label: 'Baca Notifikasi',
            ),
          ],
        );
      }
    }
  }

  static Future<void> initializeService() async {
    final service = FlutterBackgroundService();

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        isForegroundMode: true,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
    );

    service.startService();
  }

  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) async {
    WidgetsFlutterBinding.ensureInitialized();

    if (service is AndroidServiceInstance) {
      service.setAsForegroundService();

      service.on('stopService').listen((event) {
        service.stopSelf();
      });
    }

    Timer.periodic(const Duration(seconds: 10), (timer) async {
      if (service is AndroidServiceInstance) {
        if (await service.isForegroundService()) {
          await _fetchNotifications();
        }
      } else {
        await _fetchNotifications();
      }
    });
  }

  @pragma('vm:entry-point')
  static Future<bool> onIosBackground(ServiceInstance service) async {
    return true;
  }

  static Future<String?> _getValidToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');

    if (token == null || _isTokenExpired(token)) {
      token = await _refreshToken();
      if (token != null) {
        prefs.setString('jwt_token', token);
      }
    }

    return token;
  }

  static bool _isTokenExpired(String token) {
    // Implement token expiration check logic here
    return false;
  }

  static Future<String?> _refreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? refreshToken = prefs.getString('refresh_token');

    if (refreshToken != null) {
      final response = await http.post(
        Uri.parse('https://kenedy.cbraind.my.id/hdcback/api/refresh-token'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'token': refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['accessToken'];
      } else {
        // Handle error
        return null;
      }
    }
    return null;
  }
}