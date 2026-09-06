import 'dart:async';
import 'dart:math';

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

// Login Page
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isUsernameWrong = false;
  bool _isPasswordWrong = false;

  void _login() {
    const correctUsername = 'mikael';
    const correctPassword = '123';
    final isUsernameWrong = _usernameController.text != correctUsername;
    final isPasswordWrong = _passwordController.text != correctPassword;

    setState(() {
      _isUsernameWrong = isUsernameWrong;
      _isPasswordWrong = isPasswordWrong;
    });

    if (!isUsernameWrong && !isPasswordWrong) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainGameScreen()),
      );
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
              if (_isUsernameWrong)
                const _LoginError(
                  message:
                      '*username salah, mohon masukan username yang benar',
                ),
              TextField(
                controller: _usernameController,
                onChanged: (_) {
                  if (_isUsernameWrong) {
                    setState(() => _isUsernameWrong = false);
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Username',
                  filled: _isUsernameWrong,
                  fillColor: const Color.fromRGBO(244, 67, 54, 0.12),
                ),
              ),
              const SizedBox(height: 16),
              if (_isPasswordWrong)
                const _LoginError(
                  message:
                      '*password salah, mohon masukan password yang benar',
                ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                onChanged: (_) {
                  if (_isPasswordWrong) {
                    setState(() => _isPasswordWrong = false);
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Password',
                  filled: _isPasswordWrong,
                  fillColor: const Color.fromRGBO(244, 67, 54, 0.12),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _login,
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginError extends StatelessWidget {
  const _LoginError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text(
          message,
          style: const TextStyle(color: Colors.red, fontSize: 12),
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
  // ==== Game state variables =====
  int _cookieCount = 0;
  bool _isCookiePressed = false;
  bool _hasDoubleCookie = false;
  bool _hasAutoBaking = false;
  bool _hasCookieRoulette = false;
  bool _isRouletteBonus = false;
  int _rouletteClickCount = 0;
  int _nextPopId = 0;
  final List<_CookiePopData> _activePops = [];
  final List<Timer> _popTimers = [];
  final _random = Random();
  Timer? _pressTimer;
  Timer? _autoBakingTimer;
  Timer? _rouletteFlashTimer;

  // ===== Cookie increment logic =====
  void _incrementCookie() {
    _addCookies(_hasDoubleCookie ? 2 : 1);
    _checkCookieRoulette();
    setState(() {
      _isCookiePressed = true;
    });

    _pressTimer?.cancel();
    _pressTimer = Timer(const Duration(milliseconds: 130), () {
      if (mounted) {
        setState(() => _isCookiePressed = false);
      }
    });

  }
// ==== Cookie addition logic =====
  void _addCookies(int amount) {
    setState(() {
      _cookieCount += amount;
      _addPop(amount, Colors.brown);
    });
  }
// ===== Cookie roulette bonus logic =====
  void _checkCookieRoulette() {
    if (!_hasCookieRoulette) {
      return;
    }

    _rouletteClickCount++;
    if (_rouletteClickCount % 20 != 0 || !_random.nextBool()) {
      return;
    }

    setState(() {
      _cookieCount += 10;
      _addPop(10, Colors.amber.shade700);
      _isRouletteBonus = true;
    });

    _rouletteFlashTimer?.cancel();
    _rouletteFlashTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() => _isRouletteBonus = false);
      }
    });
  }
// ===== Cookie pop animation management =====
  void _addPop(int amount, Color color) {
    final pop = _CookiePopData(_nextPopId++, amount, color);
    _activePops.add(pop);
    _popTimers.add(
      Timer(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() => _activePops.remove(pop));
        }
      }),
    );
  }

  // ===== Upgrade information and unlocks =====
  void _showUpgradeInfo(_UpgradeType upgrade) {
    final isUnlocked = _isUnlocked(upgrade);
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(upgrade.title),
        content: Text(upgrade.description),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
          if (!isUnlocked)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _tryUpgrade(upgrade);
              },
              child: const Text('Unlock'),
            ),
        ],
      ),
    );
  }
