import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:workout_list/screens/main_screen.dart';
import 'package:workout_list/utils/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _positionAnimation;
  final LocalAuthentication auth = LocalAuthentication();
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.5, curve: Curves.easeIn),
      ),
    );

    _positionAnimation =
        Tween<Offset>(begin: const Offset(0, 1), end: const Offset(0, 0))
            .animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    final canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    if (!canAuthenticateWithBiometrics) return;
    if (_isAuthenticating) return;

    setState(() {
      _isAuthenticating = true;
    });

    try {
      bool isBiometricSupported = await auth.isDeviceSupported();
      if (isBiometricSupported) {
        bool authenticated = await auth.authenticate(
            localizedReason: 'Please authenticate to proceed',
            options: const AuthenticationOptions(
              biometricOnly: true,
              stickyAuth: true,
            ));

        if (authenticated) {
          _navigateToHome();
        } else {
          print("Cancel it");
          SystemNavigator.pop();
        }
      } else {
        _navigateToHome();
      }
    } catch (e) {
      _navigateToHome();
      print('Authentication error: $e');
    } finally {
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const MainScreen()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Stack(
          children: [
            Center(
              child: FadeTransition(
                opacity: _opacityAnimation,
                child: const Text(
                  'Workout Tracker',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: _positionAnimation.value.dy * 100,
              left: 0,
              right: 0,
              child: const Center(
                child: Text(
                  'Get Fit!',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
