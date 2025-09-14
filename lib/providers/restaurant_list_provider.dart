import 'package:flutter/material.dart';
import '../core/api/restaurant_api.dart';
import '../core/models/restaurant_models.dart';
import '../core/state/result_state.dart';

class RestaurantListProvider extends ChangeNotifier {
  final RestaurantApi api;

  // langsung panggil fetchList() begitu provider dibuat
  RestaurantListProvider({required this.api}) {
    fetchList();
  }

  ResultState<List<RestaurantSummary>> _state = ResultState.loading();
  ResultState<List<RestaurantSummary>> get state => _state;

  Future<void> fetchList() async {
    _state = ResultState.loading();
    notifyListeners();
    try {
      final data = await api.fetchList();
      if (data.isEmpty) {
        _state = ResultState.empty();
      } else {
        _state = ResultState.success(data);
      }
    } catch (_) {
      _state = ResultState.error(
        "Tidak dapat memuat daftar restoran. Periksa koneksi internet Anda.",
      );
    }
    notifyListeners();
  }
}
