import 'package:flutter/material.dart';
import '../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  void _showLoginSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Login',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(labelText: 'Username'),
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    obscureText: !_isPasswordVisible,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Tutup bottom sheet setelah login
                      _login();
                    },
                    child: Text('Login'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Tutup bottom sheet
                    },
                    child: Text('Batalkan'),
                  ),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      // Aksi untuk lupa password
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Fitur lupa password belum tersedia')),
                      );
                    },
                    child: Text(
                      'Lupa Password?',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _login() {
    print('Login attempt with username: ${_usernameController.text} and password: ${_passwordController.text}');
    // Implementasi login sederhana
    if (_usernameController.text == 'admin' &&
        _passwordController.text == 'admin') {
      print('Login successful, showing success dialog');
      _showSuccessDialog();
    } else {
      print('Login failed, showing error message');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Username atau password salah')),
      );
    }
  }

  void _showSuccessDialog() {
    print('Showing success dialog');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Login Berhasil'),
          content: Text('Anda berhasil login.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                print('OK button pressed');
                Navigator.of(context).pop();
                print('Navigating to MainScreen');
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MainScreen()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo
            Image.asset(
              'assets/logo/logo.png',
              height: 150,
            ),
            SizedBox(height: 16),

            // Peta
            Expanded(
              child: Image.asset(
                'assets/img/peta.png',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            SizedBox(height: 16),

            // Informasi Terkini
            Text(
              'Informasi Terkini',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            // Teks 1, 2, dan 3
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: const Color(0xFF0097B2),
                  child: Text('1', style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
                SizedBox(width: 8),
                CircleAvatar(radius: 30,
                  backgroundColor: const Color(0xFF0097B2),child: Text('2', style: TextStyle(fontSize: 20, color: Colors.white)),),
                SizedBox(width: 8),
                CircleAvatar(radius: 30,
                backgroundColor: const Color(0xFF0097B2),child: Text('3', style: TextStyle(fontSize: 20, color: Colors.white)),),
              ],
            ),
            SizedBox(height: 32),

            // Tombol Login
            SizedBox(
              width: double.infinity, // Lebar penuh
              child: ElevatedButton(
                onPressed: _showLoginSheet,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 13.0), // Tinggi tombol
                  backgroundColor: const Color(0xFF0097B2), // Warna tombol
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),// Bentuk tombol
                ),
                child: Text('Login', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}