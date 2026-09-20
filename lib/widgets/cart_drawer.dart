import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../providers/store_provider.dart';
import '../theme/app_theme.dart';

class CartDrawer extends StatelessWidget {
  const CartDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<StoreProvider>(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.40,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Drag Indicator & Header
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
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 16, 12),
                child: Row(
                  children: [
                    const Icon(
                      Icons.shopping_bag_outlined,
                      color: AppTheme.primaryBlue,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Your Bag (${store.cartCount})',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    if (store.cartItems.isNotEmpty)
                      TextButton(
                        onPressed: () => _confirmClearCart(context, store),
                        child: const Text(
                          'Clear',
                          style: TextStyle(
                            color: AppTheme.saleRed,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: AppTheme.borderSubtle),

              // Free Delivery Progress Banner
              _FreeShippingProgressBanner(store: store),

              // Cart Content or Empty State
              Expanded(
                child: store.cartItems.isEmpty
                    ? _EmptyCartView(
                        onShopNow: () => Navigator.of(context).pop(),
                      )
                    : ListView(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        children: [
                          // Item list
                          ...store.cartItems.map(
                            (item) => _CartItemTile(item: item),
                          ),

                          const SizedBox(height: 16),

                          // 10% Prepaid Discount Toggle
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0FDF4),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFBBF7D0),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.discount_rounded,
                                  color: AppTheme.freshGreen,
                                  size: 22,
                                ),
                                const SizedBox(width: 10),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '10% Prepaid Discount',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13,
                                          color: Color(0xFF15803D),
                                        ),
                                      ),
                                      Text(
                                        'Pay online via UPI/Card to save 10%',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFF166534),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Switch.adaptive(
                                  value: store.isPrepaidDiscountApplied,
                                  activeTrackColor: AppTheme.freshGreen,
                                  activeThumbColor: Colors.white,
                                  onChanged: store.togglePrepaidDiscount,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Bill Summary
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppTheme.background,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppTheme.borderSubtle),
                            ),
                            child: Column(
                              children: [
                                _SummaryRow(
                                  title: 'Item Total',
                                  value:
                                      '₹${store.cartSubtotal.toStringAsFixed(0)}',
                                ),
                                if (store.isPrepaidDiscountApplied) ...[
                                  const SizedBox(height: 8),
                                  _SummaryRow(
                                    title: '10% Prepaid Discount',
                                    value:
                                        '-₹${store.prepaidDiscountAmount.toStringAsFixed(0)}',
                                    valueColor: AppTheme.freshGreen,
                                  ),
                                ],
                                const SizedBox(height: 8),
                                _SummaryRow(
                                  title: 'Delivery Fee',
                                  value: store.isFreeShippingUnlocked
                                      ? 'FREE'
                                      : '₹49',
                                  valueColor: store.isFreeShippingUnlocked
                                      ? AppTheme.freshGreen
                                      : AppTheme.textPrimary,
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Divider(
                                    height: 1,
                                    color: AppTheme.borderSubtle,
                                  ),
                                ),
                                _SummaryRow(
                                  title: 'Grand Total',
                                  value:
                                      '₹${store.finalTotal.toStringAsFixed(0)}',
                                  isBold: true,
                                ),
                                if (store.totalSavings > 0) ...[
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFDCFCE7),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      '🎉 You are saving ₹${store.totalSavings.toStringAsFixed(0)} on this order!',
                                      style: const TextStyle(
                                        color: Color(0xFF15803D),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
              ),

              // Bottom Checkout Footer
              if (store.cartItems.isNotEmpty)
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 12,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryBlue,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () =>
                              _handleGokwikCheckout(context, store),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.lock_outline_rounded, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                'PROCEED TO CHECKOUT • ₹${store.finalTotal.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shield_rounded,
                            size: 14,
                            color: AppTheme.textLight,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '100% Secure Checkout with Gokwik UPI & Cards',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
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

  void _confirmClearCart(BuildContext context, StoreProvider store) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear Cart?'),
        content: const Text(
          'Are you sure you want to remove all items from your bag?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              store.clearCart();
              Navigator.of(ctx).pop();
            },
            child: const Text(
              'Clear',
              style: TextStyle(color: AppTheme.saleRed),
            ),
          ),
        ],
      ),
    );
  }

  void _handleGokwikCheckout(BuildContext context, StoreProvider store) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 28,
              backgroundColor: AppTheme.primaryLightBlue,
              child: Icon(
                Icons.check_circle_rounded,
                color: AppTheme.primaryBlue,
                size: 36,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Order Placed Successfully! 🎉',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Thank you for shopping at WishLuck! Your order of ₹${store.finalTotal.toStringAsFixed(0)} is confirmed and will be dispatched in 24 hours.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  store.clearCart();
                  Navigator.of(ctx).pop();
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Continue Shopping',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FreeShippingProgressBanner extends StatelessWidget {
  final StoreProvider store;
  const _FreeShippingProgressBanner({required this.store});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: store.isFreeShippingUnlocked
          ? const Color(0xFFF0FDF4)
          : AppTheme.pastelCyan.withValues(alpha: 0.4),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                store.isFreeShippingUnlocked
                    ? Icons.celebration_rounded
                    : Icons.local_shipping_outlined,
                color: store.isFreeShippingUnlocked
                    ? AppTheme.freshGreen
                    : AppTheme.primaryBlue,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  store.isFreeShippingUnlocked
                      ? 'Congratulations! You unlocked FREE Delivery! 🎉'
                      : 'Add ₹${store.amountNeededForFreeShipping.toStringAsFixed(0)} more for FREE Delivery 🚚',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: store.isFreeShippingUnlocked
                        ? const Color(0xFF15803D)
                        : AppTheme.primaryDarkBlue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: store.progressToFreeShipping,
              backgroundColor: Colors.black12,
              valueColor: AlwaysStoppedAnimation<Color>(
                store.isFreeShippingUnlocked
                    ? AppTheme.freshGreen
                    : AppTheme.primaryBlue,
              ),
              minHeight: 5,
            ),
          ),
        ],
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final dynamic item;
  const _CartItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<StoreProvider>(context, listen: false);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.borderSubtle),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: item.product.primaryImage,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.variant.title,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.textLight,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      '₹${item.variant.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                    const SizedBox(width: 6),
                    if (item.variant.compareAtPrice > item.variant.price)
                      Text(
                        '₹${item.variant.compareAtPrice.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 11,
                          decoration: TextDecoration.lineThrough,
                          color: AppTheme.textLight,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          // Quantity Controls
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: AppTheme.textLight,
                  size: 18,
                ),
                onPressed: () => store.removeFromCart(item),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.borderSubtle),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () => store.updateQuantity(item, -1),
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(Icons.remove, size: 14),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '${item.quantity}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => store.updateQuantity(item, 1),
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(Icons.add, size: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String title;
  final String value;
  final Color? valueColor;
  final bool isBold;

  const _SummaryRow({
    required this.title,
    required this.value,
    this.valueColor,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isBold ? 14 : 13,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w500,
            color: isBold ? AppTheme.textPrimary : AppTheme.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 16 : 13,
            fontWeight: isBold ? FontWeight.w900 : FontWeight.w700,
            color:
                valueColor ??
                (isBold ? AppTheme.primaryBlue : AppTheme.textPrimary),
          ),
        ),
      ],
    );
  }
}

class _EmptyCartView extends StatelessWidget {
  final VoidCallback onShopNow;
  const _EmptyCartView({required this.onShopNow});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.primaryLightBlue,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 54,
                color: AppTheme.primaryBlue,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Your Bag is Empty',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Explore WishLuck’s best-selling educational toys and get 10% off on your order!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: onShopNow,
              child: const Text(
                'Explore Bestsellers',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
