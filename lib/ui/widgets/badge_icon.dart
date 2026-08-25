import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raion_hackjam/core/theme/app_colors.dart';
import 'package:raion_hackjam/data/models/badge_model.dart';

class BadgeIcon extends StatelessWidget {
  final BadgeModel badge;
  final bool isUnlocked;

  const BadgeIcon({
    super.key,
    required this.badge,
    required this.isUnlocked,
  });

  @override
  Widget build(BuildContext context) {
    final Widget badgeCircle = Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isUnlocked ? AppColors.warningLight : const Color(0xFFE5E7EB),
        border: Border.all(
          color: isUnlocked ? AppColors.accent : AppColors.border,
          width: 2,
        ),
      ),
      child: Center(
        child: badge.iconUrl != null && badge.iconUrl!.isNotEmpty
            ? Image.network(
                badge.iconUrl!,
                width: 36,
                height: 36,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.emoji_events,
                  size: 32,
                  color: isUnlocked ? AppColors.accentDark : AppColors.textTertiary,
                ),
              )
            : Icon(
                Icons.emoji_events,
                size: 32,
                color: isUnlocked ? AppColors.accentDark : AppColors.textTertiary,
              ),
      ),
    );

    final Widget renderedBadge = isUnlocked
        ? badgeCircle
        : ColorFiltered(
            colorFilter: const ColorFilter.matrix(<double>[
              0.2126, 0.7152, 0.0722, 0, 0,
              0.2126, 0.7152, 0.0722, 0, 0,
              0.2126, 0.7152, 0.0722, 0, 0,
              0,      0,      0,      0.6, 0,
            ]),
            child: badgeCircle,
          );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        renderedBadge,
        const SizedBox(height: 6),
        SizedBox(
          width: 80,
          child: Text(
            badge.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: isUnlocked ? FontWeight.w600 : FontWeight.w400,
              color: isUnlocked ? AppColors.textPrimary : AppColors.textTertiary,
            ),
          ),
        ),
      ],
    );
  }
}
