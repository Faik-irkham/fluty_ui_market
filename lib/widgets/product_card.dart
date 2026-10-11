import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../core/app_theme.dart';
import '../models/product_model.dart';

/// Badge warna-warni di sudut kartu produk.
class ProductBadge extends StatelessWidget {
  final String badge;

  const ProductBadge({super.key, required this.badge});

  Color get _color => switch (badge) {
        'TERLARIS'  => const Color(0xFFFFD700),
        'TERBATAS'  => AppColors.rose,
        'VINTAGE'   => AppColors.purple,
        'LANGKA'    => AppColors.emerald,
        'ARTISAN'   => const Color(0xFFEC4899),
        'KOLEKTOR'  => AppColors.cyan,
        'EKSKLUSIF' => const Color(0xFF14B8A6),
        _           => AppColors.cyan,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: _color.withValues(alpha: 0.4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Text(
        badge,
        style: AppTextStyles.labelSm.copyWith(
          color: badge == 'TERLARIS' ? Colors.black : Colors.white,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

/// Kartu produk di grid marketplace dengan gambar asli Unsplash, animasi press, favorite, & add to cart.
class ProductCard extends StatefulWidget {
  final LuxuryProduct product;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onAddToCart;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onFavoriteToggle,
    required this.onAddToCart,
    required this.onTap,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressCtrl;
  late final Animation<double> _scaleAnim;
  bool _addedToCart = false;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 140),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _pressCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  void _onTapDown(_) => _pressCtrl.forward();
  void _onTapUp(_) => _pressCtrl.reverse();
  void _onTapCancel() => _pressCtrl.reverse();

  void _handleAddToCart() {
    widget.onAddToCart();
    setState(() => _addedToCart = true);
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) setState(() => _addedToCart = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (_, child) =>
            Transform.scale(scale: _scaleAnim.value, child: child),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: AppColors.purple.withValues(alpha: 0.2),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: p.gradientColors[0].withValues(alpha: 0.15),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 5, child: _ImageArea(product: p)),
              Expanded(
                flex: 4,
                child: _InfoArea(
                  product: p,
                  addedToCart: _addedToCart,
                  onAddToCart: _handleAddToCart,
                  onFavoriteToggle: widget.onFavoriteToggle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ──────────────── Image Area with Real Unsplash Image ────────────────
class _ImageArea extends StatelessWidget {
  final LuxuryProduct product;

  const _ImageArea({required this.product});

  @override
  Widget build(BuildContext context) {
    final p = product;
    return Stack(
      children: [
        // Real Image with loading & error handler
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
          child: Image.network(
            p.imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Shimmer.fromColors(
                baseColor: AppColors.surface,
                highlightColor: AppColors.card,
                child: Container(color: AppColors.surface),
              );
            },
            errorBuilder: (context, error, stackTrace) => Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: p.gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Center(
                child: Icon(Icons.broken_image_rounded, color: Colors.white54, size: 32),
              ),
            ),
          ),
        ),
        // Subtle dark gradient overlay at bottom of image for contrast
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Colors.black.withValues(alpha: 0.4),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        // Badge
        Positioned(
          top: 10,
          left: 10,
          child: ProductBadge(badge: p.badge),
        ),
      ],
    );
  }
}

// ──────────────── Info Area ────────────────
class _InfoArea extends StatelessWidget {
  final LuxuryProduct product;
  final bool addedToCart;
  final VoidCallback onAddToCart;
  final VoidCallback onFavoriteToggle;

  const _InfoArea({
    required this.product,
    required this.addedToCart,
    required this.onAddToCart,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final p = product;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Favorite + name row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  p.name,
                  style: const TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1.25,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: onFavoriteToggle,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: p.isFavorited
                        ? AppColors.rose.withValues(alpha: 0.9)
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: p.isFavorited
                          ? AppColors.rose
                          : AppColors.purple.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Icon(
                    p.isFavorited ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            p.originalName,
            style: const TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 11,
              color: AppColors.textSecondary,
              fontStyle: FontStyle.italic,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          // Rating & Reviews
          Row(
            children: [
              const Icon(Icons.star_rounded, size: 13, color: AppColors.gold),
              const SizedBox(width: 3),
              Text(
                '${p.rating}',
                style: const TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '(${p.reviewCount})',
                style: const TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Price + Cart button
          Row(
            children: [
              Expanded(
                child: Text(
                  p.formattedPrice,
                  style: const TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.gold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _AddToCartButton(
                addedToCart: addedToCart,
                onTap: onAddToCart,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ──────────────── Add to Cart Button ────────────────
class _AddToCartButton extends StatelessWidget {
  final bool addedToCart;
  final VoidCallback onTap;

  const _AddToCartButton({required this.addedToCart, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          gradient: addedToCart
              ? AppColors.goldGradient
              : AppColors.purpleGradient,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: (addedToCart ? AppColors.gold : AppColors.purple)
                  .withValues(alpha: 0.5),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          addedToCart ? Icons.check_rounded : Icons.add_rounded,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }
}
