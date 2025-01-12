import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cupertino_icons/cupertino_icons.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize(
    null, // Null to use default icon
    [
      NotificationChannel(
        channelKey: 'big_text_channel',
        channelName: 'Big Text Notifications',
        channelDescription: 'Notification channel for big text notifications',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.white,
        importance: NotificationImportance.Max,
        channelShowBadge: true,
        playSound: true,
        enableVibration: true,
        enableLights: true,
        defaultRingtoneType: DefaultRingtoneType.Notification,
        locked: true, // Ensure the notification is not dismissible
      )
    ],
  );
  runApp(const MyApp());
}

Future<void> fetchDataAndNotify() async {
  try {
    final response = await http.get(Uri.parse('https://yourapi.com/endpoint'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 10,
          channelKey: 'big_text_channel',
          title: 'Notification from API',
          body: 'API Response: ${data['message']}',
          notificationLayout: NotificationLayout.BigText,
          largeIcon: 'resource://drawable/ic_stat_cupertino_icon', // Use Cupertino icon
          displayOnForeground: true, // Ensure notification is shown in foreground
          displayOnBackground: true, // Ensure notification is shown in background
          fullScreenIntent: true, // Ensure the notification appears as a pop-up
        ),
      );
      print('Notification from API displayed successfully');
    } else {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 11,
          channelKey: 'big_text_channel',
          title: 'API Error',
          body: 'Error: ${response.reasonPhrase}',
          notificationLayout: NotificationLayout.BigText,
          largeIcon: 'resource://drawable/ic_stat_cupertino_icon', // Use Cupertino icon
          displayOnForeground: true, // Ensure notification is shown in foreground
          displayOnBackground: true, // Ensure notification is shown in background
          fullScreenIntent: true, // Ensure the notification appears as a pop-up
        ),
      );
      print('API Error notification displayed successfully');
    }
  } catch (e) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 12,
        channelKey: 'big_text_channel',
        title: 'API Error',
        body: 'Failed to fetch data: $e',
        notificationLayout: NotificationLayout.BigText,
        largeIcon: 'resource://drawable/ic_stat_cupertino_icon', // Use Cupertino icon
        displayOnForeground: true, // Ensure notification is shown in foreground
        displayOnBackground: true, // Ensure notification is shown in background
        fullScreenIntent: true, // Ensure the notification appears as a pop-up
      ),
    );
    print('Failed to fetch data notification displayed successfully');
  }
}

Future<void> debugNotification(int count) async {
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 20,
      channelKey: 'big_text_channel',
      title: 'Debug Notification',
      body: 'Button pressed $count times',
      notificationLayout: NotificationLayout.BigText,
      largeIcon: 'resource://drawable/ic_stat_cupertino_icon', // Use Cupertino icon
      displayOnForeground: true, // Ensure notification is shown in foreground
      displayOnBackground: true, // Ensure notification is shown in background
      fullScreenIntent: true, // Ensure the notification appears as a pop-up
    ),
  );
  print('Debug notification displayed successfully');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Notification Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() async {
    setState(() {
      _counter++;
    });

    // Show debug notification
    await debugNotification(_counter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text('$_counter', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: fetchDataAndNotify,
              child: const Text('Fetch API and Notify'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}