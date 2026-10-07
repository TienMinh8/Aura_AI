import 'package:flutter_test/flutter_test.dart';
import 'package:aura/main.dart';

void main() {
  testWidgets('Aura app smoke test', (WidgetTester tester) async {
    // Build AuraApp and trigger a frame.
    await tester.pumpWidget(const AuraApp());

    // Verify that Today tab is visible
    expect(find.text('Today'), findsWidgets);
  });
}
