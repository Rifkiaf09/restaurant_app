import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/restaurant_models.dart';

class RestaurantApi {
  static const _baseUrl = 'https://restaurant-api.dicoding.dev';
  static const _imageSmall =
      'https://restaurant-api.dicoding.dev/images/small/';
  static const _imageMedium =
      'https://restaurant-api.dicoding.dev/images/medium/';

  String smallImageUrl(String id) => '$_imageSmall$id';
  String mediumImageUrl(String id) => '$_imageMedium$id';

  Future<List<RestaurantSummary>> fetchList() async {
    final res = await http.get(Uri.parse('$_baseUrl/list'));
    if (res.statusCode != 200) {
      throw Exception('Gagal memuat daftar restoran. (${res.statusCode})');
    }
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    final List list = data['restaurants'];
    if (list.isEmpty) return [];
    return list.map((e) => RestaurantSummary.fromJson(e)).toList();
  }

  Future<RestaurantDetail> fetchDetail(String id) async {
    final res = await http.get(Uri.parse('$_baseUrl/detail/$id'));
    if (res.statusCode != 200) {
      throw Exception('Gagal memuat detail restoran. (${res.statusCode})');
    }
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return RestaurantDetail.fromJson(data['restaurant']);
  }

  Future<List<RestaurantSummary>> search(String query) async {
    final res = await http.get(Uri.parse('$_baseUrl/search?q=$query'));
    if (res.statusCode != 200) {
      throw Exception('Gagal mencari restoran. (${res.statusCode})');
    }
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    final List list = data['restaurants'];
    return list.map((e) => RestaurantSummary.fromJson(e)).toList();
  }

  Future<List<CustomerReview>> addReview({
    required String id,
    required String name,
    required String review,
  }) async {
    final res = await http.post(
      Uri.parse('$_baseUrl/review'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': id, 'name': name, 'review': review}),
    );
    if (res.statusCode != 201) {
      throw Exception('Gagal mengirim ulasan. (${res.statusCode})');
    }
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    final List list = data['customerReviews'];
    return list.map((e) => CustomerReview.fromJson(e)).toList();
  }
}
