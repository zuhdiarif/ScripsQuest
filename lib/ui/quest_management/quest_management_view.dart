import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:raion_hackjam/core/constants/app_assets.dart';
import 'package:raion_hackjam/core/constants/app_routes.dart';
import 'package:raion_hackjam/core/theme/app_colors.dart';
import 'package:raion_hackjam/data/models/quest_model.dart';
import 'package:raion_hackjam/ui/auth/auth_viewmodel.dart';
import 'package:raion_hackjam/ui/quest_management/quest_management_viewmodel.dart';
import 'package:raion_hackjam/ui/widgets/app_bottom_nav_bar.dart';
import 'package:raion_hackjam/ui/widgets/app_button.dart';
import 'package:raion_hackjam/ui/widgets/app_segmented_control.dart';

class QuestManagementView extends StatefulWidget {
  const QuestManagementView({super.key});

  @override
  State<QuestManagementView> createState() => _QuestManagementViewState();
}

class _QuestManagementViewState extends State<QuestManagementView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authViewModel = context.read<AuthViewModel>();
      final userId = authViewModel.currentUser?.id ?? '';
      if (userId.isNotEmpty) {
        context.read<QuestManagementViewModel>().loadQuests(userId);
      }
    });
  }

  void _reloadQuests() {
    final authViewModel = context.read<AuthViewModel>();
    final userId = authViewModel.currentUser?.id ?? '';
    if (userId.isNotEmpty && mounted) {
      context.read<QuestManagementViewModel>().loadQuests(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<QuestManagementViewModel>();
    final quests = vm.filteredQuests;

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: AppBottomNavBar(
        currentItem: AppNavItem.quest,
        onItemSelected: (item) {
          switch (item) {
            case AppNavItem.home:
              context.go(AppRoutes.home);
              break;
            case AppNavItem.quest:
              break;
            case AppNavItem.guild:
              context.go(AppRoutes.guild);
              break;
            case AppNavItem.profile:
              context.go(AppRoutes.profile);
              break;
          }
        },
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.purpleGradient,
        ),
        child: SafeArea(
          child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Daftar Misi Kamu',
                          style: GoogleFonts.cinzel(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: AppColors.yellowNormal,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Pilih misi berikutnya dan lanjutkan perjalananmu!',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceCard,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.purpleNormal),
                    ),
                    child: const Center(
                      child: Text('🧙‍♂️', style: TextStyle(fontSize: 24)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              AppSegmentedControl<String>(
                values: const ['all', 'active', 'completed'],
                labels: const ['Semua', 'Aktif', 'Selesai'],
                selectedValue: vm.selectedFilter,
                onValueChanged: (val) => vm.filterQuests(val),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: vm.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: AppColors.purpleNormal),
                      )
                    : vm.errorMessage != null && quests.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.error_outline_rounded,
                                  size: 48,
                                  color: AppColors.error,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  vm.errorMessage!,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                TextButton(
                                  onPressed: _reloadQuests,
                                  child: Text(
                                    'Coba Lagi',
                                    style: GoogleFonts.inter(
                                      color: AppColors.yellowNormal,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : quests.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.shield_outlined,
                                  size: 64,
                                  color: AppColors.grey400,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Belum ada misi pada kategori ini',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: quests.length,
                            itemBuilder: (context, index) {
                              final quest = quests[index];
                              return _buildQuestCard(quest);
                            },
                          ),
              ),
              const SizedBox(height: 12),
              AppButton(
                text: '+ Tambah Misi',
                onPressed: () {
                  context.push(AppRoutes.questEdit).then((_) {
                    _reloadQuests();
                  });
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    ),
  );
  }

  Widget _buildQuestCard(QuestModel quest) {
    final isCompleted = quest.status == QuestStatus.completed;
    final isInProgress = quest.status == QuestStatus.inProgress;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCompleted
              ? AppColors.success.withValues(alpha: 0.3)
              : (isInProgress
                  ? AppColors.purpleNormal.withValues(alpha: 0.4)
                  : Colors.transparent),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(
                AppAssets.crystal01,
                width: 32,
                height: 32,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.diamond_outlined,
                  color: AppColors.purpleNormal,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quest.title,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textWhite,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      quest.feedbackNote ?? '-',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildStatusPill(quest.status),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.push(AppRoutes.questDetail, extra: quest).then((_) {
                    _reloadQuests();
                  });
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.purpleNormal,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    color: AppColors.textWhite,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
          if (isInProgress) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: const LinearProgressIndicator(
                value: 0.6,
                minHeight: 4,
                backgroundColor: AppColors.grey700,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.purpleNormal),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusPill(QuestStatus status) {
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.grey800,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textWhite,
            ),
          ),
        ],
      ),
    );
  }
}
