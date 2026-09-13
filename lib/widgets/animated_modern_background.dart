import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;

class AnimatedModernBackground extends StatefulWidget {
  final Widget? child;
  const AnimatedModernBackground({super.key, this.child});

  @override
  State<AnimatedModernBackground> createState() => _AnimatedModernBackgroundState();
}

class _AnimatedModernBackgroundState extends State<AnimatedModernBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20), // Slower, more elegant animation
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            // Soft Light Base Background
            Container(color: const Color(0xFFFAFAFA)), 
            
            // Orange Blob (Primary Logo Color)
            Positioned(
              top: size.height * -0.2 + math.sin(_controller.value * 2 * math.pi) * 120,
              left: size.width * -0.3 + math.cos(_controller.value * 2 * math.pi) * 120,
              child: _buildBlob(const Color(0xFFF58220), size.width * 1.5, 0.15),
            ),
            
            // Blue Blob (Secondary Logo Color)
            Positioned(
              bottom: size.height * -0.2 + math.cos(_controller.value * 2 * math.pi + math.pi / 2) * 150,
              right: size.width * -0.3 + math.sin(_controller.value * 2 * math.pi + math.pi / 2) * 150,
              child: _buildBlob(const Color(0xFF3577AD), size.width * 1.6, 0.10),
            ),
            
            // Soft Orange Blob (Accent)
            Positioned(
              top: size.height * 0.4 + math.sin(_controller.value * 2 * math.pi + math.pi) * 100,
              right: size.width * -0.1 + math.cos(_controller.value * 2 * math.pi + math.pi) * 100,
              child: _buildBlob(const Color(0xFFF39C12), size.width * 1.2, 0.10),
            ),

            // Light Blue Accent (Soft Glow)
            Positioned(
              bottom: size.height * 0.2 + math.sin(_controller.value * 2 * math.pi + 1.5 * math.pi) * 80,
              left: size.width * 0.1 + math.cos(_controller.value * 2 * math.pi + 1.5 * math.pi) * 80,
              child: _buildBlob(const Color(0xFF85C1E9), size.width * 0.8, 0.10),
            ),

            // Glassmorphism Overlay (Light)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 120, sigmaY: 120),
                child: Container(
                  color: Colors.white.withOpacity(0.4),
                ),
              ),
            ),
            
            if (widget.child != null) Positioned.fill(child: widget.child!),
          ],
        );
      },
    );
  }

  Widget _buildBlob(Color color, double size, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            color.withOpacity(opacity),
            color.withOpacity(0),
          ],
        ),
        shape: BoxShape.circle,
      ),
    );
  }
}
