import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raion_hackjam/core/theme/app_colors.dart';

class XpProgressBar extends StatelessWidget {
  final int currentXp;
  final int maxXp;
  final int level;

  const XpProgressBar({
    super.key,
    required this.currentXp,
    required this.maxXp,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    final double progress =
        maxXp > 0 ? (currentXp / maxXp).clamp(0.0, 1.0) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Level $level',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
            Text(
              '$currentXp / $maxXp XP',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Container(
                    height: 10,
                    width: constraints.maxWidth,
                    color: AppColors.surfaceVariant,
                  ),
                  Container(
                    height: 10,
                    width: constraints.maxWidth * progress,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.primaryLight,
                          AppColors.primary,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  )
                      .animate()
                      .scaleX(
                        begin: 0.0,
                        end: 1.0,
                        alignment: Alignment.centerLeft,
                        duration: 600.ms,
                        curve: Curves.easeOutCubic,
                      ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
