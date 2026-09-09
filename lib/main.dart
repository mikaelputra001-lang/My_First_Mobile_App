import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _pageBackground = Color(0xFFFCF7F8);
const _cookieBrown = Color(0xFF7A4D3D);
const _cookieInk = Color(0xFF211614);
const _cookieMuted = Color(0xFF907E77);
const _cookieBlush = Color(0xFFF5EBEE);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: _pageBackground,
        colorScheme:
            ColorScheme.fromSeed(
              seedColor: _cookieBrown,
              brightness: Brightness.light,
            ).copyWith(
              primary: _cookieBrown,
              onPrimary: Colors.white,
              surface: _pageBackground,
            ),
        appBarTheme: const AppBarTheme(
          backgroundColor: _pageBackground,
          foregroundColor: _cookieInk,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: const BorderSide(color: Color(0xFFE5D9DC)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: const BorderSide(color: Color(0xFFE5D9DC)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: const BorderSide(color: _cookieBrown, width: 1.5),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _cookieBrown,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.2,
            ),
          ),
        ),
        drawerTheme: const DrawerThemeData(
          backgroundColor: _pageBackground,
          surfaceTintColor: Colors.transparent,
        ),
      ),
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
  bool _obscurePassword = true;

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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: _pageBackground,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(28, 24, 28, 14),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 38,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 84),
                      const Center(child: _CookieMark(size: 150)),
                      const SizedBox(height: 22),
                      const Text(
                        'COOKIE',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _cookieBrown,
                          fontSize: 29,
                          height: 0.95,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const Text(
                        'CLICKER',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _cookieInk,
                          fontSize: 29,
                          height: 0.95,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 28),
                      const _FormLabel('BAKER NICKNAME'),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _usernameController,
                        textInputAction: TextInputAction.next,
                        onChanged: (_) {
                          if (_isUsernameWrong) {
                            setState(() => _isUsernameWrong = false);
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'username',
                          prefixIcon: const Icon(Icons.person_outline),
                          errorText: _isUsernameWrong
                              ? 'Username tidak sesuai'
                              : null,
                        ),
                      ),
                      const SizedBox(height: 18),
                      const _FormLabel('SECRET RECIPE'),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _login(),
                        onChanged: (_) {
                          if (_isPasswordWrong) {
                            setState(() => _isPasswordWrong = false);
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            tooltip: _obscurePassword
                                ? 'Tampilkan password'
                                : 'Sembunyikan password',
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                            onPressed: () {
                              setState(
                                () => _obscurePassword = !_obscurePassword,
                              );
                            },
                          ),
                          errorText: _isPasswordWrong
                              ? 'Password tidak sesuai'
                              : null,
                        ),
                      ),
                      const SizedBox(height: 94),
                      ElevatedButton(
                        onPressed: _login,
                        child: const Text('START BAKING'),
                      ),
                      const SizedBox(height: 14),
                      Center(
                        child: Text.rich(
                          TextSpan(
                            text: 'New Baker? ',
                            style: const TextStyle(color: _cookieMuted),
                            children: [
                              TextSpan(
                                text: 'Join the Bakery',
                                style: const TextStyle(
                                  color: _cookieBrown,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _FormLabel extends StatelessWidget {
  const _FormLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: _cookieMuted,
        fontSize: 11,
        fontWeight: FontWeight.w900,
        letterSpacing: 0.2,
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
  bool _isDoubleCookieEnabled = false;
  bool _hasAutoBaking = false;
  bool _isAutoBakingEnabled = false;
  bool _hasCookieRoulette = false;
  bool _isCookieRouletteEnabled = false;
  bool _isRouletteBonus = false;
  int _rouletteClickCount = 0;
  int _nextPopId = 0;
  final List<_CookiePopData> _activePops = [];
  final List<Timer> _popTimers = [];
  final _random = Random();
  final List<AudioPlayer> _activeSfxPlayers = [];
  bool _jackpotSoundActive = false;
  bool _ovenSfxPlaying = false;
  bool _soundEnabled = true;
  AudioPlayer? _jackpotPlayer;
  Timer? _pressTimer;
  Timer? _autoBakingTimer;
  Timer? _rouletteFlashTimer;

  // ===== Cookie increment logic =====
  void _incrementCookie() {
    unawaited(_playRegularSfx('eatingSFX.mp3'));
    _addCookies(_isDoubleCookieEnabled ? 2 : 1);
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

  // ===== Sound mixing and jackpot priority =====
  Future<void> _playRegularSfx(String fileName) async {
    if (!_soundEnabled || _jackpotSoundActive) {
      return;
    }

    final player = AudioPlayer();
    _activeSfxPlayers.add(player);
    try {
      for (final activePlayer in _activeSfxPlayers) {
        if (activePlayer != player) {
          await activePlayer.setVolume(0.35);
        }
      }
      await player.setReleaseMode(ReleaseMode.stop);
      await player.setVolume(1.0);
      await player.play(AssetSource('audio/$fileName', mimeType: 'audio/mpeg'));
      await Future.any<void>([
        player.onPlayerComplete.first,
        Future<void>.delayed(const Duration(seconds: 10)),
      ]);
    } catch (error) {
      debugPrint('SFX gagal diputar ($fileName): $error');
    } finally {
      _activeSfxPlayers.remove(player);
      await player.dispose();
      if (_activeSfxPlayers.isNotEmpty && !_jackpotSoundActive) {
        await _activeSfxPlayers.last.setVolume(1.0);
      }
    }
  }

  Future<void> _playJackpotSfx(String fileName) async {
    if (!_soundEnabled) {
      return;
    }

    _jackpotSoundActive = true;
    final activePlayers = List<AudioPlayer>.from(_activeSfxPlayers);
    _activeSfxPlayers.clear();
    for (final player in activePlayers) {
      unawaited(_stopAndDispose(player));
    }

    final jackpotPlayer = AudioPlayer();
    _jackpotPlayer = jackpotPlayer;
    try {
      await jackpotPlayer.setReleaseMode(ReleaseMode.stop);
      await jackpotPlayer.setVolume(1.0);
      await jackpotPlayer.play(
        AssetSource('audio/$fileName', mimeType: 'audio/mpeg'),
      );
      await Future.any<void>([
        jackpotPlayer.onPlayerComplete.first,
        Future<void>.delayed(const Duration(seconds: 10)),
      ]);
    } catch (error) {
      debugPrint('SFX jackpot gagal diputar ($fileName): $error');
    } finally {
      await jackpotPlayer.dispose();
      if (identical(_jackpotPlayer, jackpotPlayer)) {
        _jackpotPlayer = null;
      }
      _jackpotSoundActive = false;
    }
  }

  Future<void> _stopAndDispose(AudioPlayer player) async {
    try {
      await player.stop();
    } catch (_) {
      // The player may have completed at the same time.
    }
    try {
      await player.dispose();
    } catch (_) {
      // It is safe to continue if another cleanup already disposed it.
    }
  }

  void _setSoundEnabled(bool enabled) {
    setState(() => _soundEnabled = enabled);
    if (!enabled) {
      _jackpotSoundActive = false;
      final activePlayers = List<AudioPlayer>.from(_activeSfxPlayers);
      _activeSfxPlayers.clear();
      for (final player in activePlayers) {
        unawaited(_stopAndDispose(player));
      }
      final jackpotPlayer = _jackpotPlayer;
      _jackpotPlayer = null;
      if (jackpotPlayer != null) {
        unawaited(_stopAndDispose(jackpotPlayer));
      }
    }
  }

  // Auto Baking gets at most one ding at a time, preventing laggy overlap.
  Future<void> _playOvenDingSfx() async {
    if (_ovenSfxPlaying || _jackpotSoundActive) {
      return;
    }

    _ovenSfxPlaying = true;
    try {
      await _playRegularSfx('ovenDing.mp3');
    } finally {
      _ovenSfxPlaying = false;
    }
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
    if (!_isCookieRouletteEnabled) {
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
    unawaited(_playJackpotSfx('hakariJackpot.mp3'));

    _rouletteFlashTimer?.cancel();
    _rouletteFlashTimer = Timer(const Duration(seconds: 2), () {
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
        actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
        actions: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!isUnlocked) ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                      _tryUpgrade(upgrade);
                    },
                    child: const Text('Unlock'),
                  ),
                ),
                const SizedBox(height: 10),
              ],
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _cookieBrown,
                    side: const BorderSide(color: _cookieBrown),
                  ),
                  child: const Text('Close'),
                ),
              ),
            ],
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
          _isDoubleCookieEnabled = true;
          break;
        case _UpgradeType.autoBaking:
          _hasAutoBaking = true;
          _isAutoBakingEnabled = true;
          break;
        case _UpgradeType.cookieRoulette:
          _hasCookieRoulette = true;
          _isCookieRouletteEnabled = true;
          _rouletteClickCount = 0;
          break;
      }
    });
    unawaited(_playRegularSfx('Low Honor RDR.mp3'));
    // === Start auto-baking timer if unlocked ===
    if (upgrade == _UpgradeType.autoBaking) {
      _autoBakingTimer ??= Timer.periodic(const Duration(seconds: 1), (_) {
        if (!_isAutoBakingEnabled) {
          return;
        }
        _addCookies(1);
        unawaited(_playOvenDingSfx());
      });
    }
    Navigator.pop(context);
  }

  void _setUpgradeEnabled(_UpgradeType upgrade, bool enabled) {
    if (!_isUnlocked(upgrade)) {
      return;
    }

    setState(() {
      switch (upgrade) {
        case _UpgradeType.doubleCookie:
          _isDoubleCookieEnabled = enabled;
          break;
        case _UpgradeType.autoBaking:
          _isAutoBakingEnabled = enabled;
          break;
        case _UpgradeType.cookieRoulette:
          _isCookieRouletteEnabled = enabled;
          if (!enabled) {
            _isRouletteBonus = false;
          }
          break;
      }
    });
  }

  // ===== Upgrade unlock check =====
  bool _isUnlocked(_UpgradeType upgrade) {
    return switch (upgrade) {
      _UpgradeType.doubleCookie => _hasDoubleCookie,
      _UpgradeType.autoBaking => _hasAutoBaking,
      _UpgradeType.cookieRoulette => _hasCookieRoulette,
    };
  }

  bool _isUpgradeEnabled(_UpgradeType upgrade) {
    return switch (upgrade) {
      _UpgradeType.doubleCookie => _isDoubleCookieEnabled,
      _UpgradeType.autoBaking => _isAutoBakingEnabled,
      _UpgradeType.cookieRoulette => _isCookieRouletteEnabled,
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
    for (final player in _activeSfxPlayers) {
      unawaited(player.dispose());
    }
    super.dispose();
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: _pageBackground,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        drawer: Drawer(
          width: min(340.0, MediaQuery.sizeOf(context).width * 0.86),
          child: SafeArea(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                Container(
                  height: 164,
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 22),
                  color: _cookieBrown,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.cookie_outlined,
                        color: Colors.white,
                        size: 34,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'COOKIE CLICKER',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Bake your way to the top',
                        style: TextStyle(
                          color: Color(0xFFEBD8D1),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                SwitchListTile.adaptive(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  secondary: Icon(
                    _soundEnabled
                        ? Icons.volume_up_outlined
                        : Icons.volume_off_outlined,
                    color: _cookieBrown,
                  ),
                  title: const Text(
                    'Sound effects',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: const Text('Game audio'),
                  value: _soundEnabled,
                  onChanged: _setSoundEnabled,
                ),
                const Divider(height: 1, indent: 20, endIndent: 20),
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 22, 20, 8),
                  child: Text(
                    'UPGRADES',
                    style: TextStyle(
                      color: _cookieMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                for (final upgrade in _UpgradeType.values)
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    leading: Icon(
                      _isUnlocked(upgrade)
                          ? Icons.check_circle_outline
                          : Icons.lock_outline,
                      color: _isUnlocked(upgrade) ? _cookieBrown : _cookieMuted,
                    ),
                    title: Text(
                      upgrade.title,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(
                      '${upgrade.requiredCookies} cookie untuk unlock',
                    ),
                    trailing: Switch.adaptive(
                      value: _isUpgradeEnabled(upgrade),
                      onChanged: _isUnlocked(upgrade)
                          ? (enabled) => _setUpgradeEnabled(upgrade, enabled)
                          : null,
                    ),
                    onTap: () => _showUpgradeInfo(upgrade),
                  ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 68,
                child: Row(
                  children: [
                    Builder(
                      builder: (context) => IconButton(
                        tooltip: 'Open menu',
                        icon: const Icon(Icons.menu, size: 25),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'COOKIE CLICKER',
                          style: TextStyle(
                            color: _cookieInk,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Logout',
                      icon: const Icon(Icons.logout_outlined, size: 24),
                      onPressed: _logout,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: _isRouletteBonus ? null : _pageBackground,
                    gradient: _isRouletteBonus
                        ? const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF80520A),
                              Color(0xFFD4A72C),
                              Color(0xFFFFE7A0),
                              Color(0xFFD4A72C),
                              Color(0xFF80520A),
                            ],
                            stops: [0.0, 0.28, 0.5, 0.72, 1.0],
                          )
                        : null,
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 280,
                              height: 258,
                              child: Stack(
                                alignment: Alignment.center,
                                clipBehavior: Clip.none,
                                children: [
                                  GestureDetector(
                                    onTap: _incrementCookie,
                                    child: AnimatedScale(
                                      scale: _isCookiePressed ? 0.82 : 1,
                                      duration: const Duration(
                                        milliseconds: 100,
                                      ),
                                      curve: Curves.easeOut,
                                      child: _CookieMark(
                                        size: min(
                                          220.0,
                                          constraints.maxWidth * 0.66,
                                        ),
                                        cookieColor: _isRouletteBonus
                                            ? Colors.amber.shade700
                                            : _cookieBrown,
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
                            const SizedBox(height: 4),
                            Text(
                              'Cookies: $_cookieCount',
                              style: const TextStyle(
                                color: _cookieInk,
                                fontSize: 34,
                                height: 1,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '+${_isDoubleCookieEnabled ? 2 : 1} per click',
                              style: const TextStyle(
                                color: _cookieBrown,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CookieMark extends StatelessWidget {
  const _CookieMark({required this.size, this.cookieColor = _cookieBrown});

  final double size;
  final Color cookieColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: _cookieBlush,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 20,
            offset: Offset(0, 12),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Icon(Icons.cookie, size: size * 0.72, color: cookieColor),
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
