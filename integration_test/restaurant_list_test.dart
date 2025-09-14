// import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:restaurant_app/main.dart' as app;

import 'robot/restaurant_list_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Restaurant List Page Tests', () {
    testWidgets('load list, navigate to search, favorites, and settings', (
      tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();

      final robot = RestaurantListRobot(tester);

      // Pastikan halaman utama ditemukan
      robot.expectPageFound();

      // Awal biasanya loading
      robot.expectLoading();
      await tester.pumpAndSettle();

      // Setelah fetch, harus ada data
      robot.expectHasData();

      // Buka halaman pencarian
      await robot.openSearch();
      expect(find.text('Search'), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();

      // Buka halaman favorit
      await robot.openFavorites();
      expect(find.text('Favorite Restaurants'), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();

      // Buka halaman pengaturan
      await robot.openSettings();
      expect(find.text('Pengaturan'), findsOneWidget);
    });
  });
}
