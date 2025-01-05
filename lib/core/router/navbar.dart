import 'package:feedback_work/core/ui/assets/app_assets.dart';
import 'package:feedback_work/core/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithNestedNavigation extends StatelessWidget {
  const ScaffoldWithNestedNavigation({
    required this.navigationShell,
    required this.context,
    Key? key,
  }) : super(key: key ?? const ValueKey('ScaffoldWithNestedNavigation'));
  final StatefulNavigationShell navigationShell;
  final BuildContext context;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _goBranch,
        showUnselectedLabels: true,
        selectedIconTheme: const IconThemeData(size: 30),
        unselectedIconTheme: const IconThemeData(size: 23),
        selectedLabelStyle:
            const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
        unselectedLabelStyle:
            const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
        currentIndex: navigationShell.currentIndex,
        selectedItemColor: AppTheme.secondaryColor,
        unselectedItemColor: const Color.fromARGB(255, 101, 103, 107),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage(AppAssets.images.tabIcon2),
            ),
            label: 'Projects',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage(
                AppAssets.images.feedbackTab,
              ),
            ),
            label: 'Feedback',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage(
                AppAssets.images.networkTab,
              ),
            ),
            label: 'Network',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage(
                AppAssets.images.statusTab,
              ),
            ),
            label: 'Status',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage(
                AppAssets.images.moreTab,
              ),
            ),
            label: 'More',
          ),
        ],
      ),
    );
  }
}
