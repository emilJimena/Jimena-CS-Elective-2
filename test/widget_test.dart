import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('Fruit List Screen displays fruits correctly', (tester) async {
    await tester.pumpWidget(const FruitApp());

    expect(find.text('Fruit List'), findsOneWidget);
    expect(find.text('Apple'), findsOneWidget);
    expect(find.text('Banana'), findsOneWidget);
    expect(find.text('Orange'), findsOneWidget);
    expect(find.text('Grapes'), findsOneWidget);
    expect(find.text('Watermelon'), findsOneWidget);
  });
}
