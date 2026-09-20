import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AnnouncementBar extends StatefulWidget {
  const AnnouncementBar({super.key});

  @override
  State<AnnouncementBar> createState() => _AnnouncementBarState();
}

class _AnnouncementBarState extends State<AnnouncementBar> {
  int _currentIndex = 0;
  Timer? _timer;

  final List<Map<String, dynamic>> _messages = [
    {
      'icon': Icons.local_offer_rounded,
      'text': '10% Off on All Prepaid Orders',
      'highlight': 'AUTO APPLIED',
    },
    {
      'icon': Icons.verified_rounded,
      'text': 'India’s Most Trusted Educational Toy Brand',
      'highlight': '★ 4.9 RATED',
    },
    {
      'icon': Icons.local_shipping_rounded,
      'text': 'Free Shipping on Orders Above ₹499',
      'highlight': 'FAST DISPATCH',
    },
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % _messages.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final current = _messages[_currentIndex];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryBlue, Color(0xFF0066D6)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return SlideTransition(
            position:
                Tween<Offset>(
                  begin: const Offset(0.0, 0.5),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
                ),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        child: Row(
          key: ValueKey<int>(_currentIndex),
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              current['icon'] as IconData,
              color: AppTheme.accentYellow,
              size: 15,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                current['text'] as String,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.accentYellow,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                current['highlight'] as String,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 9.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
