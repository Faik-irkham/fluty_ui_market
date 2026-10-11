import 'package:flutter/material.dart';
import '../core/app_theme.dart';

/// Search bar dengan efek glass dan clear button.
class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const SearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.purple.withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.purple.withValues(alpha: 0.08),
              blurRadius: 20,
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          style: AppTextStyles.input,
          decoration: InputDecoration(
            hintText: 'Cari produk unik & eksklusif...',
            hintStyle: AppTextStyles.hint,
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: AppColors.textMuted,
              size: 20,
            ),
            suffixIcon: controller.text.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      controller.clear();
                      onChanged('');
                    },
                    child: const Icon(
                      Icons.close_rounded,
                      color: AppColors.textMuted,
                      size: 18,
                    ),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }
}
