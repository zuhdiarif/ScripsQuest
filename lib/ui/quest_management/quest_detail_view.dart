import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:raion_hackjam/core/constants/app_assets.dart';
import 'package:raion_hackjam/core/constants/app_routes.dart';
import 'package:raion_hackjam/core/theme/app_colors.dart';
import 'package:raion_hackjam/data/models/quest_model.dart';
import 'package:raion_hackjam/ui/quest_management/quest_management_viewmodel.dart';
import 'package:raion_hackjam/ui/widgets/app_button.dart';

class QuestDetailView extends StatefulWidget {
  final QuestModel quest;

  const QuestDetailView({
    super.key,
    required this.quest,
  });

  @override
  State<QuestDetailView> createState() => _QuestDetailViewState();
}

class _QuestDetailViewState extends State<QuestDetailView> {
  late QuestModel _currentQuest;

  @override
  void initState() {
    super.initState();
    _currentQuest = widget.quest;
  }

  Future<void> _completeQuest() async {
    final vm = context.read<QuestManagementViewModel>();
    final success = await vm.updateQuestStatus(
      _currentQuest.id,
      QuestStatus.completed,
    );

    if (!mounted) return;

    if (success) {
      setState(() {
        _currentQuest = _currentQuest.copyWith(
          status: QuestStatus.completed,
          completedAt: DateTime.now(),
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.success,
          content: Text(
            'Misi Selesai! Kamu mendapatkan +${_currentQuest.xpReward} EXP! 🏆⚔️',
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.error,
          content: Text(
            vm.errorMessage ?? 'Gagal menyelesaikan misi',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMMM yyyy');
    final formattedDate = dateFormat.format(_currentQuest.createdAt);
    final isCompleted = _currentQuest.status == QuestStatus.completed;
    final progressPercent = isCompleted ? 1.0 : (_currentQuest.status == QuestStatus.inProgress ? 0.6 : 0.0);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.purpleGradient,
        ),
        child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
                icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textWhite),
                onPressed: () => Navigator.pop(context),
              ),
              Center(
                child: Image.asset(
                  AppAssets.gate1,
                  height: 180,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.door_front_door_rounded,
                    size: 100,
                    color: AppColors.purpleNormal,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  _currentQuest.title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cinzel(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.yellowNormal,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.purpleLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _currentQuest.feedbackNote ?? '-',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.purpleDarker,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Center(
                child: Text(
                  _currentQuest.description ??
                      'Setiap misi mendekatkanmu ke gelar sarjana! Selesaikan quest ini untuk meraih EXP.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progress',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textWhite,
                    ),
                  ),
                  Text(
                    '${(progressPercent * 100).toInt()}%',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textWhite,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: progressPercent,
                  minHeight: 8,
                  backgroundColor: AppColors.grey700,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.purpleNormal),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Keterangan',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textWhite,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _buildInfoRow('Status', _buildStatusBadge(_currentQuest.status)),
                    const Divider(color: AppColors.grey800, height: 20),
                    _buildInfoRow(
                      'Dibuat',
                      Text(
                        formattedDate,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.textWhite,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Divider(color: AppColors.grey800, height: 20),
                    _buildInfoRow(
                      'Quest ID',
                      Text(
                        _currentQuest.id.isEmpty
                            ? 'Q-LR-${_currentQuest.questOrder.toString().padLeft(3, '0')}'
                            : 'Q-${_currentQuest.id.substring(0, 6).toUpperCase()}',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Divider(color: AppColors.grey800, height: 20),
                    _buildInfoRow(
                      'Imbalan',
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.yellowDark.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.yellowNormal),
                        ),
                        child: Text(
                          '+${_currentQuest.xpReward} XP',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.yellowNormal,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Catatan (Opsional)',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textWhite,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  _currentQuest.feedbackNote ?? 'Belum ada catatan khusus untuk misi ini.',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              AppButton(
                text: isCompleted ? 'Misi Sudah Selesai ✅' : 'Misi Selesai',
                isLoading: context.watch<QuestManagementViewModel>().isLoading,
                onPressed: isCompleted ? null : _completeQuest,
              ),
              const SizedBox(height: 12),
              AppButton(
                text: 'Ubah Misi',
                backgroundColor: AppColors.white50,
                textColor: AppColors.purpleDarker,
                onPressed: () {
                  context.push(AppRoutes.questEdit, extra: _currentQuest).then((_) {
                    if (mounted) setState(() {});
                  });
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    ),
  );
  }

  Widget _buildInfoRow(String label, Widget trailing) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        trailing,
      ],
    );
  }

  Widget _buildStatusBadge(QuestStatus status) {
    Color dotColor;
    String label;

    switch (status) {
      case QuestStatus.completed:
        dotColor = AppColors.success;
        label = 'Completed';
        break;
      case QuestStatus.inProgress:
        dotColor = AppColors.yellowNormal;
        label = 'In Progress';
        break;
      case QuestStatus.notStarted:
        dotColor = AppColors.grey300;
        label = 'Not Started';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.grey800,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textWhite,
            ),
          ),
        ],
      ),
    );
  }
}
