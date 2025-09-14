import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class RestaurantListRobot {
  final WidgetTester tester;
  RestaurantListRobot(this.tester);

  /// Pastikan halaman list restoran terbuka
  void expectPageFound() {
    expect(find.text('Restaurant'), findsOneWidget);
  }

  /// Cek apakah loading muncul
  void expectLoading() {
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  }

  /// Cek apakah ada data restoran tampil
  void expectHasData() {
    expect(find.byType(Card), findsWidgets);
  }

  /// Klik search button untuk membuka halaman pencarian
  Future<void> openSearch() async {
    final searchButton = find.byIcon(Icons.search);
    expect(searchButton, findsOneWidget);
    await tester.tap(searchButton);
    await tester.pumpAndSettle();
  }

  /// Klik favorit button untuk membuka halaman favorit
  Future<void> openFavorites() async {
    final favButton = find.byIcon(Icons.favorite);
    expect(favButton, findsOneWidget);
    await tester.tap(favButton);
    await tester.pumpAndSettle();
  }

  /// Klik settings button untuk membuka halaman pengaturan
  Future<void> openSettings() async {
    final settingsButton = find.byIcon(Icons.settings);
    expect(settingsButton, findsOneWidget);
    await tester.tap(settingsButton);
    await tester.pumpAndSettle();
  }
}
