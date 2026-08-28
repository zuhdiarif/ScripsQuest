import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:raion_hackjam/core/constants/app_assets.dart';
import 'package:raion_hackjam/core/constants/app_routes.dart';
import 'package:raion_hackjam/core/theme/app_colors.dart';
import 'package:raion_hackjam/data/models/guild_leaderboard_model.dart';
import 'package:raion_hackjam/ui/auth/auth_viewmodel.dart';
import 'package:raion_hackjam/ui/guild/guild_viewmodel.dart';
import 'package:raion_hackjam/ui/widgets/app_bottom_nav_bar.dart';
import 'package:raion_hackjam/ui/widgets/app_segmented_control.dart';

class GuildView extends StatefulWidget {
  const GuildView({super.key});

  @override
  State<GuildView> createState() => _GuildViewState();
}

class _GuildViewState extends State<GuildView> {
  String _selectedTab = 'member';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authViewModel = context.read<AuthViewModel>();
      final userId = authViewModel.currentUser?.id ?? '';
      if (userId.isNotEmpty) {
        context.read<GuildViewModel>().initUserGuild(userId);
      }
    });
  }

  void _reloadGuild() {
    final authViewModel = context.read<AuthViewModel>();
    final userId = authViewModel.currentUser?.id ?? '';
    if (userId.isNotEmpty && mounted) {
      context.read<GuildViewModel>().initUserGuild(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final guildViewModel = context.watch<GuildViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: AppBottomNavBar(
        currentItem: AppNavItem.guild,
        onItemSelected: (item) {
          switch (item) {
            case AppNavItem.home:
              context.go(AppRoutes.home);
              break;
            case AppNavItem.quest:
              context.go(AppRoutes.questManagement);
              break;
            case AppNavItem.guild:
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
          child: guildViewModel.isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.purpleNormal),
                )
              : guildViewModel.errorMessage != null && !guildViewModel.hasGuild
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
                            guildViewModel.errorMessage!,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: _reloadGuild,
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
                  : (guildViewModel.hasGuild
                      ? _buildGuildDashboard(guildViewModel)
                      : _buildNoGuildView()),
        ),
      ),
    );
  }

  Widget _buildNoGuildView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Center(
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surfaceCard,
                border: Border.all(color: AppColors.purpleNormal, width: 2.5),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.purpleNormal.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Image.asset(
                AppAssets.wizardMascot,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Gabung Guild',
            textAlign: TextAlign.center,
            style: GoogleFonts.cinzel(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.yellowNormal,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Bergabunglah bersama teman dalam satu guild dan saling mendukung menyelesaikan skripsi.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 40),
          _buildActionCard(
            icon: Icons.add_rounded,
            title: 'Buat Guild',
            subtitle: 'Jadilah pemimpin Guild dan undang teman-teman kamu.',
            onTap: () {
              context.push(AppRoutes.createGuild).then((_) => _reloadGuild());
            },
          ),
          const SizedBox(height: 16),
          _buildActionCard(
            icon: Icons.login_rounded,
            title: 'Masuk Guild',
            subtitle: 'Punya kode undangan? Masukkan kode dan gabung bersama Guildmu.',
            onTap: () {
              context.push(AppRoutes.joinGuild).then((_) => _reloadGuild());
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.purpleNormal.withValues(alpha: 0.25),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.purpleDarker,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.purpleNormal),
              ),
              child: Icon(icon, color: AppColors.yellowNormal, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.cinzel(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.yellowNormal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
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
          ],
        ),
      ),
    );
  }

  Widget _buildGuildDashboard(GuildViewModel vm) {
    final guild = vm.guild;
    final members = vm.members;
    final leaderboard = vm.leaderboard;
    final guildCode = vm.guildCode ?? '';
    final memberCount = members.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Guild',
              style: GoogleFonts.cinzel(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: AppColors.yellowNormal,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surfaceCard,
                  border: Border.all(color: AppColors.purpleNormal, width: 2),
                ),
                padding: const EdgeInsets.all(8),
                child: ClipOval(
                  child: (guild != null && guild.iconUrl.startsWith('http'))
                      ? CachedNetworkImage(
                          imageUrl: guild.iconUrl,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => Image.asset(AppAssets.wizardMascot),
                        )
                      : Image.asset(
                          guild?.iconUrl ?? AppAssets.wizardMascot,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => Image.asset(AppAssets.wizardMascot),
                        ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      guild?.name ?? 'Skripsweet',
                      style: GoogleFonts.cinzel(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textWhite,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$memberCount Anggota',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      guild?.description ?? 'Learn, Connect, and Grow Together',
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
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kode Guild',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      guildCode,
                      style: GoogleFonts.inter(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textWhite,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.copy_rounded, color: AppColors.textWhite, size: 20),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: guildCode));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: AppColors.success,
                        content: Text('Kode Guild disalin ke clipboard! 📋'),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: guildCode));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: AppColors.info,
                        content: Text('Kode undangan siap dibagikan! 🚀'),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.purpleNormal,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Undang',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textWhite,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          AppSegmentedControl<String>(
            values: const ['member', 'leaderboard'],
            labels: const ['Member', 'Leaderboard'],
            selectedValue: _selectedTab,
            onValueChanged: (val) => setState(() => _selectedTab = val),
          ),
          const SizedBox(height: 20),
          _selectedTab == 'member'
              ? _buildMemberTab(members, memberCount)
              : _buildLeaderboardTab(leaderboard),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildMemberTab(List<GuildLeaderboardModel> members, int memberCount) {
    final authViewModel = context.read<AuthViewModel>();
    final currentUserId = authViewModel.currentUser?.id ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Semua Anggota ($memberCount)',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textWhite,
          ),
        ),
        const SizedBox(height: 12),
        if (members.isEmpty)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 32),
            alignment: Alignment.center,
            child: Text(
              'Belum ada anggota lain.\nBagikan kode guild untuk mengundang teman!',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: members.length,
            itemBuilder: (context, index) {
              final member = members[index];
              final isMe = member.userId == currentUserId;

              return _buildMemberCard(
                member: member,
                isMe: isMe,
              );
            },
          ),
      ],
    );
  }



  Widget _buildMemberCard({
    required GuildLeaderboardModel member,
    required bool isMe,
  }) {
    final level = member.level;

    return GestureDetector(
      onTap: () {
        context.push(AppRoutes.memberProfile, extra: member);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(16),
          border: isMe
              ? Border.all(color: AppColors.purpleNormal.withValues(alpha: 0.5))
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: ClipOval(
                child: Image.asset(
                  AppAssets.skullSide,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        member.username,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textWhite,
                        ),
                      ),
                      if (isMe) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: AppColors.purpleNormal,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'You',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textWhite,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Level $level',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${member.totalXp} XP',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboardTab(List<GuildLeaderboardModel> leaderboard) {
    final authViewModel = context.read<AuthViewModel>();
    final currentUserId = authViewModel.currentUser?.id ?? '';

    if (leaderboard.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 32),
        alignment: Alignment.center,
        child: Text(
          'Belum ada data leaderboard.\nSelesaikan quest untuk naik peringkat!',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
      );
    }

    final top3 = leaderboard.take(3).toList();
    final rest = leaderboard.length > 3 ? leaderboard.sublist(3) : <GuildLeaderboardModel>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPodium(top3),
        const SizedBox(height: 20),
        Text(
          'Leaderboard',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textWhite,
          ),
        ),
        const SizedBox(height: 12),
        ...rest.map((member) {
          final isMe = member.userId == currentUserId;
          if (isMe) {
            return _buildPinnedUserRow(
              name: member.username,
              level: 'Level ${member.level}',
              xp: '${member.totalXp} XP',
            );
          }
          return _buildRankRow(
            rank: member.rank,
            name: member.username,
            level: 'Level ${member.level}',
            xp: '${member.totalXp} XP',
          );
        }),
      ],
    );
  }

  Widget _buildPodium(List<GuildLeaderboardModel> top3) {
    if (top3.isEmpty) return const SizedBox.shrink();

    final first = top3[0];
    final second = top3.length > 1 ? top3[1] : null;
    final third = top3.length > 2 ? top3[2] : null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (second != null)
          _buildPodiumColumn(
            rank: 2,
            name: second.username,
            xp: '${second.totalXp} XP',
            height: 110,
          )
        else
          const SizedBox(width: 90),
        _buildPodiumColumn(
          rank: 1,
          name: first.username,
          xp: '${first.totalXp} XP',
          height: 145,
        ),
        if (third != null)
          _buildPodiumColumn(
            rank: 3,
            name: third.username,
            xp: '${third.totalXp} XP',
            height: 90,
          )
        else
          const SizedBox(width: 90),
      ],
    );
  }

  Widget _buildPodiumColumn({
    required int rank,
    required String name,
    required String xp,
    required double height,
  }) {
    return SizedBox(
      width: 90,
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: rank == 1
                    ? AppColors.yellowNormal
                    : (rank == 2 ? Colors.grey : const Color(0xFFCD7F32)),
                width: 2,
              ),
            ),
            child: ClipOval(
              child: Image.asset(AppAssets.skullSide, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textWhite,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            xp,
            style: GoogleFonts.inter(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: height,
            decoration: BoxDecoration(
              color: rank == 1 ? AppColors.grey700 : AppColors.grey800,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            alignment: Alignment.center,
            child: Text(
              '$rank',
              style: GoogleFonts.cinzel(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: AppColors.textWhite,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankRow({
    required int rank,
    required String name,
    required String level,
    required String xp,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Text(
              '$rank',
              style: GoogleFonts.cinzel(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textWhite,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: ClipOval(
              child: Image.asset(AppAssets.skullSide, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textWhite,
                  ),
                ),
                Text(
                  level,
                  style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Text(
            xp,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textWhite,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPinnedUserRow({
    required String name,
    required String level,
    required String xp,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white50,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.purpleNormal.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: ClipOval(
              child: Image.asset(AppAssets.skullSide, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: AppColors.purpleNormal,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'You',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textWhite,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  level,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.grey600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            xp,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
