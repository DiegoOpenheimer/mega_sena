import 'package:flutter_test/flutter_test.dart';
import 'package:mega_sena/main.dart';

void main() {
  testWidgets("Test MyAppMegaSena", (WidgetTester tester) async {
    await tester.pumpWidget(MegaSenaApp());

    final Finder titleCreateGame = find.text('Mega Sena');

    expect(titleCreateGame, findsOneWidget);
  });
}