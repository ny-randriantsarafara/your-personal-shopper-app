import 'package:admin/shared/theme/app_colors.dart';
import 'package:admin/shared/theme/app_motion.dart';
import 'package:admin/shared/theme/app_radii.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('admin app exposes designer visual tokens', () {
    expect(AppColors.background.toARGB32(), 0xFFFBFBFD);
    expect(AppColors.foreground.toARGB32(), 0xFF111113);
    expect(AppRadii.card, 28);
    expect(AppMotion.pageTransition.inMilliseconds, 400);
  });
}
