import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:raion_hackjam/core/constants/app_assets.dart';
import 'package:raion_hackjam/core/constants/app_routes.dart';
import 'package:raion_hackjam/core/constants/supabase_constants.dart';
import 'package:raion_hackjam/core/theme/app_colors.dart';
import 'package:raion_hackjam/ui/auth/auth_viewmodel.dart';
import 'package:raion_hackjam/ui/guild/guild_viewmodel.dart';
import 'package:raion_hackjam/ui/widgets/app_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateGuildView extends StatefulWidget {
  const CreateGuildView({super.key});

  @override
  State<CreateGuildView> createState() => _CreateGuildViewState();
}

class _CreateGuildViewState extends State<CreateGuildView> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  String _selectedIcon = AppAssets.wizardMascot;
  Uint8List? _customImageBytes;
  String? _customImageExt;
  bool _isSuccess = false;
  final ImagePicker _picker = ImagePicker();

  final List<Map<String, String>> _availableEmblems = const [
    {'name': 'Wizard Master', 'asset': AppAssets.wizardMascot},
    {'name': 'Dragon Skull', 'asset': AppAssets.dragonSkull},
    {'name': 'Crystal Shard', 'asset': AppAssets.crystal01},
    {'name': 'Dragon Egg', 'asset': AppAssets.dragonEgg},
    {'name': 'Gems Chest', 'asset': AppAssets.gemsChest},
    {'name': 'Ancient Tomb', 'asset': AppAssets.tomb},
  ];

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() => setState(() {}));
    _descController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        final ext = pickedFile.path.split('.').last;
        setState(() {
          _customImageBytes = bytes;
          _customImageExt = ext;
        });
        if (mounted && Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.error,
            content: Text('Gagal memilih gambar: $e'),
          ),
        );
      }
    }
  }

  void _showEmblemPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1738),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 48,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.grey600,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'PILIH LAMBANG GUILD',
                      style: GoogleFonts.cinzel(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.yellowNormal,
                      ),
                    ),
                    const SizedBox(height: 18),
                    GestureDetector(
                      onTap: _pickImageFromGallery,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E2556),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: _customImageBytes != null
                                ? AppColors.yellowNormal
                                : const Color(0xFF4C3E8A),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: AppColors.purpleNormal.withValues(alpha: 0.25),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.add_photo_alternate_rounded,
                                color: AppColors.yellowNormal,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Pilih Foto Dari Galeri',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textWhite,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _customImageBytes != null
                                        ? 'Foto galeri terpilih ✓'
                                        : 'Gunakan logo / foto buatanmu sendiri',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: _customImageBytes != null
                                          ? AppColors.success
                                          : const Color(0xFF9E92FF),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right_rounded,
                              color: AppColors.textSecondary,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        const Expanded(child: Divider(color: Color(0xFF382E60))),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'Atau Preset Lambang',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF7A739C),
                            ),
                          ),
                        ),
                        const Expanded(child: Divider(color: Color(0xFF382E60))),
                      ],
                    ),
                    const SizedBox(height: 16),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _availableEmblems.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 1.0,
                      ),
                      itemBuilder: (context, index) {
                        final emblem = _availableEmblems[index];
                        final isSelected = _customImageBytes == null &&
                            _selectedIcon == emblem['asset'];

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _customImageBytes = null;
                              _customImageExt = null;
                              _selectedIcon = emblem['asset']!;
                            });
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF241D40),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.yellowNormal
                                    : const Color(0xFF3B3164),
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Image.asset(
                              emblem['asset']!,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => const Icon(
                                Icons.shield_rounded,
                                color: AppColors.yellowNormal,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _submitCreateGuild() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.error,
          content: Text('Nama Guild tidak boleh kosong!'),
        ),
      );
      return;
    }

    final authViewModel = context.read<AuthViewModel>();
    final userId = authViewModel.currentUser?.id ?? '';
    if (userId.isEmpty) return;

    final guildViewModel = context.read<GuildViewModel>();

    String finalIconUrl = _selectedIcon;
    if (_customImageBytes != null) {
      try {
        final client = Supabase.instance.client;
        final fileName =
            'guild_${DateTime.now().millisecondsSinceEpoch}.${_customImageExt ?? 'png'}';
        final path = 'guilds/$fileName';
        await client.storage.from(SupabaseConstants.avatarsBucket).uploadBinary(
              path,
              _customImageBytes!,
              fileOptions: const FileOptions(upsert: true),
            );
        finalIconUrl = client.storage
            .from(SupabaseConstants.avatarsBucket)
            .getPublicUrl(path);
      } catch (e) {
        finalIconUrl = _selectedIcon;
      }
    }

    final success = await guildViewModel.createGuild(
      name,
      userId,
      description: _descController.text.trim().isEmpty
          ? 'Contoh: The Thesis Warriors'
          : _descController.text.trim(),
      iconUrl: finalIconUrl,
    );

    if (!mounted) return;

    if (success) {
      setState(() => _isSuccess = true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.error,
          content: Text(guildViewModel.errorMessage ?? 'Gagal membuat guild'),
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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textWhite),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        'Buat Guild',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cinzel(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.yellowNormal,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Center(
                        child: GestureDetector(
                          onTap: _showEmblemPicker,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFF241D40),
                                  border: Border.all(
                                    color: const Color(0xFF5E54C2),
                                    width: 2.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF5E54C2).withValues(alpha: 0.35),
                                      blurRadius: 20,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                padding: _customImageBytes != null
                                    ? EdgeInsets.zero
                                    : const EdgeInsets.all(12),
                                child: ClipOval(
                                  child: _customImageBytes != null
                                      ? Image.memory(
                                          _customImageBytes!,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          _selectedIcon,
                                          fit: BoxFit.contain,
                                          errorBuilder: (context, error, stackTrace) => const Icon(
                                            Icons.auto_awesome_rounded,
                                            size: 60,
                                            color: AppColors.yellowNormal,
                                          ),
                                        ),
                                ),
                              ),
                              Positioned(
                                bottom: 2,
                                right: 2,
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF6F65D8),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFF1E1738),
                                      width: 2.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.4),
                                        blurRadius: 6,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.edit_rounded,
                                    color: AppColors.textWhite,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: GestureDetector(
                          onTap: _showEmblemPicker,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2E2556),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: const Color(0xFF4C3E8A)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.add_photo_alternate_rounded,
                                  size: 15,
                                  color: AppColors.yellowNormal,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Ketuk untuk Ganti Lambang / Foto',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.yellowNormal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Text(
                          'Jadilah pemimpin Guild dan undang\nteman-teman kamu.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Nama Guild',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textWhite,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF241D40),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF3B3164),
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          controller: _nameController,
                          maxLength: 40,
                          style: GoogleFonts.inter(fontSize: 14, color: AppColors.textWhite),
                          decoration: InputDecoration(
                            hintText: 'Contoh: The Thesis Warriors',
                            hintStyle: GoogleFonts.inter(
                              color: const Color(0xFF7A739C),
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            counterText: '',
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4, right: 4),
                          child: Text(
                            '${_nameController.text.length}/40',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: const Color(0xFF7A739C),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Deskripsi Guild',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textWhite,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF241D40),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF3B3164),
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          controller: _descController,
                          maxLines: 4,
                          maxLength: 40,
                          style: GoogleFonts.inter(fontSize: 14, color: AppColors.textWhite),
                          decoration: InputDecoration(
                            hintText: 'Contoh: The Thesis Warriors',
                            hintStyle: GoogleFonts.inter(
                              color: const Color(0xFF7A739C),
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(16),
                            counterText: '',
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4, right: 4),
                          child: Text(
                            '${_descController.text.length}/40',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: const Color(0xFF7A739C),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Setelah membuat guild:',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFFB5AFD4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildInfoBullet('Kamu akan menjadi Guild Leader'),
                      _buildInfoBullet('Kode undangan unik akan di-generate'),
                      _buildInfoBullet('Share kode ke teman untuk bergabung'),
                      const SizedBox(height: 24),
                      AppButton(
                        text: 'Buat Guild',
                        backgroundColor: const Color(0xFF2E2556),
                        textColor: AppColors.textWhite,
                        isLoading: context.watch<GuildViewModel>().isLoading,
                        onPressed: _submitCreateGuild,
                      ),
                      const SizedBox(height: 24),
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

  Widget _buildInfoBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '✦ ',
            style: TextStyle(color: Color(0xFF9E92FF), fontSize: 13),
          ),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(0xFFB5AFD4),
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessScreen() {
    final guildViewModel = context.watch<GuildViewModel>();
    final guildName = guildViewModel.guild?.name ?? _nameController.text;
    final guildCode = guildViewModel.guildCode ?? guildViewModel.guild?.code ?? '';

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
                const SizedBox(height: 20),
                Text(
                  '$guildName\nBerhasil Dibuat!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cinzel(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: AppColors.yellowNormal,
                    height: 1.25,
                  ),
                ),
                const Spacer(),
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF241D40),
                    border: Border.all(color: const Color(0xFF5E54C2), width: 2.5),
                  ),
                  child: ClipOval(
                    child: _customImageBytes != null
                        ? Image.memory(
                            _customImageBytes!,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            _selectedIcon,
                            fit: BoxFit.contain,
                          ),
                  ),
                ),
                const Spacer(),
                Text(
                  'Selamat Datang Guild Leader, kamu sekarang bisa mengundang teman-temanmu',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF241D40),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF3B3164)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Kode Guild',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            guildCode,
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textWhite,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy_rounded, color: AppColors.textWhite),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: guildCode));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: AppColors.success,
                              content: Text('Kode Guild berhasil disalin! 📋'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Bagikan kode ini ke teman agar mereka bisa bergabung ke guild-mu.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 28),
                AppButton(
                  text: 'Bagikan Kode',
                  icon: Icons.share_rounded,
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: guildCode));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: AppColors.info,
                        content: Text('Kode siap dibagikan (disalin ke clipboard) 🚀'),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                AppButton(
                  text: 'Lihat Guild',
                  backgroundColor: AppColors.white50,
                  textColor: AppColors.purpleDarker,
                  onPressed: () => context.go(AppRoutes.guild),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
