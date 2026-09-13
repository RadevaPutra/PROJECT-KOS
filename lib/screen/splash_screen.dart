import 'dart:async';
import 'package:flutter/material.dart';
import '../main.dart'; // Adjust path if MainNavigation is in another file

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    
    // Setup animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Scale animation (bouncing effect)
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut, // Membuat animasi rumah sedikit membal
      ),
    );

    // Fade-in animation
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn), // Mulai dari transparan
      ),
    );

    // Start the animation
    _controller.forward();

    // Berpindah ke Halaman Utama setelah 3.5 detik
    Timer(const Duration(milliseconds: 3500), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const MainNavigation(isLoggedIn: false),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(seconds: 1), 
          )
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Latar belakang putih bersih
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animasi Rumah menggunakan Icon bawaan Flutter agar aman!
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _opacityAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: child,
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFF58220).withOpacity(0.1), // Lingkaran oranye pudar
                ),
                child: const Icon(
                  Icons.other_houses_rounded, // Icon rumah modern
                  size: 130, // Ukuran besar
                  color: Color(0xFFF58220), // Warna oranye utama
                ),
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Nama Aplikasi Animasi Fade
            FadeTransition(
              opacity: _opacityAnimation,
              child: const Text(
                "SobatKos",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  color: Color(0xFF3577AD), // Warna biru logo
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Indikator loading halus di bagian bawah
            FadeTransition(
              opacity: _opacityAnimation,
              child: const SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF58220)),
                  strokeWidth: 3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
