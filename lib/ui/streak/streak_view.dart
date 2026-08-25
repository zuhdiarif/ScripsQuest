import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:raion_hackjam/core/theme/app_colors.dart';
import 'package:raion_hackjam/ui/streak/streak_viewmodel.dart';

class StreakView extends StatelessWidget {
  const StreakView({super.key});

  @override
  Widget build(BuildContext context) {
    context.watch<StreakViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Streak',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Center(
        child: Text(
          'Coming Soon',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
