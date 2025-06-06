import 'package:feedback_work/core/constants/firebase_constants.dart';
import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/router/routes.dart';
import 'package:feedback_work/core/ui/widgets/filter__content.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:feedback_work/models/network_request_model.dart';
import 'package:feedback_work/models/user_model.dart';
import 'package:feedback_work/providers/network_providers.dart';
import 'package:feedback_work/providers/new_project_providers.dart';
import 'package:feedback_work/providers/user_providers.dart';
import 'package:feedback_work/screens/network/widgets/connection_info_card.dart';
import 'package:feedback_work/screens/network/widgets/network_search_and_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  List<UserModel>? myConnections;
  List<UserModel>? requests;
  List<UserModel> suggestions = [];

  final sections = [
    FilterSection(
      title: 'Connection Type',
      values: [
        'Teacher',
        'Student',
        'Manager',
        'Coworker',
        'Employee',
        'Friend',
        'Classmate',
        'My Customer',
        'My Client',
        'Other',
      ],
      labels: [
        'Teacher',
        'Student',
        'Manager',
        'Coworker',
        'Employee',
        'Friend',
        'Classmate',
        'My Customer',
        'My Client',
        'Other',
      ],
      allowMultipleSelection: false,
      showTitle: false,
    ),
  ];

  Map<String, Set<String>> selectedFilters = {'Connection Type': {}};

  Future<void> _refreshData() async {
    await ref.read(userProvider.notifier).fetchAllUsers();
    await ref.read(networkProvider.notifier).fetchAllOwnNetwork();
    await ref.read(networkProvider.notifier).fetchAllRequests();

    // Also fetch the user's projects for requesting feedback
    final auth = Supabase.instance.client.auth;
    if (auth.currentUser?.id != null) {
      await ref.read(projectProvider.notifier).fetchUserProjects(
            userId: auth.currentUser!.id,
          );
    }
  }

  void _onTabChanged(NetworkScreenConnectionType newType) {
    setState(() {
      appearedAs = newType;
    });

    // Refresh data when tab changes to ensure lists are up to date
    _refreshData();
  }

  @override
  void initState() {
    Future.microtask(() => _refreshData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    final userState = ref.watch(userProvider);
    final networkState = ref.watch(networkProvider);
    final projectState = ref.watch(projectProvider);

    ref.listen(userProvider, (_, newState) {
      if (newState.state == AsyncState.success) {
        users = newState.data ?? [];
      }
    });

    ref.listen(networkProvider, (_, newState) {
      if (newState.state == AsyncState.success) {
        myConnections = newState.data ?? [];
        requests = newState.requests ?? [];
        suggestions = users
            .where(
              (u) => !myConnections!.toSet().contains(u) && u != currentUser,
            )
            .toList();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Network"),
        actions: [
          IconButton(
            onPressed: () => setState(() => isGrid = !isGrid),
            icon: isGrid ? const Icon(Icons.list) : const Icon(Icons.grid_view),
          ),
          8.pw,
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              NetworkSearchAndFilter(
                onChangedConnectionState: (p0) => _onTabChanged(p0),
              ),
              if (userState.state == AsyncState.loading ||
                  networkState.state == AsyncState.loading) ...[
                SizedBox(
                  height: 100,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ],
              if (appearedAs == NetworkScreenConnectionType.myConnections &&
                  myConnections != null) ...[
                MasonryGridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: myConnections?.length ?? 0,
                  gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isGrid ? 2 : 1),
                  itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.all(8.r),
                    child: ConnectionInfoCard(
                      name:
                          "${myConnections![index].firstName ?? ''} ${myConnections![index].lastName ?? ''}",
                      role: myConnections![index].accountType ?? '',
                      specialty: myConnections![index].expertise ?? '',
                      feedbackCount:
                          myConnections![index].feedbackProvided ?? 0,
                      problemsSolved:
                          myConnections![index].problemHelpSolved ?? 0,
                      isConnected: true,
                      appearedAs: appearedAs,
                      onRequestFeedback: () {
                        if (projectState.currentUserProjects != null &&
                            projectState.currentUserProjects!.isNotEmpty) {
                          final project =
                              projectState.currentUserProjects!.first;
                          context.pushNamed(
                            Routes.requestFeedback,
                            extra: project,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please create a project first'),
                            ),
                          );
                        }
                      },
                      onConnect: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          showDragHandle: true,
                          backgroundColor: context.colors.background,
                          useRootNavigator: true,
                          useSafeArea: true,
                          builder: (context) => FilterContent(
                            title: 'Filters',
                            sections: sections,
                            selectedFilters: selectedFilters,
                            onFiltersChanged: (filters) {
                              setState(() {
                                selectedFilters = filters;
                              });
                            },
                          ),
                        );
                      },
                      onDisconnect: () {
                        ref.read(networkProvider.notifier).disconnect(
                              userId: currentUser!.id!,
                              connectionUserId: myConnections![index].id!,
                            );
                      },
                    ),
                  ),
                ),
              ],
              if (appearedAs == NetworkScreenConnectionType.suggestions) ...[
                MasonryGridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: suggestions.length,
                  gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isGrid ? 2 : 1),
                  itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.all(8.r),
                    child: ConnectionInfoCard(
                      name:
                          "${suggestions[index].firstName ?? ''} ${suggestions[index].lastName ?? ''}",
                      role: suggestions[index].accountType ?? '',
                      specialty: suggestions[index].expertise ?? '',
                      feedbackCount: suggestions[index].feedbackProvided ?? 0,
                      problemsSolved: suggestions[index].problemHelpSolved ?? 0,
                      isConnected: false,
                      appearedAs: appearedAs,
                      onConnect: () {
                        ref.read(networkProvider.notifier).requestNetwork(
                              networkRequestModel: NetworkRequestModel(
                                requestedFrom: currentUser!.id,
                                requestedTo: suggestions[index].id,
                              ),
                            );
                      },
                    ),
                  ),
                ),
              ],
              if (appearedAs == NetworkScreenConnectionType.requests &&
                  requests != null) ...[
                MasonryGridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: requests?.length ?? 0,
                  gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isGrid ? 2 : 1),
                  itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.all(8.r),
                    child: ConnectionInfoCard(
                      name:
                          "${requests![index].firstName ?? ''} ${requests![index].lastName ?? ''}",
                      role: requests![index].accountType ?? '',
                      specialty: requests![index].expertise ?? '',
                      feedbackCount: requests![index].feedbackProvided ?? 0,
                      problemsSolved: requests![index].problemHelpSolved ?? 0,
                      isConnected: false,
                      appearedAs: appearedAs,
                      onRequestFeedback: () {
                        ref.read(networkProvider.notifier).requestAccept(
                              currentUserId: currentUser!.id!,
                              connectionId: requests![index].id!,
                            );
                      },
                      onDisconnect: () {
                        ref.read(networkProvider.notifier).requestDecline(
                              currentUserId: currentUser!.id!,
                              connectionId: requests![index].id!,
                            );
                      },
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
