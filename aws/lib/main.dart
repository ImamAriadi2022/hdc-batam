// filepath: /c:/Users/asus/Downloads/hdc-batam/aws/lib/main.dart
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
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.white,
        importance: NotificationImportance.High,
        channelShowBadge: true,
        playSound: true,
        enableVibration: true,
        enableLights: true,
        defaultRingtoneType: DefaultRingtoneType.Notification,
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
          channelKey: 'basic_channel',
          title: 'Notification from API',
          body: 'API Response: ${data['message']}',
          notificationLayout: NotificationLayout.Default,
          largeIcon: 'resource://drawable/ic_stat_cupertino_icon', // Use Cupertino icon
          displayOnForeground: true, // Ensure notification is shown in foreground
          displayOnBackground: true, // Ensure notification is shown in background
        ),
      );
    } else {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 11,
          channelKey: 'basic_channel',
          title: 'API Error',
          body: 'Error: ${response.reasonPhrase}',
          notificationLayout: NotificationLayout.Default,
          largeIcon: 'resource://drawable/ic_stat_cupertino_icon', // Use Cupertino icon
          displayOnForeground: true, // Ensure notification is shown in foreground
          displayOnBackground: true, // Ensure notification is shown in background
        ),
      );
    }
  } catch (e) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 12,
        channelKey: 'basic_channel',
        title: 'API Error',
        body: 'Failed to fetch data: $e',
        notificationLayout: NotificationLayout.Default,
        largeIcon: 'resource://drawable/ic_stat_cupertino_icon', // Use Cupertino icon
        displayOnForeground: true, // Ensure notification is shown in foreground
        displayOnBackground: true, // Ensure notification is shown in background
      ),
    );
  }
}

Future<void> debugNotification(int count) async {
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 20,
      channelKey: 'basic_channel',
      title: 'Debug Notification',
      body: 'Button pressed $count times',
      notificationLayout: NotificationLayout.Default,
      largeIcon: 'resource://drawable/ic_stat_cupertino_icon', // Use Cupertino icon
      displayOnForeground: true, // Ensure notification is shown in foreground
      displayOnBackground: true, // Ensure notification is shown in background
    ),
  );
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