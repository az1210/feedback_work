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
    this.selectedGroupId,
    this.selectedUsers,
    required this.category,
    super.key,
  });

  final String category;

  final void Function(List<UserModel>)? selectedUsers;
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
  List<UserModel> selectedUsers = [];
  Map<String, List<UserModel>> selectedGroupUsers = {};
  Map<String, Set<UserModel>> selectedIndividulaUsers = {};
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
        List<String> names = [];
        for (var i in newState.data!) {
          names.add("${i.firstName ?? ''} ${i.lastName ?? ''}");
        }
        Log.info(names.first.toString());
        sections.add(
          FilterSection<UserModel>(
            title: "provider",
            values: users,
            labels: names,
            allowMultipleSelection: true,
            showTitle: false,
          ),
        );
        selectedIndividulaUsers = {
          'provider': {users.first}
        };
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
                    selectedFilters: selectedIndividulaUsers,
                    onFiltersChanged: (filters) {
                      Log.info('Filters updated: $filters');
                      setState(() {
                        selectedGroupUsers = {};
                        selectedIndividulaUsers = filters;
                        widget.selectedGroupId != null
                            ? widget.selectedGroupId!(null)
                            : null;
                        widget.selectedUsers!(
                            filters['provider']?.toList() ?? []);
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
                        selectedIndividulaUsers = {'provider': {}};
                        selectedGroupUsers = {
                          ...selectedGroupUsers,
                          groupId: users,
                        };
                        widget.selectedGroupId!(groupId);
                        Log.info(users.length.toString());

                        widget.selectedGroupId!(groupId);
                      });
                    },
                    onGroupExpand: (groupId) {},
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
