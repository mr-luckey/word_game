import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

/// World Tour bottom nav using [PersistentBottomNavBarItem] from the package.
class WorldTourPersistentNav extends StatelessWidget {
  const WorldTourPersistentNav({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static const _activeBlue = Color(0xFF2B6CB0);
  static const _inactiveGrey = Color(0xFF9E9E9E);

  static List<PersistentBottomNavBarItem> get items => [
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.home_rounded, color: _activeBlue),
          inactiveIcon: const Icon(Icons.home_outlined, color: _inactiveGrey),
          title: 'Home',
          activeColorPrimary: _activeBlue,
          inactiveColorPrimary: _inactiveGrey,
          textStyle: GoogleFonts.montserrat(
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.explore_rounded, color: _activeBlue),
          inactiveIcon: const Icon(Icons.explore_outlined, color: _inactiveGrey),
          title: 'Journeys',
          activeColorPrimary: _activeBlue,
          inactiveColorPrimary: _inactiveGrey,
          textStyle: GoogleFonts.montserrat(
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.emoji_events_rounded, color: _activeBlue),
          inactiveIcon:
              const Icon(Icons.emoji_events_outlined, color: _inactiveGrey),
          title: 'Achievements',
          activeColorPrimary: _activeBlue,
          inactiveColorPrimary: _inactiveGrey,
          textStyle: GoogleFonts.montserrat(
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.person_rounded, color: _activeBlue),
          inactiveIcon: const Icon(Icons.person_outline_rounded, color: _inactiveGrey),
          title: 'Profile',
          activeColorPrimary: _activeBlue,
          inactiveColorPrimary: _inactiveGrey,
          textStyle: GoogleFonts.montserrat(
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final navItems = items;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
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
        child: SizedBox(
          height: 64,
          child: Row(
            children: List.generate(navItems.length, (index) {
              final item = navItems[index];
              final selected = index == selectedIndex;
              return Expanded(
                child: InkWell(
                  onTap: () => onSelected(index),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconTheme(
                        data: IconThemeData(
                          size: 24,
                          color: selected
                              ? item.activeColorPrimary
                              : item.inactiveColorPrimary,
                        ),
                        child: selected
                            ? item.icon
                            : item.inactiveIcon ?? item.icon,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.title ?? '',
                        style: item.textStyle?.copyWith(
                              color: selected
                                  ? item.activeColorPrimary
                                  : item.inactiveColorPrimary,
                              fontWeight: selected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ) ??
                            TextStyle(
                              fontSize: 11,
                              color: selected
                                  ? item.activeColorPrimary
                                  : item.inactiveColorPrimary,
                            ),
                      ),
                      const SizedBox(height: 4),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: selected ? 28 : 0,
                        height: 3,
                        decoration: BoxDecoration(
                          color: selected
                              ? const Color(0xFFFFC107)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(2),
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
    );
  }
}
