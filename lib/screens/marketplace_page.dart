import 'dart:math';

import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

import '../core/app_theme.dart';
import '../models/product_model.dart';
import '../widgets/animated_background.dart';
import '../widgets/marketplace_header.dart';
import '../widgets/search_bar.dart' as custom;
import '../widgets/category_tab_bar.dart';
import '../widgets/product_card.dart';
import 'product_detail_sheet.dart';

/// Halaman utama Fluty Market dengan grid produk, animasi, filter, sorting, & cart berbahasa Indonesia.
class MarketplacePage extends StatefulWidget {
  const MarketplacePage({super.key});

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage>
    with TickerProviderStateMixin {
  late final AnimationController _bgCtrl;
  late final AnimationController _headerCtrl;
  late final AnimationController _particleCtrl;

  late final List<Offset> _particles;
  late final List<double> _particleSizes;

  int _selectedCategory = 0;
  String _searchText = '';
  int _cartCount = 0;
  String _sortBy = 'Populer';
  final TextEditingController _searchCtrl = TextEditingController();

  static const List<String> _categories = [
    'SEMUA',
    'TERLARIS',
    'TERBATAS',
    'VINTAGE',
    'LANGKA',
  ];

  @override
  void initState() {
    super.initState();

    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);

    _headerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _particleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    final rng = Random();
    _particles = List.generate(
      25,
      (_) => Offset(rng.nextDouble(), rng.nextDouble()),
    );
    _particleSizes = List.generate(25, (_) => rng.nextDouble() * 2 + 1);
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _headerCtrl.dispose();
    _particleCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  List<LuxuryProduct> get _filtered {
    List<LuxuryProduct> result = List.from(luxuryProducts);
    if (_selectedCategory != 0) {
      result = result
          .where((p) => p.badge == _categories[_selectedCategory])
          .toList();
    }
    if (_searchText.isNotEmpty) {
      final q = _searchText.toLowerCase();
      result = result
          .where(
            (p) =>
                p.name.toLowerCase().contains(q) ||
                p.originalName.toLowerCase().contains(q),
          )
          .toList();
    }

    // Sorting
    if (_sortBy == 'Harga: Rendah ke Tinggi') {
      result.sort((a, b) => a.price.compareTo(b.price));
    } else if (_sortBy == 'Harga: Tinggi ke Rendah') {
      result.sort((a, b) => b.price.compareTo(a.price));
    } else if (_sortBy == 'Rating') {
      result.sort((a, b) => b.rating.compareTo(a.rating));
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          AnimatedBackground(animation: _bgCtrl),
          AnimatedBuilder(
            animation: _particleCtrl,
            builder: (_, _) => CustomPaint(
              size: MediaQuery.of(context).size,
              painter: ParticlePainter(
                _particleCtrl.value,
                _particles,
                _particleSizes,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                FadeInDown(
                  duration: const Duration(milliseconds: 500),
                  child: MarketplaceHeader(
                    shimmerAnimation: _headerCtrl,
                    onNotificationTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Tidak ada pemberitahuan baru'),
                        ),
                      );
                    },
                  ),
                ),
                FadeInDown(
                  delay: const Duration(milliseconds: 100),
                  duration: const Duration(milliseconds: 500),
                  child: custom.SearchBar(
                    controller: _searchCtrl,
                    onChanged: (v) => setState(() => _searchText = v),
                  ),
                ),
                FadeInDown(
                  delay: const Duration(milliseconds: 150),
                  duration: const Duration(milliseconds: 500),
                  child: const _PromoBanner(),
                ),
                FadeInDown(
                  delay: const Duration(milliseconds: 200),
                  duration: const Duration(milliseconds: 500),
                  child: CategoryTabBar(
                    categories: _categories,
                    selectedIndex: _selectedCategory,
                    onTap: (i) => setState(() => _selectedCategory = i),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Koleksi Kurasi (${_filtered.length})',
                        style: AppTextStyles.titleSm,
                      ),
                      const Spacer(),
                      _SortDropdown(
                        currentSort: _sortBy,
                        onChanged: (val) => setState(() => _sortBy = val),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Expanded(child: _buildGrid()),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _CartFab(count: _cartCount, onTap: _showCartSheet),
    );
  }

  Widget _buildGrid() {
    final items = _filtered;

    if (items.isEmpty) {
      return Center(
        child: FadeIn(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.search_off_rounded,
                size: 56,
                color: AppColors.textMuted,
              ),
              const SizedBox(height: 16),
              const Text(
                'Tidak ada produk ditemukan',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.68,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: items.length,
        itemBuilder: (_, index) => FadeInUp(
          delay: Duration(milliseconds: 80 * index),
          duration: const Duration(milliseconds: 450),
          child: ProductCard(
            product: items[index],
            onFavoriteToggle: () => setState(
              () => items[index].isFavorited = !items[index].isFavorited,
            ),
            onAddToCart: () => setState(() => _cartCount++),
            onTap: () => _showDetail(items[index]),
          ),
        ),
      ),
    );
  }

  void _showDetail(LuxuryProduct product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ProductDetailSheet(
        product: product,
        onAddToCart: () => setState(() => _cartCount++),
      ),
    );
  }

  void _showCartSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CartSheet(
        cartCount: _cartCount,
        onCheckout: () {
          setState(() => _cartCount = 0);
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              backgroundColor: AppColors.card,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.verified_rounded,
                    color: AppColors.gold,
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Pesanan Dikonfirmasi!',
                    style: AppTextStyles.titleMd,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Pesanan eksklusif Anda sedang disiapkan dan dikurasi dengan teliti oleh tim ahli kami.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.gold,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Luar Biasa',
                        style: AppTextStyles.button,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ──────────────── Promo Banner ────────────────
class _PromoBanner extends StatelessWidget {
  const _PromoBanner();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          gradient: AppColors.purpleGradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.purple.withValues(alpha: 0.35),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      '✨ KURASI EKSKLUSIF',
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Barang Unik & Berkelas',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Tingkatkan gaya hidup Anda dengan koleksi benda penuh cerita.',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 10,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.diamond_rounded, color: AppColors.gold, size: 48),
          ],
        ),
      ),
    );
  }
}

