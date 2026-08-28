import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raion_hackjam/core/theme/app_colors.dart';

class AppButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;
  final double? width;
  final double height;
  final Color? backgroundColor;
  final Color? textColor;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.width,
    this.height = 54,
    this.backgroundColor,
    this.textColor,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = widget.onPressed != null && !widget.isLoading;
    final Color bgColor = widget.backgroundColor ??
        (_isPressed ? AppColors.primaryDark : AppColors.primary);

    final Color effectiveTextColor = widget.textColor ??
        (widget.isOutlined ? AppColors.primary : AppColors.textWhite);

    final Widget textWidget = Text(
      widget.text,
      style: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: effectiveTextColor,
      ),
    );

    final Widget content = widget.isLoading
        ? SizedBox(
            height: 22,
            width: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(effectiveTextColor),
            ),
          )
        : widget.icon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.icon,
                    size: 20,
                    color: effectiveTextColor,
                  ),
                  const SizedBox(width: 8),
                  textWidget,
                ],
              )
            : textWidget;

    return GestureDetector(
      onTapDown: isEnabled ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: isEnabled ? (_) => setState(() => _isPressed = false) : null,
      onTapCancel: isEnabled ? () => setState(() => _isPressed = false) : null,
      onTap: widget.isLoading ? null : widget.onPressed,
      child: AnimatedContainer(
        duration: 120.ms,
        width: widget.width ?? double.infinity,
        height: widget.height,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: widget.isOutlined
              ? Colors.transparent
              : (isEnabled
                  ? bgColor
                  : AppColors.primaryDark.withValues(alpha: 0.5)),
          borderRadius: BorderRadius.circular(14),
          border: widget.isOutlined
              ? Border.all(color: AppColors.primary, width: 1.5)
              : null,
          boxShadow: isEnabled && !widget.isOutlined
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: content,
      ),
    );
  }
}
