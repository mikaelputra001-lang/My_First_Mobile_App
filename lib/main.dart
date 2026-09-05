import 'dart:async';

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
  int _cookieCount = 0;
  bool _isCookiePressed = false;
  int _nextPopId = 0;
  final List<int> _activePops = [];
  final List<Timer> _popTimers = [];
  Timer? _pressTimer;

  void _incrementCookie() {
    setState(() {
      _cookieCount++;
      _isCookiePressed = true;
      _activePops.add(_nextPopId++);
    });

    _pressTimer?.cancel();
    _pressTimer = Timer(const Duration(milliseconds: 130), () {
      if (mounted) {
        setState(() => _isCookiePressed = false);
      }
    });

    final popId = _activePops.last;
    _popTimers.add(
      Timer(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() => _activePops.remove(popId));
        }
      }),
    );
  }

  @override
  void dispose() {
    _pressTimer?.cancel();
    for (final timer in _popTimers) {
      timer.cancel();
    }
    super.dispose();
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
            SizedBox(
              width: 220,
              height: 190,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  GestureDetector(
                    onTap: _incrementCookie,
                    child: AnimatedScale(
                      scale: _isCookiePressed ? 0.82 : 1,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.easeOut,
                      child: const Icon(
                        Icons.cookie,
                        size: 120.0,
                        color: Colors.brown,
                      ),
                    ),
                  ),
                  for (final popId in _activePops)
                    _CookiePop(key: ValueKey(popId)),
                ],
              ),
            ),
            const SizedBox(height: 30.0),
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

class _CookiePop extends StatelessWidget {
  const _CookiePop({super.key});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(seconds: 1),
      curve: Curves.easeOut,
      builder: (context, progress, child) {
        return Transform.translate(
          offset: Offset(0, -75 - (100 * progress)),
          child: Opacity(opacity: 1 - progress, child: child),
        );
      },
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.cookie, size: 28, color: Colors.brown),
          SizedBox(width: 4),
          Text(
            '+1',
            style: TextStyle(
              color: Colors.brown,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
