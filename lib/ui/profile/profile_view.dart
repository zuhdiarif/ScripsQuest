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
import 'package:raion_hackjam/core/utils/validators.dart';
import 'package:raion_hackjam/data/models/badge_model.dart';
import 'package:raion_hackjam/logic/level_calculator.dart';
import 'package:raion_hackjam/ui/auth/auth_viewmodel.dart';
import 'package:raion_hackjam/ui/profile/profile_viewmodel.dart';
import 'package:raion_hackjam/ui/widgets/app_bottom_nav_bar.dart';
import 'package:raion_hackjam/ui/widgets/app_button.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String _selectedTab = 'ringkasan';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authViewModel = context.read<AuthViewModel>();
      final userId = authViewModel.currentUser?.id ?? '';
      if (userId.isNotEmpty) {
        context.read<ProfileViewModel>().loadProfile(userId);
      }
    });
  }

  void _reload() {
    final authViewModel = context.read<AuthViewModel>();
    final userId = authViewModel.currentUser?.id ?? '';
    if (userId.isNotEmpty && mounted) {
      context.read<ProfileViewModel>().loadProfile(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileViewModel = context.watch<ProfileViewModel>();
    final authViewModel = context.watch<AuthViewModel>();
    final user = authViewModel.currentUser;

    final profile = profileViewModel.profile;
    final username = profile?.username ??
        user?.userMetadata?['username'] ??
        'Pejuang';
    final totalXp = profile?.totalXp ?? 0;
    final level = profile?.level ?? LevelCalculator.calculateLevel(totalXp);
    final nextLevelXp = LevelCalculator.xpForNextLevel(level);
    final progressToNext = LevelCalculator.progressToNextLevel(totalXp);
    final remainingXp = (nextLevelXp - totalXp).clamp(0, nextLevelXp);

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: AppBottomNavBar(
        currentItem: AppNavItem.profile,
        onItemSelected: (item) {
          switch (item) {
            case AppNavItem.home:
              context.go(AppRoutes.home);
              break;
            case AppNavItem.quest:
              context.go(AppRoutes.questManagement);
              break;
            case AppNavItem.guild:
              context.go(AppRoutes.guild);
              break;
            case AppNavItem.profile:
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
          child: profileViewModel.isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.purpleNormal),
                )
              : profileViewModel.errorMessage != null && profile == null
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
                            profileViewModel.errorMessage!,
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
                          _buildTopBar(),
                          const SizedBox(height: 16),
                          _buildUserHeader(username, level),
                          const SizedBox(height: 16),
                          _buildXpCard(totalXp, nextLevelXp, progressToNext, remainingXp, level),
                          const SizedBox(height: 20),
                          _buildTabBar(),
                          const SizedBox(height: 20),
                          _buildTabContent(profileViewModel),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(width: 40),
        Text(
          'Profil',
          style: GoogleFonts.cinzel(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: AppColors.yellowNormal,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.settings_outlined, color: AppColors.textWhite, size: 26),
          onPressed: _showSettingsSheet,
        ),
      ],
    );
  }

  Widget _buildUserHeader(String username, int level) {
    return Row(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surfaceCard,
            border: Border.all(color: AppColors.purpleNormal, width: 2.5),
          ),
          child: ClipOval(
            child: Image.asset(AppAssets.skullSide, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.yellowNormal,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Sistem Informasi',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textWhite,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF5E35B1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Level $level',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textWhite,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildXpCard(
    int totalXp,
    int nextLevelXp,
    double progress,
    int remainingXp,
    int level,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Image.asset(AppAssets.crystal01, width: 44, height: 44),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$totalXp / $nextLevelXp xp',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.yellowNormal,
                  ),
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: AppColors.grey700,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.yellowNormal,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$remainingXp xp lagi untuk mencapai Level ${level + 1}',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Row(
      children: [
        _buildTabItem('ringkasan', 'Ringkasan'),
        _buildTabItem('statistik', 'Statistik'),
        _buildTabItem('pencapaian', 'Pencapaian'),
      ],
    );
  }

  Widget _buildTabItem(String key, String label) {
    final isSelected = _selectedTab == key;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = key),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? const Color(0xFF7C4DFF) : Colors.transparent,
                width: 2.5,
              ),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? AppColors.textWhite : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(ProfileViewModel vm) {
    switch (_selectedTab) {
      case 'statistik':
        return _buildStatistikTab(vm);
      case 'pencapaian':
        return _buildPencapaianTab(vm);
      case 'ringkasan':
      default:
        return _buildRingkasanTab(vm);
    }
  }

  Widget _buildRingkasanTab(ProfileViewModel vm) {
    final topic = vm.journey?.topic ??
        'Analisis Pengaruh Penerapan Dark Patterns Dalam Proses Pembelian Tiket di Aplikasi Travel Online Terhadap Pengalaman Pengguna';
    final streak = vm.profile?.currentStreak ?? 0;
    final completed = vm.completedQuestsCount;
    final total = vm.totalQuestsCount > 0 ? vm.totalQuestsCount : 4;
    final progressPercent = (completed / total).clamp(0.0, 1.0);

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.surfaceCard,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(AppAssets.scroll, width: 32, height: 32),
                  const SizedBox(width: 10),
                  Text(
                    'Skripsi',
                    style: GoogleFonts.cinzel(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.yellowNormal,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                topic,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.textWhite,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.surfaceCard,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Iconify(
                        Ph.fire_fill,
                        size: 26,
                        color: AppColors.yellowNormal,
                      )
                          .animate(onPlay: (c) => c.repeat(reverse: true))
                          .scale(
                            begin: const Offset(1, 1),
                            end: const Offset(1.15, 1.15),
                            duration: 800.ms,
                          ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$streak Hari Runtunan',
                            style: GoogleFonts.cinzel(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.yellowNormal,
                            ),
                          ),
                          Text(
                            'Pertahankan!',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    '$streak',
                    style: GoogleFonts.cinzel(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.yellowNormal,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStreakDay('S', vm.weekStreak.isNotEmpty && vm.weekStreak[0]),
                  _buildStreakDay('S', vm.weekStreak.length > 1 && vm.weekStreak[1]),
                  _buildStreakDay('R', vm.weekStreak.length > 2 && vm.weekStreak[2]),
                  _buildStreakDay('K', vm.weekStreak.length > 3 && vm.weekStreak[3]),
                  _buildStreakDay('J', vm.weekStreak.length > 4 && vm.weekStreak[4]),
                  _buildStreakDay('S', vm.weekStreak.length > 5 && vm.weekStreak[5]),
                  _buildStreakDay('M', vm.weekStreak.length > 6 && vm.weekStreak[6]),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.surfaceCard,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(AppAssets.scroll, width: 32, height: 32),
                      const SizedBox(width: 10),
                      Text(
                        'Progress',
                        style: GoogleFonts.cinzel(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.yellowNormal,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Bab $completed/$total',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textWhite,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: progressPercent,
                  minHeight: 8,
                  backgroundColor: AppColors.grey700,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.yellowNormal,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${(progressPercent * 100).toInt()} % selesai',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStreakDay(String label, bool isActive) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.cinzel(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.yellowNormal,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? AppColors.yellowNormal : Colors.transparent,
            border: Border.all(
              color: isActive ? AppColors.yellowNormal : AppColors.grey600,
              width: 1.5,
            ),
          ),
          child: isActive
              ? const Icon(Icons.check, size: 16, color: AppColors.background)
              : null,
        ),
      ],
    );
  }

  Widget _buildStatistikTab(ProfileViewModel vm) {
    final streak = vm.profile?.currentStreak ?? 0;
    final totalXp = vm.profile?.totalXp ?? 0;
    final badgesCount = vm.userBadges.length;
    final completedQuests = vm.completedQuestsCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detail Statistik',
          style: GoogleFonts.cinzel(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textWhite,
          ),
        ),
        const SizedBox(height: 14),
        _buildStatCard(
          title: 'Misi Selesai',
          subtitle: 'Total misi yang kamu selesaikan',
          value: '$completedQuests',
        ),
        const SizedBox(height: 12),
        _buildStatCard(
          title: 'Runtunan',
          subtitle: 'Hari dengan minimal 1 misi selesai',
          value: '$streak hari',
        ),
        const SizedBox(height: 12),
        _buildStatCard(
          title: 'Lencana',
          subtitle: 'Total lencana yang berhasil didapatkan',
          value: '$badgesCount',
        ),
        const SizedBox(height: 12),
        _buildStatCard(
          title: 'Total XP',
          subtitle: 'Total poin pengalaman yang didapatkan',
          value: '$totalXp',
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String subtitle,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Image.asset(AppAssets.scroll, width: 34, height: 34),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.cinzel(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textWhite,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            value,
            style: GoogleFonts.cinzel(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.yellowNormal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPencapaianTab(ProfileViewModel vm) {
    final allBadges = vm.allBadges.isNotEmpty ? vm.allBadges : _getFallbackBadges();
    final unlockedIds = vm.userBadges.map((u) => u.badgeId).toSet();
    final unlockedCount = unlockedIds.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Koleksi Badge',
              style: GoogleFonts.cinzel(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textWhite,
              ),
            ),
            Text(
              '$unlockedCount/${allBadges.length} Terkumpul',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 16,
            childAspectRatio: 0.72,
          ),
          itemCount: allBadges.length,
          itemBuilder: (context, index) {
            final badge = allBadges[index];
            final isUnlocked = unlockedIds.contains(badge.id) || index < unlockedCount;
            final asset = _getBadgeAsset(index, isUnlocked);

            return Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: Image.asset(asset, fit: BoxFit.contain),
                ),
                const SizedBox(height: 6),
                Text(
                  badge.name,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cinzel(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isUnlocked ? AppColors.textWhite : AppColors.grey400,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  badge.description,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 9,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  String _getBadgeAsset(int index, bool isUnlocked) {
    if (!isUnlocked) return AppAssets.badgeLocked;
    switch (index % 5) {
      case 0:
        return AppAssets.badgeFire;
      case 1:
        return AppAssets.badgeLightning;
      case 2:
        return AppAssets.badgeSword;
      case 3:
        return AppAssets.badgeStar;
      case 4:
      default:
        return AppAssets.badgeShield;
    }
  }

  List<BadgeModel> _getFallbackBadges() {
    return const [
      BadgeModel(id: '1', name: 'First Step', description: 'Selesaikan quest pertamamu', requirement: '1 quest'),
      BadgeModel(id: '2', name: 'Consistent Scholar', description: 'Capai streak 3 hari berturut-turut', requirement: '3 hari streak'),
      BadgeModel(id: '3', name: 'Thesis Warrior', description: 'Capai streak 7 hari berturut-turut', requirement: '7 hari streak'),
      BadgeModel(id: '4', name: 'Revision Hero', description: 'Selesaikan tugas revisi dari dosen', requirement: '1 revision quest'),
      BadgeModel(id: '5', name: 'Level Up Novice', description: 'Capai Level 2 (100 XP)', requirement: '100 XP'),
      BadgeModel(id: '6', name: 'Level Up Scholar', description: 'Capai Level 3 (250 XP)', requirement: '250 XP'),
      BadgeModel(id: '7', name: 'Level Up Master', description: 'Capai Level 4 (500 XP)', requirement: '500 XP'),
      BadgeModel(id: '8', name: 'Thesis Legend', description: 'Capai Level 5 (1000 XP)', requirement: '1000 XP'),
      BadgeModel(id: '9', name: 'Guild Explorer', description: 'Bergabung atau buat guild', requirement: 'Member guild'),
    ];
  }

  void _showSettingsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.grey900,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.grey600,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Pengaturan Akun',
                  style: GoogleFonts.cinzel(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.yellowNormal,
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.edit_outlined, color: AppColors.textWhite),
                  title: Text(
                    'Ubah Nama Pengguna',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textWhite,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                  onTap: () {
                    Navigator.pop(context);
                    _showEditUsernameDialog();
                  },
                ),
                const Divider(color: AppColors.grey700),
                ListTile(
                  leading: const Icon(Icons.logout_rounded, color: AppColors.error),
                  title: Text(
                    'Keluar Akun',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.error,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _showLogoutDialog();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEditUsernameDialog() {
    final vm = context.read<ProfileViewModel>();
    final controller = TextEditingController(text: vm.profile?.username ?? '');

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.grey900,
          title: Text(
            'Ubah Nama Pengguna',
            style: GoogleFonts.cinzel(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.yellowNormal,
            ),
          ),
          content: TextField(
            controller: controller,
            style: GoogleFonts.inter(color: AppColors.textWhite),
            decoration: InputDecoration(
              hintText: 'Nama pengguna baru',
              hintStyle: GoogleFonts.inter(color: AppColors.textSecondary),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.purpleNormal),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.yellowNormal, width: 2),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'Batal',
                style: GoogleFonts.inter(color: AppColors.textSecondary),
              ),
            ),
            AppButton(
              text: 'Simpan',
              width: 100,
              height: 40,
              onPressed: () async {
                final newName = controller.text.trim();
                final validationError = Validators.validateUsername(newName);
                if (validationError != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: AppColors.error,
                      content: Text(validationError),
                    ),
                  );
                  return;
                }
                Navigator.pop(dialogContext);
                final success = await vm.updateUsername(newName);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: success ? AppColors.success : AppColors.error,
                      content: Text(
                        success
                            ? 'Nama pengguna berhasil diperbarui! ✨'
                            : 'Gagal memperbarui nama pengguna',
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.grey900,
          title: Text(
            'Keluar Akun?',
            style: GoogleFonts.cinzel(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textWhite,
            ),
          ),
          content: Text(
            'Apakah kamu yakin ingin keluar dari akun ini?',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'Batal',
                style: GoogleFonts.inter(color: AppColors.textSecondary),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext);
                final authVm = context.read<AuthViewModel>();
                await authVm.signOut();
                if (mounted) {
                  context.go(AppRoutes.onboarding);
                }
              },
              child: Text(
                'Keluar',
                style: GoogleFonts.inter(
                  color: AppColors.error,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
