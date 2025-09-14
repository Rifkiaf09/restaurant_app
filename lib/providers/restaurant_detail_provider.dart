import 'package:flutter/foundation.dart';

import '../core/api/restaurant_api.dart';
import '../core/models/restaurant_models.dart';
import '../core/state/result_state.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final RestaurantApi api;
  RestaurantDetailProvider({required this.api});

  ResultState<RestaurantDetail> _state = ResultState.loading();
  ResultState<RestaurantDetail> get state => _state;

  bool posting = false;

  Future<void> fetchDetail(String id) async {
    _state = ResultState.loading();
    notifyListeners();
    try {
      final data = await api.fetchDetail(id);
      _state = ResultState.success(data);
    } catch (_) {
      _state = ResultState.error(
          'Gagal memuat detail restoran. Silakan periksa koneksi internet Anda.');
    }
    notifyListeners();
  }

  Future<void> addReview(String id, String name, String review) async {
    if (posting) return;
    posting = true;
    notifyListeners();
    try {
      await api.addReview(id: id, name: name, review: review);
      // refresh detail after successful post
      await fetchDetail(id);
    } catch (_) {
      _state = ResultState.error(
          'Gagal mengirim ulasan. Silakan periksa koneksi internet Anda.');
      notifyListeners();
    } finally {
      posting = false;
      notifyListeners();
    }
  }
}
