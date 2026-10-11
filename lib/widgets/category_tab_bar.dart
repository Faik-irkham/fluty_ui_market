import 'package:flutter/material.dart';
import '../core/app_theme.dart';

/// Chip filter kategori horizontal scrollable.
class CategoryTabBar extends StatelessWidget {
  final List<String> categories;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const CategoryTabBar({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemCount: categories.length,
        itemBuilder: (_, i) => _CategoryChip(
          label: categories[i],
          isSelected: selectedIndex == i,
          onTap: () => onTap(i),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.purpleGradient : null,
          color: isSelected ? null : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : AppColors.purple.withValues(alpha: 0.2),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.purple.withValues(alpha: 0.4),
                    blurRadius: 12,
                  )
                ]
              : [],
        ),
        child: Text(
          label,
          style: AppTextStyles.labelBold.copyWith(
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
