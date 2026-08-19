import 'package:flutter_test/flutter_test.dart';
import 'package:trucky/app.dart';

void main() {
  testWidgets('App boots: splash screen then home screen', (tester) async {
    await tester.pumpWidget(const TruckyApp());

    expect(find.text('Trucky'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.text('Hello, User'), findsOneWidget);
    expect(find.text('Demo Version'), findsOneWidget);
  });
}
