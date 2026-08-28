import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:raion_hackjam/core/constants/app_assets.dart';
import 'package:raion_hackjam/core/theme/app_colors.dart';
import 'package:raion_hackjam/data/models/quest_model.dart';
import 'package:raion_hackjam/ui/auth/auth_viewmodel.dart';
import 'package:raion_hackjam/ui/quest_management/quest_management_viewmodel.dart';
import 'package:raion_hackjam/ui/widgets/app_button.dart';

class QuestEditView extends StatefulWidget {
  final QuestModel? quest;

  const QuestEditView({
    super.key,
    this.quest,
  });

  @override
  State<QuestEditView> createState() => _QuestEditViewState();
}

class _QuestEditViewState extends State<QuestEditView> {
  late final TextEditingController _titleController;
  late final TextEditingController _descController;
  String _parentGoal = 'Literature Review';

  final List<String> _parentGoals = const [
    'Literature Review',
    'Proposal',
    'Pengumpulan Data',
    'Implementasi Sistem',
    'Pembahasan Hasil',
    'Revisi Dosen',
    'Persiapan Sidang',
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.quest?.title ?? '');
    _descController = TextEditingController(text: widget.quest?.description ?? '');
    if (widget.quest?.feedbackNote != null && widget.quest!.feedbackNote!.isNotEmpty) {
      _parentGoal = widget.quest!.feedbackNote!;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _saveQuest() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.error,
          content: Text('Judul misi tidak boleh kosong!'),
        ),
      );
      return;
    }

    final vm = context.read<QuestManagementViewModel>();
    final authViewModel = context.read<AuthViewModel>();
    final userId = authViewModel.currentUser?.id ?? '';

    bool success;
    if (widget.quest != null) {
      final updated = widget.quest!.copyWith(
        title: title,
        description: _descController.text.trim(),
        feedbackNote: _parentGoal,
      );
      success = await vm.updateQuest(updated);
    } else {
      final newQuest = QuestModel(
        id: '',
        userId: userId,
        type: QuestType.regular,
        title: title,
        description: _descController.text.trim(),
        feedbackNote: _parentGoal,
        status: QuestStatus.notStarted,
        questOrder: vm.quests.length + 1,
        xpReward: 20,
        createdAt: DateTime.now(),
      );
      success = await vm.createQuest(newQuest);
    }

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.success,
          content: Text(
            widget.quest != null
                ? 'Misi berhasil diperbarui! ⚔️'
                : 'Misi baru berhasil dibuat! 🎯',
          ),
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.error,
          content: Text(vm.errorMessage ?? 'Gagal menyimpan misi'),
        ),
      );
    }
  }

  Future<void> _deleteQuest() async {
    if (widget.quest == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.grey900,
          title: Text(
            'Hapus Misi?',
            style: GoogleFonts.cinzel(
              color: AppColors.textWhite,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            'Apakah kamu yakin ingin menghapus misi ini dari daftar?',
            style: GoogleFonts.inter(color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal', style: TextStyle(color: AppColors.textSecondary)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Hapus', style: TextStyle(color: AppColors.error)),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      final vm = context.read<QuestManagementViewModel>();
      final questId = widget.quest?.id;
      if (questId == null) return;
      final success = await vm.deleteQuest(questId);
      if (!mounted) return;
      if (success) {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.error,
            content: Text(vm.errorMessage ?? 'Gagal menghapus misi'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.quest != null;

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                    icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textWhite),
                    onPressed: () => Navigator.pop(context),
                  ),
                  if (isEditing)
                    IconButton(
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerRight,
                      icon: const Icon(Icons.delete_outline_rounded, color: AppColors.textWhite),
                      onPressed: _deleteQuest,
                    ),
                ],
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
                  isEditing ? 'Ubah Misi' : 'Tambah Misi',
                  style: GoogleFonts.cinzel(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: AppColors.yellowNormal,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Judul Misi',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textWhite,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: TextField(
                  controller: _titleController,
                  maxLength: 50,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.textWhite,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Masukkan judul misi...',
                    hintStyle: GoogleFonts.inter(color: AppColors.grey400),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                    counterStyle: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Deskripsi',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textWhite,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: TextField(
                  controller: _descController,
                  maxLines: 4,
                  maxLength: 250,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.textWhite,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Deskripsikan tugas dan target penyelesaian...',
                    hintStyle: GoogleFonts.inter(color: AppColors.grey400),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                    counterStyle: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Parent Goal',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textWhite,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _parentGoal,
                    isExpanded: true,
                    dropdownColor: AppColors.grey800,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textWhite),
                    items: _parentGoals.map((g) {
                      return DropdownMenuItem(
                        value: g,
                        child: Text(
                          g,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppColors.textWhite,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _parentGoal = val);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 32),
              AppButton(
                text: 'Simpan Perubahan',
                isLoading: context.watch<QuestManagementViewModel>().isLoading,
                onPressed: _saveQuest,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    ),
  );
  }
}
