import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raion_hackjam/core/theme/app_colors.dart';
import 'package:raion_hackjam/data/models/quest_model.dart';
import 'package:raion_hackjam/ui/widgets/app_card.dart';

class QuestTile extends StatelessWidget {
  final QuestModel quest;
  final VoidCallback? onTap;
  final void Function(QuestStatus)? onStatusChange;

  const QuestTile({
    super.key,
    required this.quest,
    this.onTap,
    this.onStatusChange,
  });

  QuestStatus _getNextStatus(QuestStatus current) {
    switch (current) {
      case QuestStatus.notStarted:
        return QuestStatus.inProgress;
      case QuestStatus.inProgress:
        return QuestStatus.completed;
      case QuestStatus.completed:
        return QuestStatus.notStarted;
    }
  }

  (Color, Color, String) _getStatusAttributes(QuestStatus status) {
    switch (status) {
      case QuestStatus.notStarted:
        return (const Color(0xFFF3F4F6), AppColors.textSecondary, 'Not Started');
      case QuestStatus.inProgress:
        return (AppColors.warningLight, AppColors.accentDark, 'In Progress');
      case QuestStatus.completed:
        return (AppColors.successLight, AppColors.success, 'Completed');
    }
  }

  @override
  Widget build(BuildContext context) {
    final typeIcon = quest.type == QuestType.regular ? '⚔️' : '🔄';
    final (statusBg, statusTextColor, statusText) =
        _getStatusAttributes(quest.status);

    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                typeIcon,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  quest.title,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.warningLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '+${quest.xpReward} XP',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.accentDark,
                  ),
                ),
              ),
            ],
          ),
          if (quest.description != null && quest.description!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Text(
                quest.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox.shrink(),
              GestureDetector(
                onTap: onStatusChange != null
                    ? () => onStatusChange!(_getNextStatus(quest.status))
                    : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    statusText,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: statusTextColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
