import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:wishluck/main.dart';
import 'package:wishluck/screens/splash_screen.dart';
import 'package:wishluck/providers/store_provider.dart';

void main() {
  testWidgets('WishLuck App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => StoreProvider())],
        child: const WishLuckApp(),
      ),
    );

    // Verify SplashScreen is displayed on launch
    expect(find.byType(SplashScreen), findsOneWidget);

    // Fast-forward past splash timer to WishLuckHomeScreen
    await tester.pump(const Duration(milliseconds: 2600));
    await tester.pump(const Duration(milliseconds: 400));

    // Verify WishLuckHomeScreen appears
    expect(find.byType(WishLuckHomeScreen), findsOneWidget);
  });
}
