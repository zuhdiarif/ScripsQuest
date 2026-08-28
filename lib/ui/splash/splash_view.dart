import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:raion_hackjam/core/constants/app_assets.dart';
import 'package:raion_hackjam/core/constants/app_routes.dart';
import 'package:raion_hackjam/ui/auth/auth_viewmodel.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  int _currentFrame = 0;
  Timer? _timer;

  final List<String> _frames = const [
    AppAssets.splashFrame1,
    AppAssets.splashFrame2,
    AppAssets.splashFrame3,
    AppAssets.splashFrame4,
    AppAssets.splashFrame5,
  ];

  @override
  void initState() {
    super.initState();
    _startAnimationSequence();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (final frame in _frames) {
      precacheImage(AssetImage(frame), context);
    }
  }

  void _startAnimationSequence() {
    _timer = Timer.periodic(const Duration(milliseconds: 400), (timer) {
      if (_currentFrame < _frames.length - 1) {
        setState(() {
          _currentFrame++;
        });
      } else {
        timer.cancel();
        _navigateNext();
      }
    });
  }

  void _navigateNext() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!mounted) return;

      final authViewModel = context.read<AuthViewModel>();
      if (authViewModel.isAuthenticated) {
        context.go(AppRoutes.home);
      } else {
        context.go(AppRoutes.onboarding);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F0F1A),
              Color(0xFF1B1A38),
              Color(0xFF272454),
            ],
          ),
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.96, end: 1.0).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
                  child: child,
                ),
              );
            },
            child: SizedBox(
              key: ValueKey<int>(_currentFrame),
              width: 240,
              height: 240,
              child: Image.asset(
                _frames[_currentFrame],
                fit: BoxFit.contain,
              ),
            ),
          )
              .animate(
                onPlay: (controller) => controller.repeat(reverse: true),
              )
              .shimmer(
                delay: 2000.ms,
                duration: 1500.ms,
                color: Colors.white.withValues(alpha: 0.15),
              ),
        ),
      ),
    );
  }
}
