import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:raion_hackjam/core/constants/app_assets.dart';
import 'package:raion_hackjam/core/constants/app_routes.dart';
import 'package:raion_hackjam/core/theme/app_colors.dart';
import 'package:raion_hackjam/ui/auth/auth_viewmodel.dart';
import 'package:raion_hackjam/ui/widgets/app_button.dart';
import 'package:raion_hackjam/ui/widgets/app_text_field.dart';

class OtpVerificationView extends StatefulWidget {
  final String email;
  final String? returnTo;

  const OtpVerificationView({
    super.key,
    required this.email,
    this.returnTo,
  });

  @override
  State<OtpVerificationView> createState() => _OtpVerificationViewState();
}

class _OtpVerificationViewState extends State<OtpVerificationView> {
  final _otpController = TextEditingController();
  int _timerSeconds = 60;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _otpController.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    setState(() => _timerSeconds = 60);
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerSeconds > 0) {
        setState(() => _timerSeconds--);
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _verifyOtp() async {
    final token = _otpController.text.trim();
    if (token.isEmpty || token.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.error,
          content: Text('Masukkan kode OTP verifikasi dengan lengkap'),
        ),
      );
      return;
    }

    final authViewModel = context.read<AuthViewModel>();
    final success = await authViewModel.verifyOtp(widget.email, token);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.success,
          content: Text('Akun berhasil diverifikasi! Selamat datang, Adventurer 🎉'),
        ),
      );
      if (widget.returnTo == 'build-quest') {
        context.go('${AppRoutes.buildQuest}?step=1');
      } else {
        context.go(AppRoutes.home);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.error,
          content: Text(authViewModel.errorMessage ?? 'Kode verifikasi salah atau kedaluwarsa'),
        ),
      );
    }
  }

  Future<void> _resendCode() async {
    if (_timerSeconds > 0) return;

    final authViewModel = context.read<AuthViewModel>();
    final success = await authViewModel.resendOtp(widget.email);

    if (!mounted) return;

    if (success) {
      _startCountdown();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.info,
          content: Text('Kode baru berhasil dikirimkan ke email kamu 📩'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.error,
          content: Text(authViewModel.errorMessage ?? 'Gagal mengirim ulang kode'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final authViewModel = context.watch<AuthViewModel>();

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
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.32,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      AppAssets.imageOnboarding3,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: AppColors.purpleDarker,
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Color(0x332A214D),
                            Color(0xCC221A3F),
                            Color(0xFF221A3F),
                          ],
                          stops: [0.0, 0.40, 0.80, 1.0],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceCard,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.purpleNormal,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.purpleNormal.withValues(alpha: 0.35),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.security_rounded,
                            color: AppColors.yellowNormal,
                            size: 36,
                          ),
                        ),
                      )
                          .animate(
                            onPlay: (controller) => controller.repeat(reverse: true),
                          )
                          .scale(
                            begin: const Offset(1.0, 1.0),
                            end: const Offset(1.06, 1.06),
                            duration: 1000.ms,
                            curve: Curves.easeInOut,
                          ),
                      const SizedBox(height: 18),
                      Text(
                        'Verifikasi Petualang',
                        style: GoogleFonts.cinzel(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textWhite,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Masukkan kode verifikasi yang dikirimkan ke:',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceCard,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.purpleDark),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.email_rounded,
                              size: 16,
                              color: AppColors.yellowNormal,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widget.email,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textWhite,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      AppTextField(
                        controller: _otpController,
                        hint: 'Kode Verifikasi',
                        keyboardType: TextInputType.number,
                        prefixIcon: Icons.key_rounded,
                      ),
                      const SizedBox(height: 24),
                      AppButton(
                        text: 'Konfirmasi Akun 🛡️',
                        isLoading: authViewModel.isLoading,
                        onPressed: _verifyOtp,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Belum menerima kode? ',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          GestureDetector(
                            onTap: _timerSeconds == 0 ? _resendCode : null,
                            child: Text(
                              _timerSeconds > 0
                                  ? 'Kirim Ulang ($_timerSeconds s)'
                                  : 'Kirim Ulang',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: _timerSeconds > 0
                                    ? AppColors.textTertiary
                                    : AppColors.info,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      TextButton.icon(
                        onPressed: () => context.go('${AppRoutes.auth}?mode=register'),
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          size: 18,
                          color: AppColors.textSecondary,
                        ),
                        label: Text(
                          'Kembali ke Pendaftaran',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
