import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Generic product mark (NOT a brand logo). A red gradient tile with stacked
/// bars suggesting an API stack/gateway. Pairs with the wordmark in the nav.
class PortalMark extends StatelessWidget {
  const PortalMark({super.key, this.size = 28});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.accentSoft, AppColors.accentDim],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.45),
            blurRadius: size * 0.5,
            offset: Offset(0, size * 0.12),
          ),
        ],
      ),
      child: Center(
        child: SizedBox(
          width: size * 0.5,
          height: size * 0.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              3,
              (i) => Container(
                height: size * 0.09,
                width: size * (0.5 - i * 0.12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.95 - i * 0.18),
                  borderRadius: BorderRadius.circular(size),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
