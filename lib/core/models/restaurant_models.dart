class RestaurantSummary {
  final String id;
  final String name;
  final String description;
  final String pictureId;
  final String city;
  final double rating;

  RestaurantSummary({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
  });

  factory RestaurantSummary.fromJson(Map<String, dynamic> json) =>
      RestaurantSummary(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String? ?? '',
        pictureId: json['pictureId'] as String? ?? '',
        city: json['city'] as String? ?? '',
        rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'pictureId': pictureId,
        'city': city,
        'rating': rating,
      };
}

class Category {
  final String name;
  Category({required this.name});

  factory Category.fromJson(Map<String, dynamic> json) =>
      Category(name: json['name'] as String);

  Map<String, dynamic> toJson() => {'name': name};
}

class Menus {
  final List<Category> foods;
  final List<Category> drinks;

  Menus({required this.foods, required this.drinks});

  factory Menus.fromJson(Map<String, dynamic> json) => Menus(
        foods: (json['foods'] as List<dynamic>)
            .map((e) => Category.fromJson(e as Map<String, dynamic>))
            .toList(),
        drinks: (json['drinks'] as List<dynamic>)
            .map((e) => Category.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'foods': foods.map((f) => f.toJson()).toList(),
        'drinks': drinks.map((d) => d.toJson()).toList(),
      };
}

class CustomerReview {
  final String name;
  final String review;
  final String date;

  CustomerReview(
      {required this.name, required this.review, required this.date});

  factory CustomerReview.fromJson(Map<String, dynamic> json) => CustomerReview(
        name: json['name'] as String,
        review: json['review'] as String,
        date: json['date'] as String,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'review': review,
        'date': date,
      };
}

class RestaurantDetail {
  final String id;
  final String name;
  final String description;
  final String city;
  final String address;
  final String pictureId;
  final double rating;
  final Menus menus;
  final List<CustomerReview> customerReviews;

  RestaurantDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.address,
    required this.pictureId,
    required this.rating,
    required this.menus,
    required this.customerReviews,
  });

  factory RestaurantDetail.fromJson(Map<String, dynamic> json) =>
      RestaurantDetail(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String? ?? '',
        city: json['city'] as String? ?? '',
        address: json['address'] as String? ?? '',
        pictureId: json['pictureId'] as String? ?? '',
        rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
        menus: Menus.fromJson(json['menus'] as Map<String, dynamic>),
        customerReviews: (json['customerReviews'] as List<dynamic>)
            .map((e) => CustomerReview.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'city': city,
        'address': address,
        'pictureId': pictureId,
        'rating': rating,
        'menus': menus.toJson(),
        'customerReviews': customerReviews.map((c) => c.toJson()).toList(),
      };
}
