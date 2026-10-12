import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:campus_kart/src/core/constants/app_colors.dart';
import 'package:campus_kart/src/core/utils/responsive.dart';

/// Root shell providing responsive navigation:
/// - Top Navigation Header on Desktop (width >= 900)
/// - Bottom Navigation Dock with dark navy circular Sell button on Mobile/Tablet (< 900)
class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: isDesktop
          ? _DesktopTopNavBar(navigationShell: navigationShell)
          : null,
      body: navigationShell,
      bottomNavigationBar: isDesktop
          ? null
          : _MobileBottomNavBar(navigationShell: navigationShell),
    );
  }
}

// ── Mobile / Tablet Bottom Nav Dock (Matching User's Mockup Exactly) ─────────

class _MobileBottomNavBar extends StatelessWidget {
  const _MobileBottomNavBar({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = navigationShell.currentIndex;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 68,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. Home
              _MobileNavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                selected: currentIndex == 0,
                onTap: () => _onTap(0),
              ),

              // 2. Chats
              _MobileNavItem(
                icon: Icons.chat_bubble_outline_rounded,
                selectedIcon: Icons.chat_bubble_rounded,
                label: 'Chats',
                selected: currentIndex == 1,
                onTap: () => _onTap(1),
              ),

              // 3. Center Elevated Dark Navy "Sell" (+) Button
              GestureDetector(
                onTap: () => context.push('/create-listing'),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.navy,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.navy.withValues(alpha: 0.35),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.add_rounded,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                      const SizedBox(height: 3),
                      const Text(
                        'Sell',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 4. My List
              _MobileNavItem(
                icon: Icons.bookmark_outline_rounded,
                selectedIcon: Icons.bookmark_rounded,
                label: 'My List',
                selected: currentIndex == 2,
                onTap: () => _onTap(2),
              ),

              // 5. Account
              _MobileNavItem(
                icon: Icons.person_outline_rounded,
                selectedIcon: Icons.person_rounded,
                label: 'Account',
                selected: currentIndex == 3,
                onTap: () => _onTap(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MobileNavItem extends StatelessWidget {
  const _MobileNavItem({
    required this.icon,
    this.selectedIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final IconData? selectedIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final activeColor = AppColors.primary;
    final inactiveColor = const Color(0xFF94A3B8);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              selected ? (selectedIcon ?? icon) : icon,
              color: selected ? activeColor : inactiveColor,
              size: 24,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: selected ? activeColor : inactiveColor,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Desktop Top Navigation Header ───────────────────────────────────────────

class _DesktopTopNavBar extends StatelessWidget implements PreferredSizeWidget {
  const _DesktopTopNavBar({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Size get preferredSize => const Size.fromHeight(68);

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = navigationShell.currentIndex;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: ResponsiveContainer(
          maxWidth: Responsive.maxContentWidth,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            height: 68,
            child: Row(
              children: [
                // ── Brand Logo & Title ─────────────────────────────────
                InkWell(
                  onTap: () => _onTap(0),
                  borderRadius: BorderRadius.circular(10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF3B82F6), AppColors.primary],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.shopping_bag_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'CampusKart',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // ── Desktop Navigation Links ───────────────────────────
                _DesktopNavLink(
                  label: 'Home',
                  icon: Icons.home_rounded,
                  selected: currentIndex == 0,
                  onTap: () => _onTap(0),
                ),
                const SizedBox(width: 4),
                _DesktopNavLink(
                  label: 'Chats',
                  icon: Icons.chat_bubble_outline_rounded,
                  selected: currentIndex == 1,
                  onTap: () => _onTap(1),
                ),
                const SizedBox(width: 4),
                _DesktopNavLink(
                  label: 'My List',
                  icon: Icons.bookmark_outline_rounded,
                  selected: currentIndex == 2,
                  onTap: () => _onTap(2),
                ),
                const SizedBox(width: 4),
                _DesktopNavLink(
                  label: 'Account',
                  icon: Icons.person_outline_rounded,
                  selected: currentIndex == 3,
                  onTap: () => _onTap(3),
                ),

                const SizedBox(width: 16),

                // ── Dark Navy Center Sell Button on Desktop ───────────
                FilledButton.icon(
                  onPressed: () => context.push('/create-listing'),
                  icon: const Icon(
                    Icons.add_rounded,
                    size: 18,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Sell',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.navy,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DesktopNavLink extends StatelessWidget {
  const _DesktopNavLink({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primarySurface : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: selected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
