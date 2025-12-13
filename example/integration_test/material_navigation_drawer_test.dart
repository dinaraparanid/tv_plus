import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tv_plus/foundation/foundation.dart';
import 'package:tv_plus_example/material/navigation/navigation_drawer_sample.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Material navigation drawer tests', () {
    testWidgets('...', (tester) async {
      await tester.pumpWidget(
        const NavigationDrawerSample(isTimerEnabled: false),
      );

      final contentFinder = find.byKey(NavigationDrawerSample.contentKey);
      final contentDpadFocus = tester.firstWidget(contentFinder) as DpadFocus;
      expect(contentDpadFocus.autofocus, true);
      expect(contentDpadFocus.canRequestFocus, true);
      expect(contentDpadFocus.focusNode?.hasFocus, true);

      final contentTextFinder = find.descendant(
        of: contentFinder,
        matching: find.byType(Text),
      );
      final contentText = tester.firstWidget(contentTextFinder) as Text;
      expect(
        contentText.data,
        '${ItemEntry(key: ValueKey(NavigationDrawerSample.items[0].$1))} content',
      );
    });
  });
}
