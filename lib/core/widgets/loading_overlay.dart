import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:word_game/core/theme/app_colors.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.lightBlueBg.withValues(alpha: 0.9),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Shimmer.fromColors(
              baseColor: AppColors.primaryBlue,
              highlightColor: AppColors.oceanBlue,
              child: const Icon(Icons.grid_on, size: 64, color: Colors.white),
            ),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(message!, style: Theme.of(context).textTheme.bodyLarge),
            ],
          ],
        ),
      ),
    );
  }
}
