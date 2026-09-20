import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'providers/store_provider.dart';
import 'widgets/announcement_bar.dart';
import 'widgets/story_reels_section.dart';
import 'widgets/floating_reel_widget.dart';
import 'widgets/product_card.dart';
import 'widgets/cart_drawer.dart';
import 'widgets/app_drawer.dart';
import 'widgets/hero_banner_carousel.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => StoreProvider())],
      child: const WishLuckApp(),
    ),
  );
}

class WishLuckApp extends StatelessWidget {
  const WishLuckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WishLuck - Best Selling Kids Toys India',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}

class WishLuckHomeScreen extends StatefulWidget {
  const WishLuckHomeScreen({super.key});

  @override
  State<WishLuckHomeScreen> createState() => _WishLuckHomeScreenState();
}

class _WishLuckHomeScreenState extends State<WishLuckHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isSearchExpanded = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openCart() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const CartDrawer(),
    );
  }

  void _openSortModal(BuildContext context, StoreProvider store) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Text(
                    'SORT PRODUCTS BY',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textLight,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                ...SortOption.values.map((opt) {
                  final isSelected = store.selectedSort == opt;
                  return ListTile(
                    title: Text(
                      opt.label,
                      style: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.w800
                            : FontWeight.w500,
                        color: isSelected
                            ? AppTheme.primaryBlue
                            : AppTheme.textPrimary,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(
                            Icons.check_rounded,
                            color: AppTheme.primaryBlue,
                          )
                        : null,
                    onTap: () {
                      store.setSortOption(opt);
                      Navigator.of(ctx).pop();
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<StoreProvider>(context);

    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Top Cycling Announcement Bar
                const AnnouncementBar(),

                // Header Navigation Bar
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(
                        color: AppTheme.borderSubtle,
                        width: 0.8,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Hamburger Menu Button
                      IconButton(
                        icon: const Icon(
                          Icons.menu_rounded,
                          color: AppTheme.textPrimary,
                          size: 26,
                        ),
                        onPressed: () =>
                            _scaffoldKey.currentState?.openDrawer(),
                      ),

                      // WishLuck Rainbow Logo & Title
                      Expanded(
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  'assets/wishluck_logo_rainbow.png',
                                  height: 38,
                                  width: 38,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(
                                        Icons.auto_awesome,
                                        color: AppTheme.accentYellow,
                                      ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Wish',
                                        style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.w900,
                                          color: AppTheme.primaryBlue,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      Text(
                                        'Luck',
                                        style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.w900,
                                          color: Color(0xFFFF9F00),
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      SizedBox(width: 3),
                                      Icon(
                                        Icons.star_rounded,
                                        color: AppTheme.accentYellow,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'KIDS TOYS & BOOKS',
                                    style: TextStyle(
                                      fontSize: 8,
                                      fontWeight: FontWeight.w800,
                                      color: AppTheme.textSecondary,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Search Toggle
                      IconButton(
                        icon: Icon(
                          _isSearchExpanded
                              ? Icons.close_rounded
                              : Icons.search_rounded,
                          color: AppTheme.textPrimary,
                        ),
                        onPressed: () {
                          setState(() {
                            _isSearchExpanded = !_isSearchExpanded;
                            if (!_isSearchExpanded) {
                              _searchController.clear();
                              store.setSearchQuery('');
                            }
                          });
                        },
                      ),

                      // Cart Icon with Badge
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.shopping_bag_outlined,
                              color: AppTheme.textPrimary,
                              size: 24,
                            ),
                            onPressed: _openCart,
                          ),
                          if (store.cartCount > 0)
                            Positioned(
                              top: 6,
                              right: 6,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: AppTheme.saleRed,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 18,
                                  minHeight: 18,
                                ),
                                child: Center(
                                  child: Text(
                                    '${store.cartCount}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Collapsible Predictive Search Bar
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 250),
                  crossFadeState: _isSearchExpanded
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  firstChild: Container(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                    color: Colors.white,
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Search sound books, toys, puzzles...',
                        hintStyle: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textLight,
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: AppTheme.primaryBlue,
                          size: 20,
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded, size: 18),
                                onPressed: () {
                                  _searchController.clear();
                                  store.setSearchQuery('');
                                },
                              )
                            : null,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        filled: true,
                        fillColor: AppTheme.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (val) => store.setSearchQuery(val),
                    ),
                  ),
                  secondChild: const SizedBox.shrink(),
                ),

                // Main Scrollable Area
                Expanded(
                  child: store.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppTheme.primaryBlue,
                          ),
                        )
                      : CustomScrollView(
                          physics: const BouncingScrollPhysics(),
                          slivers: [
                            // Watch & Buy Quinn Reels Story Row
                            const SliverToBoxAdapter(
                              child: StoryReelsSection(),
                            ),

                            // Hero Collection Banner Carousel (with Children on Cloud)
                            const SliverToBoxAdapter(
                              child: HeroBannerCarousel(),
                            ),

                            // Category Age Pills Horizontal Scroll
                            SliverToBoxAdapter(
                              child: SizedBox(
                                height: 44,
                                child: ListView.separated(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: store.categories.length,
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(width: 8),
                                  itemBuilder: (context, index) {
                                    final cat = store.categories[index];
                                    final isSelected =
                                        store.selectedCategory == cat;
                                    return ChoiceChip(
                                      label: Text(cat),
                                      labelStyle: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : AppTheme.textPrimary,
                                        fontWeight: isSelected
                                            ? FontWeight.w700
                                            : FontWeight.w600,
                                        fontSize: 12.5,
                                      ),
                                      selected: isSelected,
                                      selectedColor: AppTheme.primaryBlue,
                                      backgroundColor: Colors.white,
                                      elevation: 0,
                                      side: BorderSide(
                                        color: isSelected
                                            ? AppTheme.primaryBlue
                                            : AppTheme.borderSubtle,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      onSelected: (val) {
                                        if (val) store.setCategory(cat);
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),

                            // Results Count & Sorting Header
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  12,
                                  16,
                                  8,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Showing ${store.displayedProductsCount} of ${store.totalProductsCount} Toys',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: AppTheme.textSecondary,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () =>
                                          _openSortModal(context, store),
                                      borderRadius: BorderRadius.circular(8),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: AppTheme.borderSubtle,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.sort_rounded,
                                              size: 15,
                                              color: AppTheme.primaryBlue,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              store.selectedSort.label,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                                color: AppTheme.textPrimary,
                                              ),
                                            ),
                                            const SizedBox(width: 2),
                                            const Icon(
                                              Icons.keyboard_arrow_down_rounded,
                                              size: 16,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Products Grid
                            if (store.filteredProducts.isEmpty)
                              const SliverFillRemaining(
                                hasScrollBody: false,
                                child: Center(
                                  child: Text(
                                    'No products found matching your search.',
                                    style: TextStyle(
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                ),
                              )
                            else ...[
                              SliverPadding(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  4,
                                  16,
                                  16,
                                ),
                                sliver: SliverGrid(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 14,
                                        crossAxisSpacing: 14,
                                        childAspectRatio: 0.60,
                                      ),
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      final product =
                                          store.paginatedProducts[index];
                                      return ProductCard(product: product);
                                    },
                                    childCount: store.paginatedProducts.length,
                                  ),
                                ),
                              ),

                              // Pagination "Load More" / End-of-List Indicator
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    8,
                                    16,
                                    90,
                                  ),
                                  child: store.hasMore
                                      ? Center(
                                          child: SizedBox(
                                            width: double.infinity,
                                            height: 48,
                                            child: OutlinedButton.icon(
                                              onPressed: store.isLoadingMore
                                                  ? null
                                                  : () => store.loadMore(),
                                              style: OutlinedButton.styleFrom(
                                                foregroundColor:
                                                    AppTheme.primaryBlue,
                                                side: const BorderSide(
                                                  color: AppTheme.primaryBlue,
                                                  width: 1.5,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                ),
                                                backgroundColor: Colors.white,
                                              ),
                                              icon: store.isLoadingMore
                                                  ? const SizedBox(
                                                      width: 18,
                                                      height: 18,
                                                      child:
                                                          CircularProgressIndicator(
                                                            strokeWidth: 2,
                                                            color: AppTheme
                                                                .primaryBlue,
                                                          ),
                                                    )
                                                  : const Icon(
                                                      Icons.expand_more_rounded,
                                                      size: 20,
                                                    ),
                                              label: Text(
                                                store.isLoadingMore
                                                    ? 'Loading more toys...'
                                                    : 'Load More Toys (${store.totalProductsCount - store.displayedProductsCount} remaining)',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 16,
                                          ),
                                          alignment: Alignment.center,
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    height: 1,
                                                    width: 40,
                                                    color:
                                                        AppTheme.borderSubtle,
                                                  ),
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                        ),
                                                    child: Icon(
                                                      Icons.verified_rounded,
                                                      color:
                                                          AppTheme.freshGreen,
                                                      size: 16,
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 1,
                                                    width: 40,
                                                    color:
                                                        AppTheme.borderSubtle,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                'You\'ve viewed all ${store.totalProductsCount} Best Sellers!',
                                                style: const TextStyle(
                                                  fontSize: 12.5,
                                                  fontWeight: FontWeight.w700,
                                                  color: AppTheme.textSecondary,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              const Text(
                                                'Curated with love by WishLuck India ❤️',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: AppTheme.textLight,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ],
                        ),
                ),
              ],
            ),

            // Floating Shoppable Reel Video Bubble
            const FloatingReelWidget(),
          ],
        ),
      ),
    );
  }
}
