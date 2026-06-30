import 'package:flutter/material.dart';
import 'nav_item.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          NavItem(
            icon: Icons.home_rounded,
            label: 'Home',
            selected: currentIndex == 0,
            onTap: () => onTabSelected(0),
          ),
          NavItem(
            icon: Icons.bar_chart_rounded,
            label: 'Analytics',
            selected: currentIndex == 1,
            onTap: () => onTabSelected(1),
          ),
          const SizedBox(width: 40), // FAB gap
          NavItem(
            icon: Icons.account_balance_wallet_rounded,
            label: 'Budget',
            selected: currentIndex == 2,
            onTap: () => onTabSelected(2),
          ),
          NavItem(
            icon: Icons.settings_rounded,
            label: 'Settings',
            selected: currentIndex == 3,
            onTap: () => onTabSelected(3),
          ),
        ],
      ),
    );
  }
}
