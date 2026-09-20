import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/product.dart';

enum SortOption {
  bestSelling('Best Selling'),
  featured('Featured'),
  priceLowToHigh('Price: Low to High'),
  priceHighToLow('Price: High to Low'),
  highestDiscount('Biggest Discount');

  final String label;
  const SortOption(this.label);
}

class StoreProvider with ChangeNotifier {
  List<Product> _allProducts = [];
  bool _isLoading = true;
  String _selectedCategory = 'All';
  String _searchQuery = '';
  SortOption _selectedSort = SortOption.bestSelling;

  final Set<String> _wishlistIds = {};
  final List<CartItem> _cartItems = [];
  bool _isPrepaidDiscountApplied = true;

  // Free shipping threshold in INR
  final double freeShippingThreshold = 499.0;

  StoreProvider() {
    loadProducts();
  }

  // Getters
  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  SortOption get selectedSort => _selectedSort;
  List<Product> get allProducts => _allProducts;
  List<CartItem> get cartItems => List.unmodifiable(_cartItems);
  int get cartCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);
  bool get isPrepaidDiscountApplied => _isPrepaidDiscountApplied;

  final List<String> categories = [
    'All',
    '0-1 Years',
    '1-3 Years',
    '3-4 Years',
    '4-5 Years',
    '5-6 Years',
    '6+ Years',
    'Bundles',
  ];

  Future<void> loadProducts() {
    _isLoading = true;
    notifyListeners();

    return rootBundle
        .loadString('assets/products.json')
        .then((jsonString) {
          final data = json.decode(jsonString);
          final list =
              (data['products'] as List<dynamic>?)
                  ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
                  .toList() ??
              [];
          _allProducts = list;
          _isLoading = false;
          notifyListeners();
        })
        .catchError((e) {
          _isLoading = false;
          notifyListeners();
        });
  }

  // Filtered & Sorted Products
  List<Product> get filteredProducts {
    var result = List<Product>.from(_allProducts);

    // Filter by Category
    if (_selectedCategory != 'All') {
      result = result
          .where(
            (p) =>
                p.ageCategory.toLowerCase() == _selectedCategory.toLowerCase(),
          )
          .toList();
    }

    // Filter by Search Query
    if (_searchQuery.trim().isNotEmpty) {
      final query = _searchQuery.toLowerCase().trim();
      result = result
          .where(
            (p) =>
                p.title.toLowerCase().contains(query) ||
                p.bullets.any((b) => b.toLowerCase().contains(query)),
          )
          .toList();
    }

    // Sort
    switch (_selectedSort) {
      case SortOption.bestSelling:
        // Keep order or sort by review counts
        result.sort((a, b) => b.reviewsCount.compareTo(a.reviewsCount));
        break;
      case SortOption.featured:
        break;
      case SortOption.priceLowToHigh:
        result.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortOption.priceHighToLow:
        result.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortOption.highestDiscount:
        result.sort((a, b) => b.discountPercent.compareTo(a.discountPercent));
        break;
    }

    return result;
  }

  // Category setter
  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Search setter
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Sort setter
  void setSortOption(SortOption sort) {
    _selectedSort = sort;
    notifyListeners();
  }

  // Wishlist actions
  bool isFavorite(String productId) => _wishlistIds.contains(productId);

  void toggleFavorite(String productId) {
    if (_wishlistIds.contains(productId)) {
      _wishlistIds.remove(productId);
    } else {
      _wishlistIds.add(productId);
    }
    notifyListeners();
  }

  // Cart actions
  void addToCart(Product product, {ProductVariant? variant, int quantity = 1}) {
    final targetVariant = variant ?? product.defaultVariant;
    final index = _cartItems.indexWhere(
      (item) =>
          item.product.id == product.id && item.variant.id == targetVariant.id,
    );

    if (index >= 0) {
      _cartItems[index].quantity += quantity;
    } else {
      _cartItems.add(
        CartItem(product: product, variant: targetVariant, quantity: quantity),
      );
    }
    notifyListeners();
  }

  void updateQuantity(CartItem item, int delta) {
    final index = _cartItems.indexOf(item);
    if (index >= 0) {
      final newQty = _cartItems[index].quantity + delta;
      if (newQty <= 0) {
        _cartItems.removeAt(index);
      } else {
        _cartItems[index].quantity = newQty;
      }
      notifyListeners();
    }
  }

  void removeFromCart(CartItem item) {
    _cartItems.remove(item);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  void togglePrepaidDiscount(bool value) {
    _isPrepaidDiscountApplied = value;
    notifyListeners();
  }

  // Financial Calculations
  double get cartSubtotal =>
      _cartItems.fold(0.0, (sum, item) => sum + item.total);

  double get cartCompareTotal =>
      _cartItems.fold(0.0, (sum, item) => sum + item.compareTotal);

  double get totalSavings =>
      (cartCompareTotal - cartSubtotal) + prepaidDiscountAmount;

  double get prepaidDiscountAmount {
    if (!_isPrepaidDiscountApplied || cartSubtotal == 0) return 0.0;
    return (cartSubtotal * 0.10); // 10% Off Prepaid Orders
  }

  double get finalTotal =>
      (cartSubtotal - prepaidDiscountAmount).clamp(0.0, double.infinity);

  double get progressToFreeShipping {
    if (freeShippingThreshold <= 0) return 1.0;
    return (cartSubtotal / freeShippingThreshold).clamp(0.0, 1.0);
  }

  bool get isFreeShippingUnlocked => cartSubtotal >= freeShippingThreshold;

  double get amountNeededForFreeShipping =>
      (freeShippingThreshold - cartSubtotal).clamp(0.0, double.infinity);
}
