import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

//Login Page
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const TextField(
                decoration: InputDecoration(labelText: 'Username'),
              ),
              const SizedBox(height: 16),
              const TextField(
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Switch to the main game screen and clear the login page from history
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MainGameScreen()),
                  );
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//Cookie Clicker Game
class MainGameScreen extends StatefulWidget {
  const MainGameScreen({super.key});

  @override
  State<MainGameScreen> createState() => _MainGameScreenState();
}

class _MainGameScreenState extends State<MainGameScreen> {
  // Variable to keep track of the cookie count
  int _cookieCount = 0;

  // Function to increase the count when clicked
  void _incrementCookie() {
    setState(() {
      _cookieCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cookie Clicker')),
      drawer: Drawer(
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const SizedBox(
              height: 100.0,
              child: DrawerHeader(
                margin: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(0, 100, 200, 1),
                ),
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Cookie Clicker',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.arrow_upward),
              title: const Text('Upgrade'),
              onTap: () {
                print('Upgrade button clicked!');
                Navigator.pop(context); // Closes the drawer
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Clickable Cookie Icon in the middle
            GestureDetector(
              onTap: _incrementCookie,
              child: const Icon(
                Icons.cookie,
                size: 120.0,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 30.0),
            // Counter text displayed at the bottom of the icon
            Text(
              'Cookies: $_cookieCount',
              style: const TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}