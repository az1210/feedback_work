import 'package:feedback_work/core/ui/widgets/filter__content.dart';
import 'package:feedback_work/core/ui/widgets/group_filter_content.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:feedback_work/models/group_model.dart';
import 'package:feedback_work/models/user_model.dart';
import 'package:feedback_work/providers/group_providers.dart';
import 'package:feedback_work/providers/user_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectFeedbackProvider extends ConsumerStatefulWidget {
  const SelectFeedbackProvider({
    this.selectedGroupUsers,
    required this.currentUserId,
    this.selectedGroupId,
    required this.selectedIndividualUser,
    required this.category,
    super.key,
  });

  final String category;
  final String currentUserId;

  final void Function(UserModel?) selectedIndividualUser;
  final void Function(List<String?>)? selectedGroupUsers;
  final void Function(String?)? selectedGroupId;

  @override
  ConsumerState<SelectFeedbackProvider> createState() =>
      _SelectFeedbackProviderState();
}

class _SelectFeedbackProviderState
    extends ConsumerState<SelectFeedbackProvider> {
  List<FilterSection<UserModel>> sections = [];
  List<GroupModel> groups = [];
  List<GroupModel> filteredGroups = [];

  List<UserModel> users = [];
  List<UserModel> filteredUsers = [];
  Map<String, List<UserModel>> selectedGroupUsers = {};
  Map<String, Set<UserModel>> selectedIndividulaUser = {};
  String? groupId;

  @override
  void initState() {
    Future.microtask(() {
      ref
          .read(userProvider.notifier)
          .fetchUsersByExpertise(expertise: widget.category);

      ref.read(groupProvider.notifier).fetchAllGroups();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);
    ref.listen(userProvider, (_, newState) {
      if (newState.state == AsyncState.success) {
        users = newState.data!;
        filteredUsers =
            users.where((u) => u.id != widget.currentUserId).toList();
        List<String> names = [];
        List<String> ids = [];
        for (var i in filteredUsers) {
          names.add("${i.firstName ?? ''} ${i.lastName ?? ''}");
          ids.add(i.id ?? '');
        }
        Log.info(names.first.toString());
        sections.add(
          FilterSection<UserModel>(
            title: "provider",
            values: filteredUsers,
            labels: names,
            allowMultipleSelection: false,
            showTitle: false,
          ),
        );
        // selectedIndividulaUsers = {
        //   'provider': {users.first}
        // };
      }
    });

    final groupState = ref.watch(groupProvider);
    ref.listen(groupProvider, (_, newState) {
      if (newState.state == AsyncState.success) {
        groups = newState.data ?? [];
      }
    });
    return Builder(
      builder: (context) {
        if (userState.state == AsyncState.loading ||
            groupState.state == AsyncState.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (userState.error != null && groupState.error != null) {
          return Center(
            child: Text("Error: ${userState.error}"),
          );
        } else {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  FilterContent<UserModel>(
                    hasHeader: false,
                    sections: sections,
                    selectedFilters: selectedIndividulaUser,
                    onFiltersChanged: (filters) {
                      Log.info('Filters updated: $filters');
                      setState(() {
                        selectedGroupUsers = {};
                        selectedIndividulaUser = filters;
                        widget.selectedGroupId != null
                            ? widget.selectedGroupId!(null)
                            : null;
                        widget
                            .selectedIndividualUser(filters['provider']?.first);
                      });
                    },
                    onApply: () {
                      Log.info('Filters applied');
                    },
                    onReset: () {
                      Log.info('Filters reset');
                    },
                    hasActionButton: false,
                  ),
                  if (groups != []) ...[
                    GroupFilterContent(
                      groups: groups
                          .map(
                            (g) => GroupModel(
                              id: g.id,
                              name: g.name,
                              description: g.description,
                              users: g.users
                                  ?.map(
                                    (u) => UserModel(
                                      id: u.id,
                                      firstName: u.firstName,
                                      lastName: u.lastName,
                                      avaterUrl: u.avaterUrl,
                                      title: u.title,
                                      expertise: u.expertise,
                                      username: u.username,
                                    ),
                                  )
                                  .toList(),
                            ),
                          )
                          .toList(),
                      selectedUsers: selectedGroupUsers,
                      onUserSelection: (groupId, users) {
                        setState(() {
                          widget.selectedIndividualUser(users.firstWhere((u) {
                            final owner = groups
                                .firstWhere((g) => g.id == groupId)
                                .ownerId;
                            return u.id == owner;
                          }));
                          selectedIndividulaUser = {};
                          selectedGroupUsers = {
                            ...selectedGroupUsers,
                            groupId: users,
                          };
                          widget.selectedGroupId!(groupId);
                          widget.selectedGroupUsers!(
                              users.map((u) => u.id).toList());
                          Log.info(users.map((u) => u.toMap()).toString());
                        });
                      },
                      onGroupExpand: (groupId) {},
                    ),
                  ],
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
