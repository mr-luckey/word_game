import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:word_game/core/theme/app_colors.dart';
import 'package:word_game/core/theme/app_text_styles.dart';

class JourneyBottomNav extends StatelessWidget {
  const JourneyBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static const _items = [
    (Icons.home_rounded, 'Home'),
    (Icons.explore_rounded, 'Explore'),
    (Icons.store_rounded, 'Shop'),
    (Icons.person_rounded, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.92),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(_items.length, (i) {
                  final selected = i == selectedIndex;
                  final (icon, label) = _items[i];
                  return Expanded(
                    child: InkWell(
                      onTap: () => onSelected(i),
                      borderRadius: BorderRadius.circular(12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedContainer(
                            duration: 200.ms,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: selected
                                  ? AppColors.playButtonGradient
                                  : null,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: selected
                                  ? [
                                      BoxShadow(
                                        color: AppColors.gold
                                            .withValues(alpha: 0.4),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Icon(
                              icon,
                              color: selected ? Colors.white : AppColors.lockedGray,
                              size: 26,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            label,
                            style: AppTextStyles.wordList.copyWith(
                              fontSize: 11,
                              fontWeight:
                                  selected ? FontWeight.w600 : FontWeight.w400,
                              color: selected
                                  ? AppColors.goldDark
                                  : AppColors.lockedGray,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
