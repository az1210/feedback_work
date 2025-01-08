import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:feedback_work/models/user_model.dart';
import 'package:feedback_work/providers/user_providers.dart';
import 'package:feedback_work/screens/network/widgets/connection_info_card.dart';
import 'package:feedback_work/screens/network/widgets/network_search_and_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class NetworkScreen extends ConsumerStatefulWidget {
  const NetworkScreen({super.key});

  @override
  ConsumerState<NetworkScreen> createState() => _NetworkScreenState();
}

class _NetworkScreenState extends ConsumerState<NetworkScreen> {
  bool isGrid = true;

  NetworkScreenConnectionType appearedAs =
      NetworkScreenConnectionType.myConnections;

  List<UserModel> users = [];

  @override
  void initState() {
    Future.microtask(() {
      ref.read(userProvider.notifier).fetchAllUsers();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);
    ref.listen(userProvider, (_, newState) {
      if (newState.state == AsyncState.success) {
        Log.info(newState.data!.length.toString());
        users = newState.data!;
        Log.info(users.length.toString());
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Network",
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isGrid = !isGrid;
              });
            },
            icon: isGrid
                ? const Icon(
                    Icons.list,
                  )
                : const Icon(
                    Icons.grid_view,
                  ),
          ),
          8.pw,
        ],
      ),
      body: Builder(builder: (context) {
        if (userState.state == AsyncState.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (userState.error != null) {
          return Center(
            child: Text("Error: ${userState.error}"),
          );
        } else {
          return Column(
            children: [
              NetworkSearchAndFilter(
                onChangedConnectionState: (p0) {
                  setState(() {
                    appearedAs = p0;
                  });
                },
              ),
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  children: [
                    Consumer(
                      builder: (context, ref, child) => Text(
                        "My Teacher Connection",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: MasonryGridView.builder(
                  itemCount: users.length,
                  gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isGrid ? 2 : 1),
                  itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.all(8.r),
                    child: ConnectionInfoCard(
                      name:
                          "${users[index].firstName ?? ''} ${users[index].lastName ?? ''}",
                      role: users[index].accountType ?? '',
                      specialty: users[index].expertise ?? '',
                      feedbackCount: 20,
                      problemsSolved: 10,
                      isConnected: true,
                      appearedAs: appearedAs,
                    ),
                  ),
                ),
              ),
            ],
          );
        }
      }),
    );
  }
}
