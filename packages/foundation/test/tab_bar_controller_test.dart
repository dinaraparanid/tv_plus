import 'package:test/test.dart';
import 'package:tv_plus/tv_plus.dart';

void main() {
  group('Tab bar controller tests', () {
    test('Create', () {
      expect(TvTabBarController.new, returnsNormally);
      expect(() => TvTabBarController(initialIndex: 1), returnsNormally);
      expect(() => TvTabBarController(initialIndex: -1), throwsArgumentError);
    });

    test('Select', () {
      final controller = TvTabBarController();
      expect(controller.selectedIndex, 0);

      controller.select(0);
      expect(controller.selectedIndex, 0);

      controller.select(1);
      expect(controller.selectedIndex, 1);

      expect(() => controller.select(-1), throwsArgumentError);
    });
  });
}
