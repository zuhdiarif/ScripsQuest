import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raion_hackjam/core/theme/app_colors.dart';
import 'package:raion_hackjam/ui/widgets/app_card.dart';

class StreakCalendar extends StatelessWidget {
  final List<DateTime> streakHistory;
  final int currentStreak;

  const StreakCalendar({
    super.key,
    required this.streakHistory,
    required this.currentStreak,
  });

  bool _isDayActive(DateTime day) {
    return streakHistory.any(
      (historyDate) =>
          historyDate.year == day.year &&
          historyDate.month == day.month &&
          historyDate.day == day.day,
    );
  }

  List<DateTime> _getCurrentWeekDays() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final mondayOffset = today.weekday - DateTime.monday;
    final monday = today.subtract(Duration(days: mondayOffset));
    return List.generate(7, (index) => monday.add(Duration(days: index)));
  }

  @override
  Widget build(BuildContext context) {
    final weekDays = _getCurrentWeekDays();
    final dayNames = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    '🔥',
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$currentStreak Day Streak',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Text(
                'Keep going!',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.streakFlame,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (index) {
              final day = weekDays[index];
              final isActive = _isDayActive(day);

              return Column(
                children: [
                  Text(
                    dayNames[index],
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive ? AppColors.streakFlame : Colors.transparent,
                      border: Border.all(
                        color: isActive
                            ? AppColors.streakFlame
                            : AppColors.border,
                        width: 1.5,
                      ),
                    ),
                    child: isActive
                        ? const Icon(
                            Icons.check,
                            size: 18,
                            color: AppColors.textWhite,
                          )
                        : null,
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
