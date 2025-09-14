import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:restaurant_app/main.dart' as app;

import 'robot/favorites_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Favorites Page Tests', () {
    testWidgets('open favorites page and verify UI', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Buka halaman Favorit lewat IconButton
      final favButton = find.byIcon(Icons.favorite);
      expect(favButton, findsOneWidget);

      await tester.tap(favButton);
      await tester.pumpAndSettle();

      final robot = FavoritesRobot(tester);

      // Pastikan halaman ditemukan
      robot.expectPageFound();

      // Cek apakah kosong atau ada data
      if (find.text('Belum ada restoran favorit').evaluate().isNotEmpty) {
        robot.expectEmptyState();
      } else {
        robot.expectHasFavorites();
      }
    });
  });
}
