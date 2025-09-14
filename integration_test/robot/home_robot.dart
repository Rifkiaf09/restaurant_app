import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

class HomeRobot {
  final WidgetTester tester;
  HomeRobot(this.tester);

  void expectTitleFound() {
    expect(find.text('Restaurant App'), findsOneWidget);
  }

  Future<void> tapBottomNavFavorites() async {
    final favIcon = find.byIcon(Icons.favorite);
    expect(favIcon, findsOneWidget);
    await tester.tap(favIcon);
    await tester.pumpAndSettle();
  }

  Future<void> tapBottomNavSettings() async {
    final settingsIcon = find.byIcon(Icons.settings);
    expect(settingsIcon, findsOneWidget);
    await tester.tap(settingsIcon);
    await tester.pumpAndSettle();
  }
}
