import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/auth_providers.dart';

class MoreTabScreen extends ConsumerStatefulWidget {
  const MoreTabScreen({super.key});

  @override
  ConsumerState<MoreTabScreen> createState() => _MoreTabScreenState();
}

class _MoreTabScreenState extends ConsumerState<MoreTabScreen> {
  final int _currentIndex = 4;

  final List<String> _routes = [
    '/projects',
    '/feedback',
    '/network',
    '/status',
    '/more',
  ];

  @override
  Widget build(BuildContext context) {
    final authService = ref.watch(authServiceProvider);

    return Scaffold(
      body: Center(
        child: TextButton(
            onPressed: () async {
              try {
                await authService.logout();
                context.replace('/sign-in');
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Logout failed: $e')),
                );
              }
            },
            child: Text(
              "Log out",
              style: Theme.of(context).textTheme.titleLarge,
            )),
      ),
    );
  }
}
