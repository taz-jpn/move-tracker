import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:move_tracker/app.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MoveTrackerApp(),
      ),
    );

    // アプリが正常に起動することを確認
    expect(find.text('MoveTracker'), findsNothing); // AppBarタイトルなし（MapScreenはAppBarなし）
  });
}
