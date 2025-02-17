  import 'package:flutter/material.dart';
  import 'package:lottie/lottie.dart';
import 'home_page.dart';

  class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

    @override
    // ignore: library_private_types_in_public_api
    _SplashScreenState createState() => _SplashScreenState();
  }

  class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
    @override
    void initState() {
      super.initState();
      Future.delayed(const Duration(seconds: 7), () {
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const HomePage(),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      });
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade900, Colors.blue.shade500],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/lottie/splash.json',
                  width: 400,
                  height: 400,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Döviz Takip Uygulaması",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
