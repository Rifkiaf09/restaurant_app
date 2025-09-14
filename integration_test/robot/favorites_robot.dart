import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

class FavoritesRobot {
  final WidgetTester tester;
  FavoritesRobot(this.tester);

  /// Pastikan halaman favorit terbuka
  void expectPageFound() {
    expect(find.text('Favorite Restaurants'), findsOneWidget);
  }

  /// Verifikasi jika list kosong
  void expectEmptyState() {
    expect(find.text('Belum ada restoran favorit'), findsOneWidget);
  }

  /// Jika sudah ada data, cek apakah minimal 1 card muncul
  void expectHasFavorites() {
    expect(find.byType(Card), findsWidgets);
  }
}
