class ProductVariant {
  final String id;
  final String title;
  final double price;
  final double compareAtPrice;
  final String sku;
  final bool available;

  ProductVariant({
    required this.id,
    required this.title,
    required this.price,
    required this.compareAtPrice,
    required this.sku,
    required this.available,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? 'Default',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      compareAtPrice: (json['compare_at_price'] as num?)?.toDouble() ?? 0.0,
      sku: json['sku'] ?? '',
      available: json['available'] ?? true,
    );
  }

  int get discountPercent {
    if (compareAtPrice > price && compareAtPrice > 0) {
      return (((compareAtPrice - price) / compareAtPrice) * 100).round();
    }
    return 0;
  }
}

class Product {
  final String id;
  final String title;
  final String handle;
  final String ageCategory;
  final String badge;
  final double rating;
  final int reviewsCount;
  final List<ProductVariant> variants;
  final List<String> images;
  final List<String> bullets;

  Product({
    required this.id,
    required this.title,
    required this.handle,
    required this.ageCategory,
    required this.badge,
    required this.rating,
    required this.reviewsCount,
    required this.variants,
    required this.images,
    required this.bullets,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final vList =
        (json['variants'] as List<dynamic>?)
            ?.map((v) => ProductVariant.fromJson(v as Map<String, dynamic>))
            .toList() ??
        [];

    final imgList =
        (json['images'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
        [];

    final bList =
        (json['bullets'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    return Product(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      handle: json['handle'] ?? '',
      ageCategory: json['age_category'] ?? 'All',
      badge: json['badge'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 4.9,
      reviewsCount: (json['reviews_count'] as num?)?.toInt() ?? 120,
      variants: vList,
      images: imgList,
      bullets: bList,
    );
  }

  ProductVariant get defaultVariant => variants.isNotEmpty
      ? variants.first
      : ProductVariant(
          id: '0',
          title: 'Default',
          price: 499,
          compareAtPrice: 999,
          sku: '',
          available: true,
        );

  double get price => defaultVariant.price;
  double get compareAtPrice => defaultVariant.compareAtPrice;
  int get discountPercent => defaultVariant.discountPercent;
  String get primaryImage => images.isNotEmpty ? images.first : '';
}

class CartItem {
  final Product product;
  final ProductVariant variant;
  int quantity;

  CartItem({required this.product, required this.variant, this.quantity = 1});

  double get total => variant.price * quantity;
  double get compareTotal => variant.compareAtPrice * quantity;
  double get savings => compareTotal - total;
}
