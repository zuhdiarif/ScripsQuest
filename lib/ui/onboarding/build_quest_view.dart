import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:raion_hackjam/core/constants/app_assets.dart';
import 'package:raion_hackjam/core/constants/app_routes.dart';
import 'package:raion_hackjam/core/theme/app_colors.dart';
import 'package:raion_hackjam/data/models/thesis_journey_model.dart';
import 'package:raion_hackjam/ui/auth/auth_viewmodel.dart';
import 'package:raion_hackjam/ui/onboarding/onboarding_viewmodel.dart';
import 'package:raion_hackjam/ui/quest_management/quest_management_viewmodel.dart';
import 'package:raion_hackjam/ui/widgets/app_button.dart';
import 'package:raion_hackjam/ui/widgets/stage_card.dart';

class BuildQuestView extends StatefulWidget {
  final int initialStep;

  const BuildQuestView({
    super.key,
    this.initialStep = 0,
  });

  @override
  State<BuildQuestView> createState() => _BuildQuestViewState();
}

class _BuildQuestViewState extends State<BuildQuestView> {
  final _topicController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OnboardingViewModel>().setStep(widget.initialStep);
    });
  }

  @override
  void didUpdateWidget(covariant BuildQuestView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialStep != widget.initialStep) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<OnboardingViewModel>().setStep(widget.initialStep);
      });
    }
  }

  final List<Map<String, dynamic>> _stages = const [
    {'title': 'Proposal', 'stage': ThesisStage.proposal},
    {'title': 'Riset', 'stage': ThesisStage.literatureReview},
    {'title': 'Penulisan', 'stage': ThesisStage.penulisan},
    {'title': 'Revisi', 'stage': ThesisStage.revisi},
    {'title': 'Finalisasi', 'stage': ThesisStage.persiapanSidang},
  ];

  final List<String> _goals = const [
    'Proposal',
    'Riset',
    'Penulisan',
    'Revisi',
    'Finalisasi',
  ];

  final List<String> _fields = const [
    'Machine Learning',
    'Software Engineering',
    'Cyber Security',
    'Mobile Development',
    'Data Science',
    'Human-Computer Interaction',
    'Network & IoT',
    'Lainnya',
  ];

  final List<String> _weeklyTargets = const [
    '1 - 2 Quest / Minggu',
    '3 - 5 Quest / Minggu',
    '6 - 10 Quest / Minggu',
    '10+ Quest / Minggu',
  ];

  @override
  void dispose() {
    _topicController.dispose();
    super.dispose();
  }

  Future<void> _pickGraduationDate(OnboardingViewModel vm) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: vm.graduationTarget ?? now.add(const Duration(days: 180)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365 * 4)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.purpleNormal,
              onPrimary: AppColors.textWhite,
              surface: AppColors.grey800,
              onSurface: AppColors.textWhite,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      vm.setGraduationTarget(picked);
    }
  }

  void _showFieldPicker(OnboardingViewModel vm) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.grey900,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.grey400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Pilih Bidang Penelitian',
                style: GoogleFonts.cinzel(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textWhite,
                ),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _fields.length,
                  itemBuilder: (context, index) {
                    final item = _fields[index];
                    final isSelected = vm.researchField == item;

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        item,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? AppColors.yellowNormal : AppColors.textWhite,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_rounded, color: AppColors.yellowNormal)
                          : null,
                      onTap: () {
                        vm.setResearchField(item);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showWeeklyTargetPicker(OnboardingViewModel vm) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.grey900,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.grey400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Pilih Target Mingguan',
                style: GoogleFonts.cinzel(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textWhite,
                ),
              ),
              const SizedBox(height: 16),
              ...List.generate(_weeklyTargets.length, (index) {
                final item = _weeklyTargets[index];
                final isSelected = vm.weeklyTarget == item;

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    item,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? AppColors.yellowNormal : AppColors.textWhite,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_rounded, color: AppColors.yellowNormal)
                      : null,
                  onTap: () {
                    vm.setWeeklyTarget(item);
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Future<void> _finishJourney(OnboardingViewModel vm) async {
    final authViewModel = context.read<AuthViewModel>();
    final user = authViewModel.currentUser;

    if (user != null) {
      try {
        await vm.submitJourney(user.id);
        if (mounted) {
          await context.read<QuestManagementViewModel>().seedInitialThesisQuests(user.id);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.error,
              content: Text('Gagal menyimpan target petualangan: $e'),
            ),
          );
        }
      }
      if (!mounted) return;
      context.go(AppRoutes.home);
    } else {
      if (!mounted) return;
      context.go('${AppRoutes.auth}?mode=register&returnTo=build-quest');
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<OnboardingViewModel>();

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
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _buildStepContent(vm),
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent(OnboardingViewModel vm) {
    switch (vm.currentStep) {
      case 0:
        return _buildStep0(vm);
      case 1:
        return _buildStep1(vm);
      case 2:
        return _buildStep2(vm);
      case 3:
        return _buildStep3(vm);
      case 4:
        return _buildStep4(vm);
      case 5:
        return _buildStep5(vm);
      default:
        return _buildStep0(vm);
    }
  }

  Widget _buildStep0(OnboardingViewModel vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            'Taklukkan\nSkripsimu',
            textAlign: TextAlign.center,
            style: GoogleFonts.cinzel(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: AppColors.yellowNormal,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Setiap misi mendekatkanmu ke gelar sarjana!\nKlik Start Your Journey untuk memulai petualangan baru, atau masuk jika kamu sudah memiliki akun.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const Spacer(),
          Center(
            child: Image.asset(
              AppAssets.door,
              height: 340,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.door_front_door_rounded,
                size: 160,
                color: AppColors.purpleNormal,
              ),
            ),
          ),
          const Spacer(),
          AppButton(
            text: 'Mulai Petualanganmu!',
            onPressed: () {
              final authVm = context.read<AuthViewModel>();
              if (authVm.isAuthenticated) {
                vm.setStep(1);
              } else {
                context.go('${AppRoutes.auth}?mode=register&returnTo=build-quest');
              }
            },
          ),
          const SizedBox(height: 12),
          AppButton(
            text: 'Masuk Akun!',
            backgroundColor: AppColors.white50,
            textColor: AppColors.purpleDarker,
            onPressed: () => context.go('${AppRoutes.auth}?mode=login'),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildStep1(OnboardingViewModel vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            alignment: Alignment.centerLeft,
            icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textWhite),
            onPressed: () => vm.previousStep(),
          ),
          const SizedBox(height: 12),
          Center(
            child: Column(
              children: [
                Text(
                  'Di Tahap Mana\nSkripsi Kamu ?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cinzel(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: AppColors.yellowNormal,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Setiap misi mendekatkanmu ke gelar sarjana!\nKlik Start Your Journey',
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
          Expanded(
            child: ListView.builder(
              itemCount: _stages.length,
              itemBuilder: (context, index) {
                final item = _stages[index];
                final stage = item['stage'] as ThesisStage;
                final isSelected = vm.selectedStage == stage;

                return StageCard(
                  title: item['title'] as String,
                  imageAsset: AppAssets.crystal01,
                  isSelected: isSelected,
                  onTap: () => vm.setStage(stage),
                );
              },
            ),
          ),
          AppButton(
            text: 'Selanjutnya',
            onPressed: () {
              if (vm.selectedStage == null) {
                vm.setStage(ThesisStage.proposal);
              }
              vm.nextStep();
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildStep2(OnboardingViewModel vm) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            alignment: Alignment.centerLeft,
            icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textWhite),
            onPressed: () => vm.previousStep(),
          ),
          const SizedBox(height: 12),
          Center(
            child: Column(
              children: [
                Text(
                  'Tentang Apa\nSkripsimu?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cinzel(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: AppColors.yellowNormal,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Ini membantu kami memberikan panduan yang lebih tepat!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F0FB),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFE2DCF7), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Judul / Topik Skripsi',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.purpleDarker,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4C3E8A).withValues(alpha: 0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _topicController,
                    maxLines: 4,
                    onChanged: (val) => vm.setTopic(val),
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF1E1738),
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText:
                          'Contoh: Implementasi Sistem Rekomendasi Berbasis Machine Learning',
                      hintStyle: GoogleFonts.inter(
                        fontSize: 13,
                        color: const Color(0xFF8A82A8),
                        fontWeight: FontWeight.w400,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFFDED8F6), width: 1.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFFDED8F6), width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: AppColors.purpleNormal, width: 2),
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Bidang Penelitian',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.purpleDarker,
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _showFieldPicker(vm),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFDED8F6), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4C3E8A).withValues(alpha: 0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          AppAssets.crystal01,
                          width: 24,
                          height: 24,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.diamond_outlined, color: AppColors.purpleNormal, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            vm.researchField,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1E1738),
                            ),
                          ),
                        ),
                        const Icon(Icons.chevron_right_rounded, color: AppColors.grey400),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          AppButton(
            text: 'Selanjutnya',
            onPressed: () => vm.nextStep(),
          ),
        ],
      ),
    );
  }

  Widget _buildStep3(OnboardingViewModel vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            alignment: Alignment.centerLeft,
            icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textWhite),
            onPressed: () => vm.previousStep(),
          ),
          const SizedBox(height: 12),
          Center(
            child: Column(
              children: [
                Text(
                  'Apa Tujuan\nKamu ?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cinzel(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: AppColors.yellowNormal,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Mari tentukan fokus utama yang jelas.',
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
          Expanded(
            child: ListView.builder(
              itemCount: _goals.length,
              itemBuilder: (context, index) {
                final item = _goals[index];
                final isSelected = vm.currentGoal == item;

                return StageCard(
                  title: item,
                  imageAsset: AppAssets.crystal01,
                  isSelected: isSelected,
                  onTap: () => vm.setGoal(item),
                );
              },
            ),
          ),
          AppButton(
            text: 'Selanjutnya',
            onPressed: () => vm.nextStep(),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildStep4(OnboardingViewModel vm) {
    final dateFormat = DateFormat('dd MMMM yyyy');
    final targetDateStr = vm.graduationTarget != null
        ? dateFormat.format(vm.graduationTarget!)
        : 'Pilih Tanggal Kelulusan';

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            alignment: Alignment.centerLeft,
            icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textWhite),
            onPressed: () => vm.previousStep(),
          ),
          const SizedBox(height: 12),
          Center(
            child: Column(
              children: [
                Text(
                  'Tentukan\nTargetmu!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cinzel(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: AppColors.yellowNormal,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Kamu bisa mengubahnya nanti.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F0FB),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFE2DCF7), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Target Kelulusan',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.purpleDarker,
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _pickGraduationDate(vm),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFDED8F6), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4C3E8A).withValues(alpha: 0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            targetDateStr,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1E1738),
                            ),
                          ),
                        ),
                        const Icon(Icons.calendar_today_rounded, color: AppColors.purpleNormal, size: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Target Mingguan (Opsional)',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.purpleDarker,
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _showWeeklyTargetPicker(vm),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFDED8F6), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4C3E8A).withValues(alpha: 0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          AppAssets.crystal01,
                          width: 24,
                          height: 24,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.diamond_outlined, color: AppColors.purpleNormal, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            vm.weeklyTarget,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1E1738),
                            ),
                          ),
                        ),
                        const Icon(Icons.chevron_right_rounded, color: AppColors.grey400),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          AppButton(
            text: 'Selanjutnya',
            onPressed: () => vm.nextStep(),
          ),
        ],
      ),
    );
  }

  Widget _buildStep5(OnboardingViewModel vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            'Mari Mulai\nPetualanganmu!',
            textAlign: TextAlign.center,
            style: GoogleFonts.cinzel(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: AppColors.yellowNormal,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Perjalanan akademismu resmi dimulai! Selesaikan quest, dapatkan XP, dan buka berbagai achievement.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const Spacer(),
          Center(
            child: Image.asset(
              AppAssets.door,
              height: 320,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.door_front_door_rounded,
                size: 160,
                color: AppColors.purpleNormal,
              ),
            ),
          ),
          const Spacer(),
          AppButton(
            text: 'Pergi ke Beranda!',
            isLoading: vm.isLoading,
            onPressed: () => _finishJourney(vm),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
