import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../main.dart'; // To access MainNavigation
import '../widgets/custom_route.dart'; // To access SlideRoute or simple pushReplacement

class VideoSplashScreen extends StatefulWidget {
  const VideoSplashScreen({Key? key}) : super(key: key);

  @override
  State<VideoSplashScreen> createState() => _VideoSplashScreenState();
}

class _VideoSplashScreenState extends State<VideoSplashScreen> {
  late VideoPlayerController _controller;
  String? _errorMsg;

  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    
    // Fallback if video takes too long to load or play (e.g. on web)
    Future.delayed(const Duration(seconds: 5), () {
      if (!_navigated && mounted) {
        print("Video load timeout or ended early, navigating home");
        _navigateToHome();
      }
    });

    // Menggunakan URL jaringan sementara karena asset VideoPlayer kadang bermasalah di Web tanpa setup spesifik
    _controller = VideoPlayerController.networkUrl(Uri.parse('https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4'))
      ..initialize().then((_) {
        // Mute video agar browser mengizinkan autoplay
        _controller.setVolume(0.0);
        setState(() {});
        _controller.play();
        
        _controller.addListener(() {
          if (_controller.value.position >= _controller.value.duration) {
            _navigateToHome();
          }
        });
      }).catchError((err) {
        // If there's an error, fallback immediately to the home screen
        print("Video init error: $err");
        setState(() {
          _errorMsg = err.toString();
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
            _navigateToHome();
        });
      });
  }

  void _navigateToHome() {
    if (_navigated) return;
    _navigated = true;
    _controller.removeListener(() {});
    
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Allow background to show if any
      body: Center(
        child: _errorMsg != null
          ? Text("Error loading video: $_errorMsg", style: const TextStyle(color: Colors.red))
          : _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : const CircularProgressIndicator(color: Color(0xFFF58220)),
      ),
      // Tombol Skip (opsional) agar user yang tidak berminat menonton hingga usai dapat melewatinya.
      floatingActionButton: _controller.value.isInitialized 
        ? FloatingActionButton.extended(
            backgroundColor: Colors.white.withOpacity(0.8),
            onPressed: () {
              _controller.pause();
              _navigateToHome();
            },
            label: const Text("Skip", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
            icon: const Icon(Icons.skip_next, color: Colors.black87),
          )
        : null,
    );
  }
}
