import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/store_provider.dart';
import '../theme/app_theme.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<StoreProvider>(context);

    final ageCategories = [
      {
        'name': 'All',
        'icon': Icons.apps_rounded,
        'subtitle': 'All Bestsellers',
      },
      {
        'name': '0-1 Years',
        'icon': Icons.child_friendly_rounded,
        'subtitle': 'Sensory & motor toys',
      },
      {
        'name': '1-3 Years',
        'icon': Icons.toys_rounded,
        'subtitle': 'Sound books & walkers',
      },
      {
        'name': '3-4 Years',
        'icon': Icons.smart_toy_rounded,
        'subtitle': 'Musical & action toys',
      },
      {
        'name': '4-5 Years',
        'icon': Icons.menu_book_rounded,
        'subtitle': 'Reading & math games',
      },
      {
        'name': '5-6 Years',
        'icon': Icons.school_rounded,
        'subtitle': 'Brain & logic puzzles',
      },
      {
        'name': '6+ Years',
        'icon': Icons.psychology_rounded,
        'subtitle': 'Curiosity & STEM kits',
      },
      {
        'name': 'Bundles',
        'icon': Icons.card_giftcard_rounded,
        'subtitle': 'Save up to 60%',
      },
    ];

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Drawer Header with WishLuck Branding
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primaryBlue, Color(0xFF005AC2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/wishluck_logo_rainbow.png',
                        height: 44,
                        width: 44,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'WishLuck',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          'Educational Toys',
                          style: TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.accentYellow,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'OFFICIAL',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'India’s Most Trusted Educational Toy Brand',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Loved by 50,000+ happy parents across India',
                  style: TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ),

          // Categories List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(18, 12, 18, 6),
                  child: Text(
                    'SHOP BY AGE',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textLight,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                ...ageCategories.map((cat) {
                  final isSelected = store.selectedCategory == cat['name'];
                  return ListTile(
                    dense: true,
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primaryBlue
                            : AppTheme.primaryLightBlue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        cat['icon'] as IconData,
                        size: 18,
                        color: isSelected ? Colors.white : AppTheme.primaryBlue,
                      ),
                    ),
                    title: Text(
                      cat['name'] as String,
                      style: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.w800
                            : FontWeight.w600,
                        color: isSelected
                            ? AppTheme.primaryBlue
                            : AppTheme.textPrimary,
                        fontSize: 13.5,
                      ),
                    ),
                    subtitle: Text(
                      cat['subtitle'] as String,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(
                            Icons.check_rounded,
                            color: AppTheme.primaryBlue,
                            size: 18,
                          )
                        : const Icon(
                            Icons.chevron_right_rounded,
                            color: AppTheme.textLight,
                            size: 18,
                          ),
                    onTap: () {
                      store.setCategory(cat['name'] as String);
                      Navigator.of(context).pop();
                    },
                  );
                }),

                const Divider(height: 24, color: AppTheme.borderSubtle),

                const Padding(
                  padding: EdgeInsets.fromLTRB(18, 4, 18, 6),
                  child: Text(
                    'CUSTOMER CARE',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textLight,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                ListTile(
                  dense: true,
                  leading: const Icon(Icons.local_shipping_outlined, size: 20),
                  title: const Text(
                    'Track Your Order',
                    style: TextStyle(fontSize: 13),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Order tracking link opened!'),
                      ),
                    );
                  },
                ),
                ListTile(
                  dense: true,
                  leading: const Icon(Icons.support_agent_rounded, size: 20),
                  title: const Text(
                    'WhatsApp Support (9 AM - 7 PM)',
                    style: TextStyle(fontSize: 13),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Opening WhatsApp Support...'),
                      ),
                    );
                  },
                ),
                ListTile(
                  dense: true,
                  leading: const Icon(Icons.verified_user_outlined, size: 20),
                  title: const Text(
                    'Safe & Secure Shopping',
                    style: TextStyle(fontSize: 13),
                  ),
                  onTap: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          // Drawer Footer
          Container(
            padding: const EdgeInsets.all(16),
            color: AppTheme.background,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_rounded, size: 14, color: AppTheme.textLight),
                SizedBox(width: 6),
                Text(
                  'WishLuck India • 100% Genuine Products',
                  style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
