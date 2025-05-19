import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/daftar_laporan_screen.dart';
import 'screens/laporan_saya_screen.dart';
import 'screens/tambah_laporan_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/emergency_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'notification_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationController.initializeLocalNotifications();
  await NotificationController.initializeService();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Laporan Siaga',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> _notifications = [];
  List<Widget> _widgetOptions = [];
  List<BottomNavigationBarItem> _navBarItems = [];
  int? userId;

  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  bool isPanelOpen = false;

  @override
  void initState() {
    super.initState();
    _checkUserPermission();
    _fetchNotifications();
    NotificationController.startListeningNotificationEvents();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  void togglePanel() {
    setState(() {
      isPanelOpen = !isPanelOpen;
      isPanelOpen ? _controller.forward() : _controller.reverse();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _checkUserPermission() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('user_id');

    if (userId != null && [1, 2, 3].contains(userId)) {
      _widgetOptions = <Widget>[
        HomeScreen(),
        DaftarLaporanScreen(),
        LaporanSayaScreen(),
        TambahLaporanScreen(),
      ];

      _navBarItems = const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Beranda',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'Daftar Laporan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Laporan Saya',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: 'Laporkan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.logout),
          label: 'Logout',
        ),
      ];
    } else {
      _widgetOptions = <Widget>[
        HomeScreen(),
        DaftarLaporanScreen(),
      ];

      _navBarItems = const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Beranda',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'Daftar Laporan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.logout),
          label: 'Logout',
        ),
      ];
    }

    setState(() {});
  }

  Future<void> _fetchNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');

    if (token == null || _isTokenExpired(token)) {
      token = await _refreshToken();
      if (token != null) {
        prefs.setString('jwt_token', token);
      } else {
        return;
      }
    }

    final response = await http.get(
      Uri.parse('https://kenedy.cbraind.my.id/hdcback/api/notifications'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        _notifications = List<Map<String, dynamic>>.from(json.decode(response.body));
        if (_notifications.isNotEmpty) {
          _showNotificationDialog();
        }
      });
    } else {
      print('Failed to load notifications');
    }
  }

  bool _isTokenExpired(String token) {
    return false; // implement logic if needed
  }

  Future<String?> _refreshToken() async {
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
        return null;
      }
    }
    return null;
  }

  void _showNotificationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Notifikasi Baru'),
          content: Text('Anda memiliki notifikasi baru.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onItemTapped(int index) {
    if (index == _navBarItems.length - 1) {
      _showLogoutDialog();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Keluar'),
          content: Text('Apakah anda benar ingin keluar?'),
          actions: <Widget>[
            TextButton(
              child: Text('batalkan'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Logout'),
              onPressed: () {
                Navigator.of(context).pop();
                _logout();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    await prefs.remove('refresh_token');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SplashScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: _widgetOptions.isNotEmpty
              ? _widgetOptions.elementAt(_selectedIndex)
              : const Center(child: CircularProgressIndicator()),
          bottomNavigationBar: BottomNavigationBar(
            items: _navBarItems,
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            backgroundColor: const Color(0xFF0097B2),
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: true,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: togglePanel,
            backgroundColor: const Color(0xFF0097B2),
            child: Icon(isPanelOpen ? Icons.close : Icons.menu_book),
          ),
        ),
        // Overlay untuk tap keluar
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Positioned.fill(
              child: IgnorePointer(
                ignoring: !isPanelOpen,
                child: GestureDetector(
                  onTap: togglePanel,
                  child: Container(
                    color: isPanelOpen ? Colors.black.withOpacity(0.4) : Colors.transparent,
                  ),
                ),
              ),
            );
          },
        ),
        // Panel Geser dari Kanan
        SlideTransition(
          position: _offsetAnimation,
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              height: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.only(top: 50),
              child: const EmergencyPage(),
            ),
          ),
        ),
      ],
    );
  }
}
