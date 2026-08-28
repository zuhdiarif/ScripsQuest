import 'dart:math';

class GuildCodeGenerator {
  const GuildCodeGenerator._();

  static String generateCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ';
    const digits = '0123456789';
    final random = Random();
    final letters =
        List.generate(2, (_) => chars[random.nextInt(chars.length)]).join();
    final numbers =
        List.generate(4, (_) => digits[random.nextInt(digits.length)]).join();
    return 'S-$letters$numbers';
  }

  static bool isValidCode(String code) {
    final clean = code.trim().toUpperCase();
    final regex = RegExp(r'^S-[A-Z0-9]{4,8}$');
    return regex.hasMatch(clean);
  }
}
