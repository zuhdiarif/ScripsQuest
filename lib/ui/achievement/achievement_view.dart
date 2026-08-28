import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:raion_hackjam/core/theme/app_colors.dart';
import 'package:raion_hackjam/ui/achievement/achievement_viewmodel.dart';

class AchievementView extends StatelessWidget {
  const AchievementView({super.key});

  @override
  Widget build(BuildContext context) {
    context.watch<AchievementViewModel>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Pencapaian',
          style: GoogleFonts.cinzel(
            fontWeight: FontWeight.w700,
            color: AppColors.yellowNormal,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.purpleGradient,
        ),
        child: Center(
          child: Text(
            'Coming Soon',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
