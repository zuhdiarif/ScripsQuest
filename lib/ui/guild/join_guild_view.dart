import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:raion_hackjam/core/constants/app_assets.dart';
import 'package:raion_hackjam/core/constants/app_routes.dart';
import 'package:raion_hackjam/core/theme/app_colors.dart';
import 'package:raion_hackjam/core/utils/validators.dart';
import 'package:raion_hackjam/ui/auth/auth_viewmodel.dart';
import 'package:raion_hackjam/ui/guild/guild_viewmodel.dart';
import 'package:raion_hackjam/ui/widgets/app_button.dart';

class JoinGuildView extends StatefulWidget {
  const JoinGuildView({super.key});

  @override
  State<JoinGuildView> createState() => _JoinGuildViewState();
}

class _JoinGuildViewState extends State<JoinGuildView> {
  final _codeController = TextEditingController();
  bool _isSuccess = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _submitJoin() async {
    final code = _codeController.text.trim().toUpperCase();
    final validationError = Validators.validateGuildCode(code);
    if (validationError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.error,
          content: Text(validationError),
        ),
      );
      return;
    }

    final authViewModel = context.read<AuthViewModel>();
    final userId = authViewModel.currentUser?.id ?? '';
    if (userId.isEmpty) return;

    final guildViewModel = context.read<GuildViewModel>();
    final success = await guildViewModel.joinGuild(code, userId);

    if (!mounted) return;

    if (success) {
      setState(() => _isSuccess = true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.error,
          content: Text(guildViewModel.errorMessage ?? 'Kode guild tidak ditemukan'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isSuccess) {
      return _buildSuccessScreen();
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2A214D),
              Color(0xFF221A3F),
              Color(0xFF19132E),
              Color(0xFF130F24),
            ],
            stops: [0.0, 0.35, 0.70, 1.0],
          ),
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
                const SizedBox(height: 8),
                Center(
                  child: Column(
                    children: [
                      Text(
                        'Masuk Guild',
                        style: GoogleFonts.cinzel(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: AppColors.yellowNormal,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Image.asset(
                        AppAssets.wizardMascot,
                        height: 120,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.shield_rounded,
                          size: 60,
                          color: AppColors.yellowNormal,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Masukkan Kode Guild',
                        style: GoogleFonts.cinzel(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textWhite,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Tanyakan kode undangan pada Guild Leader atau teman kamu.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF241D40),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFF3B3164)),
                  ),
                  child: TextField(
                    controller: _codeController,
                    textCapitalization: TextCapitalization.characters,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 4,
                      color: AppColors.yellowNormal,
                    ),
                    decoration: InputDecoration(
                      hintText: 'S-XXXXXX',
                      hintStyle: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF7A739C),
                        letterSpacing: 3,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF241D40).withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF3B3164).withValues(alpha: 0.5)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dengan bergabung kamu akan:',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textWhite,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildJoinBullet('Melihat leaderboard sesama pejuang skripsi'),
                      _buildJoinBullet('Saling menyemangati progress bab & revisi'),
                      _buildJoinBullet('Mendapatkan Guild XP & Badge Tim'),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                AppButton(
                  text: 'Gabung Guild',
                  isLoading: context.watch<GuildViewModel>().isLoading,
                  onPressed: _submitJoin,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildJoinBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('✦ ', style: TextStyle(color: Color(0xFF9E92FF), fontSize: 13)),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFFB5AFD4)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessScreen() {
    final guildViewModel = context.watch<GuildViewModel>();
    final guildName = guildViewModel.guild?.name ?? 'Guild';

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2A214D),
              Color(0xFF221A3F),
              Color(0xFF19132E),
              Color(0xFF130F24),
            ],
            stops: [0.0, 0.35, 0.70, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              children: [
                const SizedBox(height: 24),
                Text(
                  'Berhasil Bergabung!',
                  style: GoogleFonts.cinzel(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: AppColors.yellowNormal,
                  ),
                ),
                const Spacer(),
                Image.asset(
                  AppAssets.wizardMascot,
                  height: 150,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 24),
                Text(
                  'Selamat datang di $guildName!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textWhite,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sekarang kamu bisa berjuang bersama teman-teman guild-mu.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const Spacer(),
                AppButton(
                  text: 'Buka Halaman Guild',
                  onPressed: () => context.go(AppRoutes.guild),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