// ──────────────── Sort Dropdown ────────────────
class _SortDropdown extends StatelessWidget {
  final String currentSort;
  final ValueChanged<String> onChanged;

  const _SortDropdown({required this.currentSort, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: onChanged,
      color: AppColors.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      itemBuilder: (_) =>
          [
                'Populer',
                'Harga: Rendah ke Tinggi',
                'Harga: Tinggi ke Rendah',
                'Rating',
              ]
              .map(
                (s) => PopupMenuItem(
                  value: s,
                  child: Text(
                    s,
                    style: const TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 13,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              )
              .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.purple.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.sort_rounded, size: 14, color: AppColors.gold),
            const SizedBox(width: 4),
            Text(
              currentSort,
              style: const TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────── Cart FAB ────────────────
class _CartFab extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const _CartFab({required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ZoomIn(
      delay: const Duration(milliseconds: 700),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            gradient: AppColors.goldGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.gold.withValues(alpha: 0.5),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              const Center(
                child: Icon(
                  Icons.shopping_bag_rounded,
                  color: Colors.black,
                  size: 28,
                ),
              ),
              if (count > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: AppColors.rose,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$count',
                      style: const TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
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

// ──────────────── Cart Bottom Sheet ────────────────
class _CartSheet extends StatelessWidget {
  final int cartCount;
  final VoidCallback onCheckout;

  const _CartSheet({required this.cartCount, required this.onCheckout});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(color: AppColors.purple.withValues(alpha: 0.3)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textMuted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('🛒  Keranjang Belanja', style: AppTextStyles.titleMd),
          const SizedBox(height: 8),
          Text(
            '$cartCount item unik terpilih di keranjang Anda',
            style: const TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const Text(
                'Pengiriman Kurir Kilat',
                style: AppTextStyles.titleSm,
              ),
              const Spacer(),
              Text(
                'Rp 0 (Gratis VIP)',
                style: AppTextStyles.price.copyWith(color: AppColors.emerald),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: cartCount > 0 ? onCheckout : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: cartCount > 0 ? AppColors.goldGradient : null,
                  color: cartCount > 0 ? null : AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  alignment: Alignment.center,
                  child: Text(
                    cartCount > 0
                        ? 'Lanjutkan ke Checkout'
                        : 'Keranjang Masih Kosong',
                    style: AppTextStyles.button.copyWith(
                      color: cartCount > 0 ? Colors.black : AppColors.textMuted,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
