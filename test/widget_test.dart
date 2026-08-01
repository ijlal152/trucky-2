import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trucky/app.dart';

void main() {
  testWidgets('App boots and shows the home screen', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: TruckyApp()));
    await tester.pumpAndSettle();

    expect(find.text('Welcome'), findsOneWidget);
  });
}
