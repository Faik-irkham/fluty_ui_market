import 'package:flutter_test/flutter_test.dart';
import 'package:fluty_ui_market/main.dart';

void main() {
  testWidgets('FlutyMarketApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FlutyMarketApp());
    await tester.pump(const Duration(seconds: 1));

    // Verify that the title FLUTY MARKET is present.
    expect(find.text('FLUTY MARKET'), findsOneWidget);
  });
}
