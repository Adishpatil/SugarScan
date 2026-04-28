// Basic smoke test for SugarScan app launch.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sugarscan1/main.dart';

void main() {
  testWidgets('App launches without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const SugarScanApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
