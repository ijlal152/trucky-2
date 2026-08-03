import 'package:flutter_test/flutter_test.dart';
import 'package:trucky/app.dart';

void main() {
  testWidgets('App boots and shows the home screen', (tester) async {
    await tester.pumpWidget(const TruckyApp());
    await tester.pumpAndSettle();

    expect(find.text('Hello, User'), findsOneWidget);
    expect(find.text('Demo Version'), findsOneWidget);
  });
}
