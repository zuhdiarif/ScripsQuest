import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raion_hackjam/core/constants/app_assets.dart';
import 'package:raion_hackjam/core/constants/app_routes.dart';
import 'package:raion_hackjam/core/theme/app_colors.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = const [
    {
      'image': AppAssets.gate1,
      'title': 'Taklukkan Skripsi\nBagai Main Game',
      'subtitle':
          'Ubah bab dan revisi yang menumpuk menjadi quest harian yang seru. Raih EXP, naik level, dan selesaikan skripsi tanpa rasa jenuh.',
    },
    {
      'image': AppAssets.imageOnboarding2,
      'title': 'Pecah Skripsimu\nJadi Misi Kecil',
      'subtitle':
          'Bingung mulai ngerjain dari mana? Disini kamu bisa ubah jadi misi-misi kecil yang bisa kamu taklukkan satu per satu sesuai kebutuhan kamu.',
    },
    {
      'image': AppAssets.imageOnboarding3,
      'title': 'Berjuang Bersama\ndi Guild Skripsi',
      'subtitle':
          'Bentuk tim bersama teman seperjuangan, panjat papan peringkat guild, dan raih badge pencapaian hingga hari wisudamu!',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    } else {
      context.go(AppRoutes.buildQuest);
    }
  }

  void _skipToAuth() {
    context.go(AppRoutes.buildQuest);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLastPage = _currentPage == _onboardingData.length - 1;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2A214D),
              Color(0xFF221A3F),
              Color(0xFF19132E),
              Color(0xFF130F24),
            ],
            stops: [0.0, 0.35, 0.70, 1.0],
          ),
        ),
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: _onboardingData.length,
              itemBuilder: (context, index) {
                final data = _onboardingData[index];
                return _buildPageItem(data, size, index);
              },
            ),
            Positioned(
              left: 24,
              right: 24,
              bottom: MediaQuery.of(context).padding.bottom + 20,
              child: isLastPage ? _buildLastPageButtons() : _buildBottomNavigation(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageItem(Map<String, String> data, Size size, int index) {
    final isLastPage = index == _onboardingData.length - 1;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          SizedBox(
            height: size.height * 0.45,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  data['image']!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: AppColors.purpleDarker,
                    child: const Center(
                      child: Icon(
                        Icons.castle_rounded,
                        size: 80,
                        color: AppColors.purpleNormal,
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Color(0x222A214D),
                        Color(0xBB221A3F),
                        Color(0xFF221A3F),
                      ],
                      stops: [0.0, 0.40, 0.80, 1.0],
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildPageIndicator(),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                Text(
                  data['title']!,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cinzel(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textWhite,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  data['subtitle']!,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFFD4CEEE),
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: isLastPage ? 170 : 100),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _onboardingData.length,
            (index) {
              final isSelected = index == _currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 6,
                width: isSelected ? 28 : 12,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF7065D9)
                      : const Color(0xFF9E95DC).withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFE040FB), width: 2),
          ),
          child: Center(
            child: Container(
              width: 5,
              height: 5,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFE040FB),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: _skipToAuth,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.textSecondary,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: Text(
            'Lewati',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textWhite,
            ),
          ),
        ),
        GestureDetector(
          onTap: _nextPage,
          child: Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: const Color(0xFF6F65D8),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6F65D8).withValues(alpha: 0.5),
                  blurRadius: 18,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_forward_rounded,
              color: AppColors.textWhite,
              size: 26,
            ),
          ),
        )
            .animate(
              onPlay: (controller) => controller.repeat(reverse: true),
            )
            .scale(
              begin: const Offset(1.0, 1.0),
              end: const Offset(1.05, 1.05),
              duration: 800.ms,
              curve: Curves.easeInOut,
            ),
      ],
    );
  }

  Widget _buildLastPageButtons() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => context.go('${AppRoutes.auth}?mode=register&returnTo=build-quest'),
          child: Container(
            width: double.infinity,
            height: 54,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF6F65D8),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6F65D8).withValues(alpha: 0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              'Buat Akun',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textWhite,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () => context.go('${AppRoutes.auth}?mode=login'),
          child: Container(
            width: double.infinity,
            height: 54,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.white50,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              'Masuk Akun',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.purpleDarker,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
