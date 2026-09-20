import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/store_provider.dart';
import '../theme/app_theme.dart';
import 'product_detail_sheet.dart';

class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isAdded = false;

  void _handleQuickAdd(BuildContext context) {
    final store = Provider.of<StoreProvider>(context, listen: false);
    store.addToCart(widget.product);

    setState(() => _isAdded = true);
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) {
        setState(() => _isAdded = false);
      }
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Added ${widget.product.title} to Bag',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.primaryBlue,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<StoreProvider>(context);
    final isFav = store.isFavorite(widget.product.id);
    final p = widget.product;

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (ctx) => ProductDetailSheet(product: p),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppTheme.cardShadow,
          border: Border.all(color: AppTheme.borderSubtle, width: 0.8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image & Badges
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Hero(
                      tag: 'product_img_${p.id}',
                      child: CachedNetworkImage(
                        imageUrl: p.primaryImage,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: const Color(0xFFF1F5F9),
                          child: const Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppTheme.primaryBlue,
                              ),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: AppTheme.pastelCyan,
                          child: const Center(
                            child: Icon(
                              Icons.toys_outlined,
                              color: AppTheme.primaryBlue,
                              size: 36,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Discount / Best Seller Badge
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3.5,
                      ),
                      decoration: BoxDecoration(
                        color: p.badge.contains('OFF')
                            ? AppTheme.saleRed
                            : AppTheme.accentOrange,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Text(
                        p.badge,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),

                  // Wishlist Heart Button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => store.toggleFavorite(p.id),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Icon(
                          isFav
                              ? Icons.favorite
                              : Icons.favorite_border_rounded,
                          color: isFav
                              ? AppTheme.saleRed
                              : AppTheme.textSecondary,
                          size: 17,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content Area
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Star Ratings & Reviews
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Color(0xFFFFB800),
                        size: 14,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        p.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${p.reviewsCount})',
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppTheme.textLight,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Product Title
                  SizedBox(
                    height: 36,
                    child: Text(
                      p.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        height: 1.25,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Price Information
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '₹${p.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                      const SizedBox(width: 6),
                      if (p.compareAtPrice > p.price)
                        Text(
                          '₹${p.compareAtPrice.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 11.5,
                            decoration: TextDecoration.lineThrough,
                            color: AppTheme.textLight,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Quick Add Button
                  SizedBox(
                    width: double.infinity,
                    height: 34,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isAdded
                            ? AppTheme.freshGreen
                            : AppTheme.primaryBlue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => _handleQuickAdd(context),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: _isAdded
                            ? const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                key: ValueKey('added'),
                                children: [
                                  Icon(
                                    Icons.check_rounded,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'ADDED',
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                key: ValueKey('add'),
                                children: [
                                  Icon(
                                    Icons.add_shopping_cart_rounded,
                                    size: 15,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'ADD TO CART',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
