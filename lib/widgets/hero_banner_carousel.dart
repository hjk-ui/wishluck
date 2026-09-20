import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/app_theme.dart';

class HeroBannerCarousel extends StatefulWidget {
  const HeroBannerCarousel({super.key});

  @override
  State<HeroBannerCarousel> createState() => _HeroBannerCarouselState();
}

class _HeroBannerCarouselState extends State<HeroBannerCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted && _pageController.hasClients) {
        final nextPage = (_currentPage + 1) % 2;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(16, 10, 16, 8),
          height: 155,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: AppTheme.cardShadow,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: PageView(
              controller: _pageController,
              onPageChanged: (idx) => setState(() => _currentPage = idx),
              children: [
                // Slide 1: Children Standing on Cloud (Learn & Play Every Day!)
                _KidsOnCloudBanner(),

                // Slide 2: Best Sellers Collection Banner
                _BestSellersBanner(),
              ],
            ),
          ),
        ),

        // Page Indicator Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            2,
            (idx) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == idx ? 20 : 6,
              height: 5,
              decoration: BoxDecoration(
                color: _currentPage == idx
                    ? AppTheme.primaryBlue
                    : AppTheme.borderSubtle,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
      ],
    );
  }
}

class _KidsOnCloudBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // High-res local asset with online fallback
        Image.asset(
          'assets/banner_kids_cloud.webp',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => CachedNetworkImage(
            imageUrl:
                'https://www.wishluck.in/cdn/shop/files/Frame_3_1.png?v=1775300598',
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: AppTheme.primaryLightBlue,
              child: const Center(child: CircularProgressIndicator()),
            ),
          ),
        ),

        // Subtle gradient overlay at bottom for tap pill
        Positioned(
          bottom: 8,
          left: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.65),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.touch_app_rounded,
                  color: AppTheme.accentYellow,
                  size: 13,
                ),
                SizedBox(width: 5),
                Text(
                  'Learn & Play Sound Book • Tap to Shop',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _BestSellersBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(
          imageUrl:
              'https://cdn.shopify.com/s/files/1/0635/5206/1616/collections/Best_Sellers.jpg?v=1778826156',
          fit: BoxFit.cover,
          errorWidget: (context, url, error) => Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primaryBlue, Color(0xFF0056B3)],
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withValues(alpha: 0.70),
                Colors.transparent,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.accentYellow,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'FEATURED COLLECTION',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Best Sellers',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Top-rated educational toys loved across India',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
