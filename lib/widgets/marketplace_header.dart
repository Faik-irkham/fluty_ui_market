import 'package:flutter/material.dart';
import '../core/app_theme.dart';

/// Header animasi dengan judul FLUTY MARKET bergradien gold–purple.
class MarketplaceHeader extends StatelessWidget {
  final Animation<double> shimmerAnimation;
  final VoidCallback onNotificationTap;

  const MarketplaceHeader({
    super.key,
    required this.shimmerAnimation,
    required this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedBuilder(
                animation: shimmerAnimation,
                builder: (_, _) => ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [
                      AppColors.gold,
                      Color.lerp(AppColors.gold, AppColors.purple,
                          shimmerAnimation.value)!,
                      AppColors.goldLight,
                    ],
                  ).createShader(bounds),
                  child: const Text(
                    'FLUTY MARKET',
                    style: AppTextStyles.displayLg,
                  ),
                ),
              ),
              const Text(
                'Pasar Barang Unik & Berkelas ✨',
                style: AppTextStyles.subtitle,
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              _IconButton(
                icon: Icons.notifications_outlined,
                onTap: onNotificationTap,
              ),
              const SizedBox(width: 8),
              _AvatarButton(),
            ],
          ),
        ],
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border:
              Border.all(color: AppColors.purple.withValues(alpha: 0.3)),
        ),
        child: Icon(icon, color: AppColors.textSecondary, size: 20),
      ),
    );
  }
}

class _AvatarButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        gradient: AppColors.purpleGradient,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Text(
          'F',
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
