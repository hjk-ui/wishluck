import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:wishluck/main.dart';
import 'package:wishluck/providers/store_provider.dart';

void main() {
  testWidgets('WishLuck App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => StoreProvider())],
        child: const WishLuckApp(),
      ),
    );

    // Verify WishLuck title / branding appears
    expect(find.byType(WishLuckHomeScreen), findsOneWidget);
  });
}
