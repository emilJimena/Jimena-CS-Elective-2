import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('renders on a small phone without layout errors', (tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(360, 640);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    addTearDown(tester.binding.window.clearDevicePixelRatioTestValue);

    await tester.pumpWidget(const SpotifyPlayerApp());

    expect(find.text('Akasaka Sad'), findsAtLeastNWidgets(1));
    expect(find.text('Rina Sawayama'), findsAtLeastNWidgets(1));
    expect(find.text('Add'), findsNothing);
    expect(find.text('Like'), findsNothing);
    expect(find.text('AirPods Max'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
