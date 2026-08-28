import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raion_hackjam/core/theme/app_colors.dart';

enum AppNavItem { home, quest, guild, profile }

class AppBottomNavBar extends StatelessWidget {
  final AppNavItem currentItem;
  final ValueChanged<AppNavItem> onItemSelected;

  const AppBottomNavBar({
    super.key,
    required this.currentItem,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.navbarBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            item: AppNavItem.home,
            label: 'Home',
            icon: Icons.home_rounded,
          ),
          _buildNavItem(
            item: AppNavItem.quest,
            label: 'Quest',
            icon: Icons.menu_book_rounded,
          ),
          _buildNavItem(
            item: AppNavItem.guild,
            label: 'Guild',
            icon: Icons.groups_rounded,
          ),
          _buildNavItem(
            item: AppNavItem.profile,
            label: 'Profile',
            icon: Icons.person_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required AppNavItem item,
    required String label,
    required IconData icon,
  }) {
    final bool isSelected = currentItem == item;
    final Color color =
        isSelected ? AppColors.navbarActive : AppColors.navbarInactive;

    return InkWell(
      onTap: () => onItemSelected(item),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 26,
              color: color,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
