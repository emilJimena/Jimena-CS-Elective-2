import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/main.dart';

void main() {
  testWidgets('renders the Shopify-style discovery dashboard', (tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(1280, 720);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    addTearDown(tester.binding.window.clearDevicePixelRatioTestValue);

    await tester.pumpWidget(const MerchantDashboardApp());
    await tester.pump();

    expect(find.text('shopify'), findsOneWidget);
    expect(find.text('Discover new products to sell'), findsOneWidget);
    expect(find.text('Instant import'), findsOneWidget);
    expect(find.text('Recommended suppliers'), findsOneWidget);
    expect(find.text('Trendsi'), findsAtLeastNWidgets(2));
    expect(find.text('Universal Standard'), findsAtLeastNWidgets(2));

    await tester.tap(find.text('Products'));
    await tester.pump();
    expect(find.text('Products'), findsAtLeastNWidgets(2));
    expect(find.text('Add'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
