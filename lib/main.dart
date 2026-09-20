import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'theme/app_theme.dart';
import 'providers/store_provider.dart';
import 'widgets/announcement_bar.dart';
import 'widgets/story_reels_section.dart';
import 'widgets/floating_reel_widget.dart';
import 'widgets/product_card.dart';
import 'widgets/cart_drawer.dart';
import 'widgets/app_drawer.dart';

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
      home: const WishLuckHomeScreen(),
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

                      // WishLuck Logo
                      Expanded(
                        child: Center(
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://cdn.shopify.com/s/files/1/0635/5206/1616/files/WISH_LUCK.avif?v=1772440958',
                            height: 38,
                            fit: BoxFit.contain,
                            placeholder: (context, url) => const Text(
                              'WISHLUCK',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: AppTheme.primaryBlue,
                                letterSpacing: 1.2,
                              ),
                            ),
                            errorWidget: (context, url, error) => const Text(
                              'WISHLUCK',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: AppTheme.primaryBlue,
                                letterSpacing: 1.2,
                              ),
                            ),
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

                            // Hero Collection Banner
                            SliverToBoxAdapter(
                              child: Container(
                                margin: const EdgeInsets.fromLTRB(
                                  16,
                                  10,
                                  16,
                                  12,
                                ),
                                height: 130,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: const LinearGradient(
                                    colors: [
                                      AppTheme.primaryBlue,
                                      Color(0xFF0056B3),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: AppTheme.cardShadow,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      // Image background
                                      CachedNetworkImage(
                                        imageUrl:
                                            'https://cdn.shopify.com/s/files/1/0635/5206/1616/collections/Best_Sellers.jpg?v=1778826156',
                                        fit: BoxFit.cover,
                                        errorWidget: (context, url, error) =>
                                            const SizedBox.shrink(),
                                      ),
                                      // Dark / Blue gradient overlay for readable text
                                      Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.black.withValues(
                                                alpha: 0.65,
                                              ),
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 3,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: AppTheme.accentYellow,
                                                borderRadius:
                                                    BorderRadius.circular(6),
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
                                  ),
                                ),
                              ),
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
                                      '${store.filteredProducts.length} Toys Found',
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
                            else
                              SliverPadding(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  4,
                                  16,
                                  80,
                                ),
                                sliver: SliverGrid(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 14,
                                        crossAxisSpacing: 14,
                                        childAspectRatio: 0.60,
                                      ),
                                  delegate: SliverChildBuilderDelegate((
                                    context,
                                    index,
                                  ) {
                                    final product =
                                        store.filteredProducts[index];
                                    return ProductCard(product: product);
                                  }, childCount: store.filteredProducts.length),
                                ),
                              ),
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
