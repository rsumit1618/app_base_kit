import 'package:example/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders both base_app_kit counter examples', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: ExampleApp()));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Counter without Riverpod'), findsOneWidget);
    expect(find.text('Value: 0'), findsOneWidget);

    await tester.tap(find.text('Increment').first);
    await tester.pump();

    expect(find.text('Value: 1'), findsOneWidget);

    await tester.tap(find.text('Riverpod'));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Counter with Riverpod'), findsOneWidget);
    expect(find.text('Value: 100'), findsOneWidget);
  });
}
