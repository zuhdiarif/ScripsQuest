import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ph.dart';
import 'package:provider/provider.dart';
import 'package:raion_hackjam/core/constants/app_assets.dart';
import 'package:raion_hackjam/core/constants/app_routes.dart';
import 'package:raion_hackjam/core/theme/app_colors.dart';
import 'package:raion_hackjam/data/models/quest_model.dart';
import 'package:raion_hackjam/ui/auth/auth_viewmodel.dart';
import 'package:raion_hackjam/ui/home/home_viewmodel.dart';
import 'package:raion_hackjam/ui/widgets/app_bottom_nav_bar.dart';
import 'package:raion_hackjam/ui/widgets/app_button.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final List<String> _dayLetters = const ['S', 'S', 'R', 'K', 'J', 'S', 'M'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authViewModel = context.read<AuthViewModel>();
      final userId = authViewModel.currentUser?.id ?? '';
      if (userId.isNotEmpty) {
        context.read<HomeViewModel>().loadDashboard(userId);
      }
    });
  }

  void _reload() {
    final authViewModel = context.read<AuthViewModel>();
    final userId = authViewModel.currentUser?.id ?? '';
    if (userId.isNotEmpty && mounted) {
      context.read<HomeViewModel>().loadDashboard(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeViewModel = context.watch<HomeViewModel>();
    final authViewModel = context.watch<AuthViewModel>();

    final user = authViewModel.currentUser;
    final username = homeViewModel.profile?.username ??
        user?.userMetadata?['username'] ??
        'Pejuang';
    final level = homeViewModel.profile?.level ?? 1;
    final streakDays = homeViewModel.streakDays;
    final todayQuests = homeViewModel.todayQuests;
    final completedCount = homeViewModel.completedTodayCount;
    final totalCount = homeViewModel.totalTodayCount;

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: AppBottomNavBar(
        currentItem: AppNavItem.home,
        onItemSelected: (item) {
          switch (item) {
            case AppNavItem.home:
              break;
            case AppNavItem.quest:
              context.go(AppRoutes.questManagement);
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
        child: homeViewModel.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.purpleNormal),
              )
            : homeViewModel.errorMessage != null && homeViewModel.profile == null && todayQuests.isEmpty
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
                          homeViewModel.errorMessage!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: _reload,
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
                : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(username, level),
                    const SizedBox(height: 24),
                    _buildStreakSection(streakDays, homeViewModel.weekStreak),
                    const SizedBox(height: 28),
                    _buildSectionTitle(completedCount, totalCount),
                    const SizedBox(height: 16),
                    _buildQuestList(todayQuests, homeViewModel),
                    const SizedBox(height: 20),
                    AppButton(
                      text: '+ Tambah Misi',
                      onPressed: () {
                        context.push(AppRoutes.questEdit).then((_) => _reload());
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
        ),
      ),
    );
  }

  Widget _buildHeader(String username, int level) {
    return Row(
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.purpleDarker,
            border: Border.all(color: AppColors.purpleNormal, width: 2),
          ),
          child: ClipOval(
            child: Image.asset(
              AppAssets.skullSide,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Center(
                child: Icon(Icons.person, color: AppColors.yellowNormal),
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selamat Datang,',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      username,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textWhite,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.yellowLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Level $level',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.yellowDarker,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Stack(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.surfaceCard,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Iconify(
                  Ph.bell_fill,
                  color: AppColors.textWhite,
                  size: 22,
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStreakSection(int streakDays, List<bool> weekStreak) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.purpleNormal.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        children: [
          Row(
            children: [
              const Iconify(
                Ph.fire_fill,
                color: AppColors.yellowNormal,
                size: 42,
              )
                  .animate(
                    onPlay: (controller) => controller.repeat(reverse: true),
                  )
                  .scale(
                    begin: const Offset(1.0, 1.0),
                    end: const Offset(1.12, 1.12),
                    duration: 750.ms,
                  ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$streakDays',
                    style: GoogleFonts.cinzel(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: AppColors.yellowNormal,
                      height: 1.0,
                    ),
                  ),
                  Text(
                    'hari runtunan',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.yellowNormal,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(7, (index) {
                  return Container(
                    width: 22,
                    alignment: Alignment.center,
                    child: Text(
                      _dayLetters[index],
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.yellowNormal,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(7, (index) {
                  final isActive = index < weekStreak.length && weekStreak[index];

                  return Container(
                    width: 22,
                    alignment: Alignment.center,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isActive ? AppColors.yellowNormal : Colors.transparent,
                        border: Border.all(
                          color: isActive ? AppColors.yellowNormal : AppColors.grey400,
                          width: 1.5,
                        ),
                      ),
                      child: isActive
                          ? const Center(
                              child: Icon(
                                Icons.check_rounded,
                                size: 12,
                                color: AppColors.grey900,
                              ),
                            )
                          : null,
                    ),
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(int completedCount, int totalCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Misi Hari Ini',
          style: GoogleFonts.cinzel(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.yellowNormal,
          ),
        ),
        Text(
          '$completedCount/$totalCount Selesai',
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildQuestList(List<QuestModel> quests, HomeViewModel vm) {
    if (quests.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 32),
        alignment: Alignment.center,
        child: Text(
          'Belum ada misi hari ini.\nKlik tombol di bawah untuk menambah misi!',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
      );
    }

    return Column(
      children: List.generate(quests.length, (index) {
        final quest = quests[index];
        final isCompleted = quest.status == QuestStatus.completed;

        return GestureDetector(
          onTap: () {
            context.push(AppRoutes.questDetail, extra: quest).then((_) => _reload());
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isCompleted
                    ? AppColors.success.withValues(alpha: 0.35)
                    : AppColors.purpleNormal.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
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
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textWhite,
                          decoration:
                              isCompleted ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        quest.feedbackNote ?? '-',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    final success = await vm.toggleQuest(quest);
                    if (!mounted) return;
                    if (success && !isCompleted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: AppColors.success,
                          content: Text(
                            'Quest Selesai! +${quest.xpReward} XP diperoleh! ⚔️',
                          ),
                        ),
                      );
                    } else if (!success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: AppColors.error,
                          content: Text(vm.errorMessage ?? 'Gagal memperbarui quest'),
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? AppColors.purpleNormal
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isCompleted
                            ? AppColors.purpleNormal
                            : AppColors.purpleLightActive,
                        width: 1.5,
                      ),
                    ),
                    child: isCompleted
                        ? const Center(
                            child: Icon(
                              Icons.check_rounded,
                              size: 18,
                              color: AppColors.textWhite,
                            ),
                          )
                        : null,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
