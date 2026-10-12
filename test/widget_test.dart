import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:campus_kart/src/app.dart';

void main() {
  testWidgets('CampusKart welcome and sign in flow works', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: CampusKartApp()));
    await tester.pumpAndSettle();

    // Verify Welcome screen elements
    expect(find.text('CampusKart'), findsAtLeast(1));
    expect(find.text('Your Campus Marketplace'), findsOneWidget);
    expect(find.text('Continue with Google'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);

    // Tap "Sign In" to enter the marketplace home
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();

    // Verify Home screen loaded
    expect(find.text('Popular Listings'), findsOneWidget);
  });
}
