import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/store_provider.dart';
import '../theme/app_theme.dart';
import 'cart_drawer.dart';

class ProductDetailSheet extends StatefulWidget {
  final Product product;

  const ProductDetailSheet({super.key, required this.product});

  @override
  State<ProductDetailSheet> createState() => _ProductDetailSheetState();
}

class _ProductDetailSheetState extends State<ProductDetailSheet> {
  late ProductVariant _selectedVariant;
  int _quantity = 1;
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _selectedVariant = widget.product.defaultVariant;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final images = p.images.isNotEmpty ? p.images : [p.primaryImage];

    return DraggableScrollableSheet(
      initialChildSize: 0.90,
      minChildSize: 0.50,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Drag handle
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Scrollable Details
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    // Image Carousel
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: AspectRatio(
                            aspectRatio: 1.1,
                            child: PageView.builder(
                              controller: _pageController,
                              itemCount: images.length,
                              onPageChanged: (idx) =>
                                  setState(() => _currentImageIndex = idx),
                              itemBuilder: (context, index) {
                                return CachedNetworkImage(
                                  imageUrl: images[index],
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: Colors.grey.shade100,
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        // Page dots
                        if (images.length > 1)
                          Positioned(
                            bottom: 12,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                images.length.clamp(0, 8),
                                (idx) => Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 3,
                                  ),
                                  width: _currentImageIndex == idx ? 18 : 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: _currentImageIndex == idx
                                        ? AppTheme.primaryBlue
                                        : Colors.white.withValues(alpha: 0.8),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                              ),
                            ),
                          ),

                        // Discount badge
                        Positioned(
                          top: 12,
                          left: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.saleRed,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${_selectedVariant.discountPercent}% OFF',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Title and Rating
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryLightBlue,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            p.ageCategory,
                            style: const TextStyle(
                              color: AppTheme.primaryBlue,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.star_rounded,
                          color: Color(0xFFFFB800),
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          p.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          ' (${p.reviewsCount} verified reviews)',
                          style: const TextStyle(
                            color: AppTheme.textLight,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    Text(
                      p.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        height: 1.3,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Price Display
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '₹${_selectedVariant.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                        const SizedBox(width: 10),
                        if (_selectedVariant.compareAtPrice >
                            _selectedVariant.price) ...[
                          Text(
                            '₹${_selectedVariant.compareAtPrice.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 16,
                              decoration: TextDecoration.lineThrough,
                              color: AppTheme.textLight,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Save ₹${(_selectedVariant.compareAtPrice - _selectedVariant.price).toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.freshGreen,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 10% Prepaid Orders Promo
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.pastelCyan.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.primaryBlue.withValues(alpha: 0.3),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.local_offer_rounded,
                            color: AppTheme.primaryBlue,
                            size: 20,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'EXTRA 10% OFF on Prepaid Orders (UPI/Cards)',
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primaryDarkBlue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Variant Selector (Pack options)
                    if (p.variants.length > 1) ...[
                      const Text(
                        'Select Pack / Option:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: p.variants.map((variant) {
                          final isSelected = _selectedVariant.id == variant.id;
                          return ChoiceChip(
                            label: Text(
                              '${variant.title} - ₹${variant.price.toStringAsFixed(0)}',
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : AppTheme.textPrimary,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                            selected: isSelected,
                            selectedColor: AppTheme.primaryBlue,
                            backgroundColor: Colors.white,
                            side: BorderSide(
                              color: isSelected
                                  ? AppTheme.primaryBlue
                                  : AppTheme.borderSubtle,
                            ),
                            onSelected: (val) {
                              if (val) {
                                setState(() => _selectedVariant = variant);
                              }
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Quantity Counter
                    Row(
                      children: [
                        const Text(
                          'Quantity:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: AppTheme.borderSubtle),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove, size: 18),
                                onPressed: _quantity > 1
                                    ? () => setState(() => _quantity--)
                                    : null,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Text(
                                  '$_quantity',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add, size: 18),
                                onPressed: () => setState(() => _quantity++),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Developmental Features / Bullets
                    const Text(
                      'Why Kids & Parents Love This:',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...p.bullets.map(
                      (b) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.check_circle_rounded,
                              color: AppTheme.freshGreen,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                b,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppTheme.textPrimary,
                                  height: 1.35,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 100), // Space for bottom buttons
                  ],
                ),
              ),

              // Bottom Sticky Action Buttons
              Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Add to Cart
                    Expanded(
                      flex: 1,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: AppTheme.primaryBlue,
                            width: 1.5,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          final store = Provider.of<StoreProvider>(
                            context,
                            listen: false,
                          );
                          store.addToCart(
                            p,
                            variant: _selectedVariant,
                            quantity: _quantity,
                          );
                          Navigator.of(context).pop();
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (ctx) => const CartDrawer(),
                          );
                        },
                        child: const Text(
                          'Add to Bag',
                          style: TextStyle(
                            color: AppTheme.primaryBlue,
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Gokwik Instant Buy Now Button
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentYellow,
                          foregroundColor: Colors.black,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          final store = Provider.of<StoreProvider>(
                            context,
                            listen: false,
                          );
                          store.addToCart(
                            p,
                            variant: _selectedVariant,
                            quantity: _quantity,
                          );
                          Navigator.of(context).pop();
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (ctx) => const CartDrawer(),
                          );
                        },
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.flash_on_rounded,
                                  color: Colors.black,
                                  size: 16,
                                ),
                                Text(
                                  'BUY NOW',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'Instant Checkout with UPI & Cards',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
