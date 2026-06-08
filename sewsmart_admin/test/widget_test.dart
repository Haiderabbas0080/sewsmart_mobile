import 'package:flutter_test/flutter_test.dart';
import 'package:sewsmart_admin/main.dart';

void main() {
  testWidgets('SewSmart Admin app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SewSmartAdminApp());
    expect(find.text('SewSmart'), findsWidgets);
  });
}
