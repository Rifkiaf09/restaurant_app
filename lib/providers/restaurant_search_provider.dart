import 'package:flutter/material.dart';
import '../core/api/restaurant_api.dart';
import '../core/models/restaurant_models.dart';
import '../core/state/result_state.dart';

class RestaurantSearchProvider extends ChangeNotifier {
  final RestaurantApi api;
  RestaurantSearchProvider({required this.api});

  ResultState<List<RestaurantSummary>> _state = ResultState.empty();
  ResultState<List<RestaurantSummary>> get state => _state;

  Future<void> search(String query) async {
    if (query.isEmpty) {
      _state = ResultState.empty();
      notifyListeners();
      return;
    }

    _state = ResultState.loading();
    notifyListeners();

    try {
      final data = await api.search(query);
      if (data.isEmpty) {
        _state = ResultState.empty();
      } else {
        _state = ResultState.success(data);
      }
    } catch (_) {
      _state = ResultState.error(
        "Gagal melakukan pencarian. Periksa koneksi internet Anda.",
      );
    }

    notifyListeners();
  }
}
