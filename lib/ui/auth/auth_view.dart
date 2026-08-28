import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ri.dart';
import 'package:provider/provider.dart';
import 'package:raion_hackjam/core/constants/app_assets.dart';
import 'package:raion_hackjam/core/constants/app_routes.dart';
import 'package:raion_hackjam/core/theme/app_colors.dart';
import 'package:raion_hackjam/core/utils/validators.dart';
import 'package:raion_hackjam/ui/auth/auth_viewmodel.dart';
import 'package:raion_hackjam/ui/widgets/app_button.dart';
import 'package:raion_hackjam/ui/widgets/app_text_field.dart';

class AuthView extends StatefulWidget {
  final bool initialIsRegister;
  final String? returnTo;

  const AuthView({
    super.key,
    this.initialIsRegister = false,
    this.returnTo,
  });

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  late bool _isRegister;
  bool _rememberMe = true;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isRegister = widget.initialIsRegister;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _toggleAuthMode() {
    setState(() {
      _isRegister = !_isRegister;
      _formKey.currentState?.reset();
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final authViewModel = context.read<AuthViewModel>();

    if (_isRegister) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.error,
            content: Text('Konfirmasi kata sandi tidak cocok!'),
          ),
        );
        return;
      }

      final result = await authViewModel.signUp(
        _emailController.text.trim(),
        _passwordController.text,
        username: _nameController.text.trim(),
      );

      if (!mounted) return;

      if (result == SignUpResult.autoConfirmed) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.success,
            content: Text('Pendaftaran berhasil! Selamat datang 🎉'),
          ),
        );
        if (widget.returnTo == 'build-quest') {
          context.go('${AppRoutes.buildQuest}?step=1');
        } else {
          context.go(AppRoutes.home);
        }
      } else if (result == SignUpResult.confirmationRequired) {
        final emailEncoded = Uri.encodeComponent(_emailController.text.trim());
        final returnToParam =
            widget.returnTo != null ? '&returnTo=${widget.returnTo}' : '';
        context.push('${AppRoutes.otpVerification}?email=$emailEncoded$returnToParam');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.error,
            content: Text(authViewModel.errorMessage ?? 'Gagal mendaftar'),
          ),
        );
      }
    } else {
      final success = await authViewModel.signIn(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (!mounted) return;

      if (success) {
        context.go(AppRoutes.home);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.error,
            content: Text(authViewModel.errorMessage ?? 'Gagal masuk akun'),
          ),
        );
      }
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
                height: size.height * 0.30,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      AppAssets.imageOnboarding2,
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                        _isRegister ? 'Buat Akun Baru' : 'Selamat Datang!',
                        style: GoogleFonts.cinzel(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textWhite,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _isRegister
                            ? 'Mulai petualangan skripsimu bersama Skripquest'
                            : 'Masuk ke akun Skripquest kamu',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (_isRegister) ...[
                        AppTextField(
                          key: const ValueKey('name_field'),
                          controller: _nameController,
                          hint: 'Nama Lengkap',
                          prefixIcon: Icons.person_outline_rounded,
                          validator: Validators.validateUsername,
                        ),
                        const SizedBox(height: 14),
                      ],
                      AppTextField(
                        key: const ValueKey('email_field'),
                        controller: _emailController,
                        hint: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.email_outlined,
                        validator: Validators.validateEmail,
                      ),
                      const SizedBox(height: 14),
                      AppTextField(
                        key: const ValueKey('password_field'),
                        controller: _passwordController,
                        hint: 'Kata Sandi',
                        isPassword: true,
                        prefixIcon: Icons.lock_outline_rounded,
                        validator: Validators.validatePassword,
                      ),
                      if (_isRegister) ...[
                        const SizedBox(height: 14),
                        AppTextField(
                          key: const ValueKey('confirm_password_field'),
                          controller: _confirmPasswordController,
                          hint: 'Konfirmasi Kata Sandi',
                          isPassword: true,
                          prefixIcon: Icons.lock_outline_rounded,
                          validator: (val) {
                            if (val != _passwordController.text) {
                              return 'Konfirmasi kata sandi tidak cocok';
                            }
                            return null;
                          },
                        ),
                      ],
                      if (!_isRegister) ...[
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Checkbox(
                                    value: _rememberMe,
                                    activeColor: AppColors.purpleNormal,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    side: const BorderSide(
                                      color: AppColors.grey400,
                                      width: 1.5,
                                    ),
                                    onChanged: (val) {
                                      setState(() {
                                        _rememberMe = val ?? true;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Ingat Saya',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: _showForgotPasswordDialog,
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                'Lupa Kata Sandi?',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.info,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 24),
                      AppButton(
                        text: _isRegister ? 'Daftar' : 'Masuk',
                        isLoading: authViewModel.isLoading,
                        onPressed: _submit,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Expanded(
                            child: Divider(color: AppColors.grey400, thickness: 1),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Text(
                              'Atau',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                          const Expanded(
                            child: Divider(color: AppColors.grey400, thickness: 1),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildGoogleButton(),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _isRegister
                                ? 'Sudah punya akun? '
                                : 'Belum punya akun? ',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          GestureDetector(
                            onTap: _toggleAuthMode,
                            child: Text(
                              _isRegister ? 'Masuk sekarang' : 'Daftar sekarang',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.info,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildGoogleButton() {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.info,
            content: Text('Login dengan Google akan segera hadir! 🚀'),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.white50,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Iconify(
              Ri.google_fill,
              size: 22,
              color: Color(0xFFEA4335),
            ),
            const SizedBox(width: 12),
            Text(
              _isRegister ? 'Daftar dengan Google' : 'Masuk dengan Google',
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showForgotPasswordDialog() {
    final emailController = TextEditingController(text: _emailController.text);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.grey900,
          title: Text(
            'Lupa Kata Sandi',
            style: GoogleFonts.cinzel(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.yellowNormal,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Masukkan email akunmu. Kami akan mengirimkan tautan reset kata sandi.',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: emailController,
                hint: 'Email terdaftar',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.email_outlined,
                validator: Validators.validateEmail,
              ),
            ],
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
              text: 'Kirim',
              width: 100,
              height: 40,
              onPressed: () async {
                final email = emailController.text.trim();
                final validationError = Validators.validateEmail(email);
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
                final authVm = context.read<AuthViewModel>();
                final success = await authVm.resetPassword(email);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor:
                          success ? AppColors.success : AppColors.error,
                      content: Text(
                        success
                            ? 'Tautan reset kata sandi telah dikirim ke email! 📩'
                            : (authVm.errorMessage ??
                                'Gagal mengirim email reset kata sandi'),
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
}
