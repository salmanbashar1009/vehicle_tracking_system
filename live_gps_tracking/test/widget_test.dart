import 'package:flutter_test/flutter_test.dart';
import 'package:live_gps_tracking/presentation/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that it builds without errors
    expect(find.byType(MyApp), findsOneWidget);
  });
}
