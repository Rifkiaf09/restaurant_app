import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../core/db/database_helper.dart';
import '../core/models/restaurant_models.dart';
import '../core/state/result_state.dart';

class FavoriteProvider extends ChangeNotifier {
  final DatabaseHelper dbHelper;

  FavoriteProvider({required this.dbHelper}) {
    loadFavorites();
  }

  ResultState<List<RestaurantSummary>> _state = const Loading();
  ResultState<List<RestaurantSummary>> get state => _state;

  bool get loading => _state is Loading;
  List<RestaurantSummary> get favorites =>
      _state is Success<List<RestaurantSummary>>
      ? (_state as Success<List<RestaurantSummary>>).data
      : [];

  Future<void> loadFavorites() async {
    _state = const Loading();
    notifyListeners();
    try {
      final data = await dbHelper.getFavorites();
      if (data.isEmpty) {
        _state = const Empty();
      } else {
        _state = Success(data);
      }
    } catch (_) {
      _state = const Error("Gagal memuat daftar favorit.");
    }
    notifyListeners();
  }

  Future<void> addFavorite(RestaurantSummary restaurant) async {
    final map = {
      'id': restaurant.id,
      'name': restaurant.name,
      'city': restaurant.city,
      'pictureId': restaurant.pictureId,
      'rating': restaurant.rating,
      'payload': jsonEncode(restaurant.toJson()),
    };
    await dbHelper.insertFavorite(map);
    await loadFavorites();
  }

  Future<void> removeFavorite(String id) async {
    await dbHelper.removeFavorite(id);
    await loadFavorites();
  }

  Future<bool> isFavorite(String id) async {
    return await dbHelper.isFavorite(id);
  }
}
