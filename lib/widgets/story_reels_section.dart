import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/store_provider.dart';
import '../theme/app_theme.dart';

class StoryReelsSection extends StatelessWidget {
  const StoryReelsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<StoreProvider>(context);
    final products = store.allProducts;
    if (products.isEmpty) return const SizedBox.shrink();

    // Select featured products for stories
    final storyProducts = products.take(6).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF007A), Color(0xFFFF8A00)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 14,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'WATCH & BUY!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Reels',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
              const Text(
                'Tap to explore',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 106,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: storyProducts.length,
            separatorBuilder: (context, index) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final product = storyProducts[index];
              return _StoryBubble(
                product: product,
                onTap: () => _openReelViewer(context, product),
              );
            },
          ),
        ),
      ],
    );
  }

  void _openReelViewer(BuildContext context, Product product) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.85),
      builder: (ctx) => _ReelPlayerModal(product: product),
    );
  }
}

class _StoryBubble extends StatefulWidget {
  final Product product;
  final VoidCallback onTap;

  const _StoryBubble({required this.product, required this.onTap});

  @override
  State<_StoryBubble> createState() => _StoryBubbleState();
}

class _StoryBubbleState extends State<_StoryBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        width: 70,
        child: Column(
          children: [
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Container(
                  padding: const EdgeInsets.all(2.5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [
                        AppTheme.primaryBlue,
                        Color(0xFFE02424),
                        AppTheme.accentYellow,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryBlue.withValues(
                          alpha: 0.2 + (_pulseController.value * 0.2),
                        ),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: widget.product.primaryImage,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey.shade200,
                          child: const Icon(
                            Icons.videocam,
                            color: Colors.grey,
                            size: 24,
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: AppTheme.pastelCyan,
                          child: const Icon(
                            Icons.toys,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 5),
            Text(
              widget.product.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReelPlayerModal extends StatefulWidget {
  final Product product;

  const _ReelPlayerModal({required this.product});

  @override
  State<_ReelPlayerModal> createState() => _ReelPlayerModalState();
}

class _ReelPlayerModalState extends State<_ReelPlayerModal>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  bool _isMuted = false;
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _progressController =
        AnimationController(vsync: this, duration: const Duration(seconds: 8))
          ..forward()
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _progressController.repeat();
            }
          });
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400, maxHeight: 680),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Product Image Display simulating Reel Video
              Hero(
                tag: 'reel_${widget.product.id}',
                child: CachedNetworkImage(
                  imageUrl: widget.product.primaryImage,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),
              ),

              // Gradient Vignette
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withValues(alpha: 0.6),
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.85),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.0, 0.2, 0.6, 1.0],
                  ),
                ),
              ),

              // Top Story Progress Bar & Controls
              Positioned(
                top: 12,
                left: 16,
                right: 16,
                child: Column(
                  children: [
                    // Progress Indicator
                    AnimatedBuilder(
                      animation: _progressController,
                      builder: (context, child) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: LinearProgressIndicator(
                            value: _progressController.value,
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.3,
                            ),
                            valueColor: const AlwaysStoppedAnimation(
                              Colors.white,
                            ),
                            minHeight: 3,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: Image.network(
                              'https://cdn.shopify.com/s/files/1/0635/5206/1616/files/WISH_LUCK.avif?v=1772440958',
                              errorBuilder: (ctx, err, stack) => const Icon(
                                Icons.star,
                                color: AppTheme.primaryBlue,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'WishLuck Official',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              'Best Selling Toys',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                          icon: Icon(
                            _isMuted ? Icons.volume_off : Icons.volume_up,
                            color: Colors.white,
                          ),
                          onPressed: () => setState(() => _isMuted = !_isMuted),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Right-hand Reel Action Buttons (Like, Share)
              Positioned(
                right: 16,
                bottom: 120,
                child: Column(
                  children: [
                    IconButton(
                      icon: Icon(
                        _isLiked ? Icons.favorite : Icons.favorite_border,
                        color: _isLiked ? Colors.red : Colors.white,
                        size: 28,
                      ),
                      onPressed: () => setState(() => _isLiked = !_isLiked),
                    ),
                    Text(
                      _isLiked ? '1.5k' : '1.4k',
                      style: const TextStyle(color: Colors.white, fontSize: 11),
                    ),
                    const SizedBox(height: 12),
                    IconButton(
                      icon: const Icon(
                        Icons.share_rounded,
                        color: Colors.white,
                        size: 26,
                      ),
                      onPressed: () {},
                    ),
                    const Text(
                      'Share',
                      style: TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ],
                ),
              ),

              // Bottom Shoppable Product Card Overlay
              Positioned(
                left: 12,
                right: 12,
                bottom: 16,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: widget.product.primaryImage,
                          width: 54,
                          height: 54,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.product.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  '₹${widget.product.price.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                    color: AppTheme.primaryBlue,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '₹${widget.product.compareAtPrice.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    decoration: TextDecoration.lineThrough,
                                    color: AppTheme.textLight,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                    vertical: 1,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.saleRed,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '${widget.product.discountPercent}% OFF',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentYellow,
                          foregroundColor: Colors.black,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Provider.of<StoreProvider>(
                            context,
                            listen: false,
                          ).addToCart(widget.product);
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Added "${widget.product.title}" to Cart!',
                              ),
                              backgroundColor: AppTheme.primaryBlue,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        child: const Text(
                          'Buy Now',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
