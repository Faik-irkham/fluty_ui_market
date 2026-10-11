import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../core/app_theme.dart';
import '../models/product_model.dart';
import '../widgets/product_card.dart';

/// Bottom sheet detail produk — galeri foto real, spesifikasi lengkap, quantity, & checkout berbahasa Indonesia.
class ProductDetailSheet extends StatefulWidget {
  final LuxuryProduct product;
  final VoidCallback onAddToCart;

  const ProductDetailSheet({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  @override
  State<ProductDetailSheet> createState() => _ProductDetailSheetState();
}

class _ProductDetailSheetState extends State<ProductDetailSheet> {
  int _quantity = 1;
  int _currentImageIndex = 0;

  double get _total => widget.product.price * _quantity;

  String _formatPrice(double price) {
    final str = price.toStringAsFixed(0);
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
      count++;
    }
    return 'Rp ${buffer.toString().split('').reversed.join()}';
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;

    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) => Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          border: Border.all(color: AppColors.purple.withValues(alpha: 0.3), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.6),
              blurRadius: 30,
              offset: const Offset(0, -10),
            ),
          ],
        ),
        child: Column(
          children: [
            // Drag handle
            Padding(
              padding: const EdgeInsets.only(top: 14, bottom: 6),
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.textMuted,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _GallerySection(
                      product: p,
                      currentIndex: _currentImageIndex,
                      onPageChanged: (i) => setState(() => _currentImageIndex = i),
                    ),
                    const SizedBox(height: 20),
                    _ProductHeader(product: p),
                    const SizedBox(height: 16),
                    _TaglineBox(tagline: p.tagline),
                    const SizedBox(height: 16),
                    Text(
                      p.description,
                      style: const TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 13.5,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _SpecsSection(),
                    const SizedBox(height: 24),
                    _QuantityRow(
                      quantity: _quantity,
                      onDecrement: _quantity > 1
                          ? () => setState(() => _quantity--)
                          : null,
                      onIncrement: () => setState(() => _quantity++),
                    ),
                    const SizedBox(height: 20),
                    _TotalBox(total: _total, formatPrice: _formatPrice),
                    const SizedBox(height: 24),
                    _CheckoutButton(
                      label: '🛒  Tambah ke Keranjang — ${_formatPrice(_total)}',
                      onTap: () {
                        for (int i = 0; i < _quantity; i++) {
                          widget.onAddToCart();
                        }
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                const Icon(Icons.check_circle_rounded, color: AppColors.gold),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Berhasil menambahkan $_quantity x ${p.name} ke Keranjang!',
                                    style: const TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ],
                            ),
                            backgroundColor: AppColors.surface,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────── Sub-widgets ───────────────────────

class _GallerySection extends StatelessWidget {
  final LuxuryProduct product;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;

  const _GallerySection({
    required this.product,
    required this.currentIndex,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final images = product.galleryImages.isNotEmpty ? product.galleryImages : [product.imageUrl];

    return SizedBox(
      height: 240,
      child: Stack(
        children: [
          PageView.builder(
            itemCount: images.length,
            onPageChanged: onPageChanged,
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.network(
                  images[index],
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
                      gradient: LinearGradient(colors: product.gradientColors),
                    ),
                    child: const Center(
                      child: Icon(Icons.broken_image_rounded, color: Colors.white54, size: 40),
                    ),
                  ),
                ),
              );
            },
          ),
          // Gradient shadow
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.3),
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
            top: 14,
            left: 14,
            child: ProductBadge(badge: product.badge),
          ),
          // Indicators
          if (images.length > 1)
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  images.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: currentIndex == i ? 20 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: currentIndex == i ? AppColors.gold : Colors.white.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ProductHeader extends StatelessWidget {
  final LuxuryProduct product;
  const _ProductHeader({required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                product.name,
                style: AppTextStyles.displayLg.copyWith(fontSize: 22, letterSpacing: 0.5),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.star_rounded, color: AppColors.gold, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${product.rating}',
                    style: const TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          product.originalName,
          style: const TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 14,
            color: AppColors.textSecondary,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '${product.reviewCount} ulasan dari pembeli terverifikasi',
          style: const TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 11,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}

class _TaglineBox extends StatelessWidget {
  final String tagline;
  const _TaglineBox({required this.tagline});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.purple.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          const Text('✨', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '"$tagline"',
              style: const TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 13.5,
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SpecsSection extends StatelessWidget {
  static const _specs = [
    ('Keaslian', '100% Original Bersertifikat'),
    ('Tingkat Kelangkaan', 'Edisi Museum'),
    ('Asal Produk', 'Kurasi Artisanal Eksklusif'),
    ('Garansi', 'Ketenangan Jiwa Seumur Hidup'),
    ('Kondisi', 'Sempurna Sesuai Alam'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Spesifikasi Mahakarya', style: AppTextStyles.titleSm),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.purple.withValues(alpha: 0.2)),
          ),
          child: Column(
            children: _specs
                .map(
                  (s) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Text(s.$1,
                            style: const TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            )),
                        const Spacer(),
                        Text(s.$2,
                            style: const TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            )),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _QuantityRow extends StatelessWidget {
  final int quantity;
  final VoidCallback? onDecrement;
  final VoidCallback onIncrement;

  const _QuantityRow({
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Jumlah Pembelian', style: AppTextStyles.titleSm),
        const Spacer(),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.purple.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: onDecrement,
                icon: Icon(
                  Icons.remove_rounded,
                  color: onDecrement != null ? AppColors.textPrimary : AppColors.textMuted,
                  size: 18,
                ),
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Text(
                  '$quantity',
                  style: const TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              IconButton(
                onPressed: onIncrement,
                icon: const Icon(Icons.add_rounded, color: AppColors.gold, size: 18),
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TotalBox extends StatelessWidget {
  final double total;
  final String Function(double) formatPrice;

  const _TotalBox({required this.total, required this.formatPrice});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.gold.withValues(alpha: 0.12),
            AppColors.purple.withValues(alpha: 0.12),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.4), width: 1.2),
      ),
      child: Row(
        children: [
          const Text('Total Investasi', style: AppTextStyles.titleSm),
          const Spacer(),
          ShaderMask(
            shaderCallback: (b) => AppColors.goldGradient.createShader(b),
            child: Text(
              formatPrice(total),
              style: const TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckoutButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _CheckoutButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: AppColors.goldGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.gold.withValues(alpha: 0.4),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 18),
            alignment: Alignment.center,
            child: Text(label, style: AppTextStyles.button.copyWith(fontSize: 16)),
          ),
        ),
      ),
    );
  }
}
