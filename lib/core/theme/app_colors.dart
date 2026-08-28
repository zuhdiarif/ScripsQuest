import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color purpleLight = Color(0xFFF1F0FB);
  static const Color purpleLightHover = Color(0xFFEAE8F9);
  static const Color purpleLightActive = Color(0xFFD3CFF3);
  static const Color purpleNormal = Color(0xFF7065D9);
  static const Color purpleNormalHover = Color(0xFF655BC3);
  static const Color purpleNormalActive = Color(0xFF5A51AE);
  static const Color purpleDark = Color(0xFF544CA3);
  static const Color purpleDarkHover = Color(0xFF433D82);
  static const Color purpleDarkActive = Color(0xFF322D62);
  static const Color purpleDarker = Color(0xFF27234C);

  static const Color yellowLight = Color(0xFFFFFAE8);
  static const Color yellowLightHover = Color(0xFFFEF7DC);
  static const Color yellowLightActive = Color(0xFFFDEFB6);
  static const Color yellowNormal = Color(0xFFFACC15);
  static const Color yellowNormalHover = Color(0xFFE1B813);
  static const Color yellowNormalActive = Color(0xFFC8A311);
  static const Color yellowDark = Color(0xFFBC9910);
  static const Color yellowDarkHover = Color(0xFF967A0D);
  static const Color yellowDarkActive = Color(0xFF705C09);
  static const Color yellowDarker = Color(0xFF584707);

  static const Color grey50 = Color(0xFFE8E8E8);
  static const Color grey100 = Color(0xFFB8B8B8);
  static const Color grey200 = Color(0xFF969696);
  static const Color grey300 = Color(0xFF666666);
  static const Color grey400 = Color(0xFF484848);
  static const Color grey500 = Color(0xFF1A1A1A);
  static const Color grey600 = Color(0xFF181818);
  static const Color grey700 = Color(0xFF121212);
  static const Color grey800 = Color(0xFF0E0E0E);
  static const Color grey900 = Color(0xFF0B0B0B);

  static const Color white50 = Color(0xFFFFFFFF);
  static const Color white100 = Color(0xFFFDFDFD);
  static const Color white200 = Color(0xFFFDFDFD);
  static const Color white300 = Color(0xFFFCFCFC);
  static const Color white400 = Color(0xFFFBFBFB);
  static const Color white500 = Color(0xFFFAFAFA);
  static const Color white600 = Color(0xFFE4E4E4);
  static const Color white700 = Color(0xFFB2B2B2);
  static const Color white800 = Color(0xFF8A8A8A);
  static const Color white900 = Color(0xFF696969);

  static const Color blue50 = Color(0xFFE9ECEE);
  static const Color blue100 = Color(0xFFB9C3C9);
  static const Color blue200 = Color(0xFF98A6AF);
  static const Color blue300 = Color(0xFF687E8B);
  static const Color blue400 = Color(0xFF4B6575);
  static const Color blue500 = Color(0xFF1E3E52);
  static const Color blue600 = Color(0xFF1B384B);
  static const Color blue700 = Color(0xFF152C3A);
  static const Color blue800 = Color(0xFF11222D);
  static const Color blue900 = Color(0xFF0D1A22);

  static const Color primary = purpleNormal;
  static const Color primaryLight = purpleLightActive;
  static const Color primaryDark = purpleDark;

  static const Color secondary = purpleDarkActive;
  static const Color secondaryDark = purpleDarker;

  static const Color accent = yellowNormal;
  static const Color accentLight = yellowLightActive;
  static const Color accentDark = yellowDark;

  static const Color background = Color(0xFF19132E);
  static const Color surface = Color(0xFF241D40);
  static const Color surfaceCard = Color(0xFF241D40);
  static const Color surfaceVariant = Color(0xFF2E2556);

  static const LinearGradient purpleGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF2A214D),
      Color(0xFF221A3F),
      Color(0xFF19132E),
      Color(0xFF130F24),
    ],
    stops: [0.0, 0.35, 0.70, 1.0],
  );

  static const Color inputFill = Color(0xFF241D40);
  static const Color inputBorder = Color(0xFF3B3164);

  static const Color segmentBackground = Color(0xFF19132E);
  static const Color segmentActive = purpleNormal;

  static const Color navbarBackground = white50;
  static const Color navbarActive = purpleDarker;
  static const Color navbarInactive = grey200;

  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);

  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFD1FAE5);

  static const Color warning = yellowNormal;
  static const Color warningLight = yellowLightActive;

  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFDBEAFE);

  static const Color textPrimary = white50;
  static const Color textSecondary = grey200;
  static const Color textTertiary = grey300;
  static const Color textWhite = white50;
  static const Color textDark = grey900;

  static const Color border = grey400;
  static const Color borderFocused = purpleNormal;
  static const Color cardBorder = purpleDark;
  static const Color shadow = Color(0x3F000000);

  static const Color xpGold = yellowNormal;
  static const Color streakFlame = Color(0xFFFF5722);
  static const Color rankGold = yellowNormal;
  static const Color rankSilver = grey100;
  static const Color rankBronze = yellowDark;
}
