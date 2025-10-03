import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:id_card/main.dart';

void main() {
  testWidgets('Input page UI test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Student Name'), findsOneWidget);
    expect(find.text('Student ID (9 digits)'), findsOneWidget);
    expect(find.text('Pick Profile Photo'), findsOneWidget);
    expect(find.text('Generate ID Card'), findsOneWidget);
  });

  // Further widget interaction tests can be added here as needed
}