// ==== Upgrade unlock logic =====
  void _tryUpgrade(_UpgradeType upgrade) {
    if (_isUnlocked(upgrade)) {
      Navigator.pop(context);
      return;
    }
// ==== Check if the player has enough cookies to unlock the upgrade ====
    final requiredCookies = upgrade.requiredCookies;
    if (_cookieCount < requiredCookies) {
      Navigator.pop(context);
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Upgrade terkunci'),
          content: Text(
            'Anda kurang ${requiredCookies - _cookieCount} cookie untuk membuka upgrade ini!',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }
// === Unlock the upgrade and update state ===
    setState(() {
      // A successful upgrade starts the next progress counter from zero.
      _cookieCount = 0;
      switch (upgrade) {
        case _UpgradeType.doubleCookie:
          _hasDoubleCookie = true;
          break;
        case _UpgradeType.autoBaking:
          _hasAutoBaking = true;
          break;
        case _UpgradeType.cookieRoulette:
          _hasCookieRoulette = true;
          _rouletteClickCount = 0;
          break;
      }
    });
// === Start auto-baking timer if unlocked ===
    if (upgrade == _UpgradeType.autoBaking) {
      _autoBakingTimer ??= Timer.periodic(
        const Duration(seconds: 1),
        (_) => _addCookies(1),
      );
    }
    Navigator.pop(context);
  }
// ===== Upgrade unlock check =====
  bool _isUnlocked(_UpgradeType upgrade) {
    return switch (upgrade) {
      _UpgradeType.doubleCookie => _hasDoubleCookie,
      _UpgradeType.autoBaking => _hasAutoBaking,
      _UpgradeType.cookieRoulette => _hasCookieRoulette,
    };
  }
// ===== Lifecycle management =====
  @override
  void dispose() {
    _pressTimer?.cancel();
    _autoBakingTimer?.cancel();
    _rouletteFlashTimer?.cancel();
    for (final timer in _popTimers) {
      timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ===== Game interface =====
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
            for (final upgrade in _UpgradeType.values)
              ListTile(
                leading: Icon(
                  _isUnlocked(upgrade) ? Icons.check_circle : Icons.lock,
                  color: _isUnlocked(upgrade) ? Colors.green : Colors.grey,
                ),
                title: Text(upgrade.title),
                subtitle: Text('${upgrade.requiredCookies} cookie untuk unlock'),
                trailing: const Icon(Icons.touch_app),
                onTap: () => _showUpgradeInfo(upgrade),
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
                    child: SizedBox(
                      width: 156,
                      height: 156,
                      child: Center(
                        child: AnimatedScale(
                          scale: _isCookiePressed ? 0.82 : 1,
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.easeOut,
                          child: Icon(
                            Icons.cookie,
                            size: 120.0,
                            color: _isRouletteBonus
                                ? Colors.amber.shade700
                                : Colors.brown,
                          ),
                        ),
                      ),
                    ),
                  ),
                  for (final pop in _activePops)
                    _CookiePop(
                      key: ValueKey(pop.id),
                      amount: pop.amount,
                      color: pop.color,
                    ),
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

//===== Cookie pop animation data class and widget =====
class _CookiePopData {
  const _CookiePopData(this.id, this.amount, this.color);

  final int id;
  final int amount;
  final Color color;
}

enum _UpgradeType {
  doubleCookie(
    'Double Cookie',
    100,
    'the cookie has double! when you click the cookie is adding 2 cookie insted of 1.',
  ),
  autoBaking(
    'Auto Baking',
    200,
    'your oven now has AI Agent in it?! now every 1 second a cookie will automaticly made.',
  ),
  cookieRoulette(
    'Choco Chips?!',
    500,
    'chips? remind me of a casino chips. BTW, every 20 click you made will have a 50/50 change of its being a golden cookie that will give you 10 cookie as FREE!',
  );

  const _UpgradeType(this.title, this.requiredCookies, this.description);

  final String title;
  final int requiredCookies;
  final String description;
}

class _CookiePop extends StatelessWidget {
  const _CookiePop({super.key, required this.amount, required this.color});

  final int amount;
  final Color color;

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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.cookie, size: 28, color: color),
          const SizedBox(width: 4),
          Text(
            '+$amount',
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
