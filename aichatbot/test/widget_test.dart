import 'package:flutter_test/flutter_test.dart';

import 'package:aichatbot/main.dart';

void main() {
  testWidgets('App boots and shows welcome', (WidgetTester tester) async {
    await tester.pumpWidget(const AIChatbotApp());
    await tester.pump();
    expect(find.text('AI Assistant'), findsOneWidget);
  });
}
