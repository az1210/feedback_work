import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/ui/assets/app_assets.dart';
import 'package:feedback_work/core/ui/theme.dart';
import 'package:feedback_work/screens/more/more_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    if (index == 4) {
      Scaffold.of(context).openDrawer();
      return;
    }
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const MoreDrawer(),
      body: navigationShell,
      bottomNavigationBar: Builder(builder: (context) {
        return BottomNavigationBar(
          onTap: (int index) {
            if (index == 4) {
              Scaffold.of(context).openEndDrawer();
            } else {
              navigationShell.goBranch(
                index,
                initialLocation: index == navigationShell.currentIndex,
              );
            }
          },
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
              icon: SvgPicture.asset(
                AppAssets.svgs.projectIcon,
              ),
              activeIcon: SvgPicture.asset(
                AppAssets.svgs.projectActiveIcon,
              ),
              label: 'Projects',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                AppAssets.svgs.feedbackIcon,
              ),
              activeIcon: SvgPicture.asset(
                AppAssets.svgs.feedbackActiveIcon,
              ),
              label: 'Feedback',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                AppAssets.svgs.networkIcon,
              ),
              activeIcon: SvgPicture.asset(
                AppAssets.svgs.networkIcon,
                colorFilter: ColorFilter.mode(
                  context.colors.primaryBlue,
                  BlendMode.srcIn,
                ),
              ),
              label: 'Network',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                AppAssets.svgs.statusIcon,
              ),
              activeIcon: SvgPicture.asset(
                AppAssets.svgs.statusIcon,
                colorFilter: ColorFilter.mode(
                  context.colors.primaryBlue,
                  BlendMode.srcIn,
                ),
              ),
              label: 'Status',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                AppAssets.svgs.moreIcon,
              ),
              activeIcon: SvgPicture.asset(
                AppAssets.svgs.moreIcon,
                colorFilter: ColorFilter.mode(
                  context.colors.primaryBlue,
                  BlendMode.srcIn,
                ),
              ),
              label: 'More',
            ),
          ],
        );
      }),
    );
  }
}
