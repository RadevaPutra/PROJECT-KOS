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
            // Luxury dark base background
            Container(color: const Color(0xFF110D0A)), 
            
            // Goldenrod Blob (Primary)
            Positioned(
              top: size.height * -0.2 + math.sin(_controller.value * 2 * math.pi) * 120,
              left: size.width * -0.3 + math.cos(_controller.value * 2 * math.pi) * 120,
              child: _buildBlob(const Color(0xFFDAA520), size.width * 1.5, 0.3),
            ),
            
            // BurlyWood Blob (Secondary)
            Positioned(
              bottom: size.height * -0.2 + math.cos(_controller.value * 2 * math.pi + math.pi / 2) * 150,
              right: size.width * -0.3 + math.sin(_controller.value * 2 * math.pi + math.pi / 2) * 150,
              child: _buildBlob(const Color(0xFFDEB887), size.width * 1.6, 0.25),
            ),
            
            // Dark Goldenrod Blob (Accent)
            Positioned(
              top: size.height * 0.4 + math.sin(_controller.value * 2 * math.pi + math.pi) * 100,
              right: size.width * -0.1 + math.cos(_controller.value * 2 * math.pi + math.pi) * 100,
              child: _buildBlob(const Color(0xFFB8860B), size.width * 1.2, 0.2),
            ),

            // SaddleBrown Accent (Soft Glow)
            Positioned(
              bottom: size.height * 0.2 + math.sin(_controller.value * 2 * math.pi + 1.5 * math.pi) * 80,
              left: size.width * 0.1 + math.cos(_controller.value * 2 * math.pi + 1.5 * math.pi) * 80,
              child: _buildBlob(const Color(0xFF8B4513), size.width * 0.8, 0.15),
            ),

            // Glassmorphism Overlay with high blur
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 120, sigmaY: 120),
                child: Container(
                  color: Colors.black.withOpacity(0.35),
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
