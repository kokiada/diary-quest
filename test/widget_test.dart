import 'package:flutter_test/flutter_test.dart';
import 'package:diaryquest/app.dart';

void main() {
  testWidgets('App should launch', (WidgetTester tester) async {
    await tester.pumpWidget(const DiaryQuestApp());
    expect(find.text('おかえりなさい、冒険者'), findsOneWidget);
  });
}
