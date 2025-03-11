import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/router/routes.dart';
import 'package:feedback_work/core/ui/widgets/app_button.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:feedback_work/models/group_model.dart';
import 'package:feedback_work/models/user_model.dart';
import 'package:feedback_work/providers/group_providers.dart';
import 'package:feedback_work/providers/user_providers.dart';
import 'package:feedback_work/screens/groups/widgets/create_group_content.dart';
import 'package:feedback_work/screens/groups/widgets/group_search_and_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class GroupsScreen extends ConsumerStatefulWidget {
  const GroupsScreen({super.key});

  @override
  ConsumerState<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends ConsumerState<GroupsScreen> {
  List<GroupModel> groups = [];
  List<GroupModel> filteredGroups = [];
  GroupType selectedGroupType = GroupType.all;
  String? selectedGroup;
  UserModel? currentUser;

  @override
  void initState() {
    Future.microtask(() {
      ref.read(userProvider.notifier).currentUser();
      ref.read(groupProvider.notifier).fetchAllGroups();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    final joinGroupState = ref.watch(joinGroupProvider);
    final groupState = ref.watch(groupProvider);
    ref.listen(groupProvider, (_, newState) {
      if (newState.state == AsyncState.success) {
        groups = newState.data ?? [];
      }
    });
    Log.info("currentUser!.id! =====>${currentUser!.id!}");
    Log.info(
        "Group users!.id! =====>${groups.map((g) => g.users!.map((u) => u.id))}");
    Log.info(
        "Groups =====>${groups.where((g) => g.ownerId == currentUser.id!).toList()}");
    filteredGroups = selectedGroupType == GroupType.all
        ? groups.where((g) => g.isPublic == true).toList()
        : selectedGroupType == GroupType.myGroups
            ? groups.where((g) => g.ownerId == currentUser.id!).toList()
            : groups.where((g) => g.ownerId == currentUser.id!).toList();
    return Scaffold(
      backgroundColor: context.colors.pureWhite,
      appBar: AppBar(
        title: const Text("Groups"),
        actions: [
          IconButton(
            style: ButtonStyle(
              backgroundColor:
                  WidgetStatePropertyAll(context.colors.primaryBlue),
              foregroundColor: WidgetStatePropertyAll(context.colors.pureWhite),
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                enableDrag: true,
                showDragHandle: true,
                backgroundColor: context.colors.background,
                builder: (context) {
                  return const CreateGroupContent();
                },
              );
            },
            icon: const Icon(Icons.add),
          ),
          16.pw,
        ],
      ),
      body: Builder(builder: (context) {
        if (groupState.state == AsyncState.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (groupState.state == AsyncState.failure) {
          return const Center(
            child: Text("Somethong went wrong"),
          );
        } else {
          return Column(
            children: [
              GroupSearchAndFilter(
                onChangedGroupType: (val) {
                  setState(() {
                    selectedGroupType = val;
                  });
                },
              ),
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const CircleAvatar(),
                        8.pw,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "${filteredGroups[index].name}(${filteredGroups[index].users?.length})"),
                              if (filteredGroups[index].description != null)
                                Text(
                                  filteredGroups[index].description!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        color: context.colors.darkGrey,
                                      ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                        ),
                        if (!filteredGroups[index]
                            .users!
                            .any((u) => u.id == currentUser.id))
                          AppButton.text(
                            isLoading:
                                filteredGroups[index].id == selectedGroup &&
                                    joinGroupState.state == AsyncState.loading,
                            onTap: () {
                              setState(() {
                                selectedGroup = filteredGroups[index].id;
                              });
                              ref.read(joinGroupProvider.notifier).joinGroup(
                                  groupId: filteredGroups[index].id!,
                                  userId: currentUser.id!);
                            },
                            label: "Join Group",
                          ),
                        if (selectedGroupType == GroupType.monitoringGroups)
                          AppButton.text(
                            onTap: () {
                              context.pushNamed(Routes.monitorGroup);
                            },
                            label: "Monitor Group",
                          ),
                      ],
                    ),
                  ),
                  itemCount: filteredGroups.length,
                  separatorBuilder: (_, __) => Divider(
                    color: context.colors.inputBorder,
                  ),
                ),
              )
            ],
          );
        }
      }),
    );
  }
}
