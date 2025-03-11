import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/router/routes.dart';
import 'package:feedback_work/core/ui/widgets/app_button.dart';
import 'package:feedback_work/models/user_model.dart';
import 'package:feedback_work/providers/auth_providers.dart';
import 'package:feedback_work/providers/user_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class MoreDrawer extends ConsumerStatefulWidget {
  const MoreDrawer({super.key});

  @override
  ConsumerState<MoreDrawer> createState() => _MoreTabScreenState();
}

class _MoreTabScreenState extends ConsumerState<MoreDrawer> {
  bool isLoggedIn = false;
  UserModel? currentUser;

  @override
  void initState() {
    Future.microtask(() {
      // ref.read(userProvider.notifier).currentUser();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isLoggedIn = ref.watch(authProvider);
    currentUser = ref.watch(currentUserProvider);
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 24.r,
                  ),
                  Text(
                    "${currentUser?.firstName ?? 'Hello!'} ${currentUser?.lastName ?? ''}",
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (!isLoggedIn) ...[
                    Text(
                      'Join for more access',
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    8.ph,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppButton.filled(
                          label: "Sign up",
                          onTap: () {
                            context.goNamed("sign-up");
                          },
                          horizontalPadding: 16.w,
                        ),
                        16.pw,
                        AppButton.outlined(
                          label: "Sign In",
                          onTap: () {
                            context.goNamed("sign-in");
                          },
                          borderColor: context.colors.primaryBlue,
                          horizontalPadding: 16.w,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 16.w,
              right: 16.w,
            ),
            child: Column(
              children: [
                Column(
                  children: [
                    if (!isLoggedIn) ...[
                      const DrawerItem(
                        sectionTitle: "Account Settings",
                        icon: Icons.settings_outlined,
                        itemName: "Settings",
                      ),
                      Divider(
                        color: context.colors.inputBorder,
                      ),
                    ],
                    if (isLoggedIn) ...[
                      DrawerItem(
                        sectionTitle: "Account Settings",
                        icon: Icons.person_outline_rounded,
                        itemName: "Profile",
                        onTap: () {
                          context.pushNamed(Routes.profile);
                          context.pop();
                        },
                      ),
                      Divider(
                        color: context.colors.inputBorder,
                      ),
                      DrawerItem(
                        icon: Icons.wallet,
                        itemName: "Wallet",
                        onTap: () {
                          context.pushNamed(Routes.wallet);
                        },
                      ),
                      Divider(
                        color: context.colors.inputBorder,
                      ),
                      const DrawerItem(
                        icon: Icons.groups_outlined,
                        itemName: "My Parents",
                      ),
                      Divider(
                        color: context.colors.inputBorder,
                      ),
                      DrawerItem(
                        icon: Icons.group_outlined,
                        itemName: "Groups",
                        onTap: () {
                          context.pushNamed(Routes.groups);
                          context.pop();
                        },
                      ),
                    ],
                    const DrawerItem(
                      sectionTitle: "Help",
                      icon: Icons.info_outline,
                      itemName: "About",
                    ),
                    Divider(
                      color: context.colors.inputBorder,
                    ),
                    const DrawerItem(
                      icon: Icons.help_outline,
                      itemName: "Help",
                    ),
                    Divider(
                      color: context.colors.inputBorder,
                    ),
                    const DrawerItem(
                      icon: Icons.phone_outlined,
                      itemName: "Contact Us",
                    ),
                    if (isLoggedIn) ...[
                      DrawerItem(
                        icon: Icons.logout,
                        itemName: "Logout",
                        onTap: () {
                          ref.read(authServiceProvider.notifier).logout();
                        },
                      ),
                    ],
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  const DrawerItem({
    super.key,
    this.sectionTitle,
    required this.icon,
    required this.itemName,
    this.onTap,
  });

  final String? sectionTitle;
  final IconData icon;
  final String itemName;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (sectionTitle != null) ...[
          Row(
            children: [
              Text(sectionTitle!,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: context.colors.darkGrey,
                        fontSize: 14,
                      )),
            ],
          ),
          16.ph,
        ],
        InkWell(
          onTap: onTap,
          child: Row(
            children: [
              Icon(icon),
              8.pw,
              Text(
                itemName,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 17,
                    ),
              ),
            ],
          ),
        ),
        16.ph,
      ],
    );
  }
}
