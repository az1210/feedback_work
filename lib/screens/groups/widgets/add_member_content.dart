import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/ui/widgets/filter__content.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:feedback_work/models/group_model.dart';
import 'package:feedback_work/models/user_model.dart';
import 'package:feedback_work/providers/group_providers.dart';
import 'package:feedback_work/providers/user_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AddMemberContent extends ConsumerStatefulWidget {
  const AddMemberContent({
    required this.groupName,
    required this.groupDescription,
    required this.isPublic,
    super.key,
  });

  final String groupName;
  final String groupDescription;
  final bool isPublic;

  @override
  ConsumerState<AddMemberContent> createState() =>
      _SelectFeedbackProviderState();
}

class _SelectFeedbackProviderState extends ConsumerState<AddMemberContent> {
  List<FilterSection<UserModel>> sections = [];
  List<UserModel> values = [];
  List<UserModel> selectedUser = [];
  UserModel? currentUser;

  @override
  void initState() {
    Future.microtask(() async {
      ref.read(userProvider.notifier).fetchAllUsers();

      currentUser = await ref.watch(userProvider.notifier).currentUser();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);
    ref.listen(userProvider, (_, newState) {
      if (newState.state == AsyncState.success) {
        List<String> names = [];
        for (var i in newState.data!) {
          names.add("${i.firstName ?? ''} ${i.lastName ?? ''}");
          values.add(i);
        }
        Log.info(currentUser?.toMap().toString() ?? "");
        sections.add(
          FilterSection<UserModel>(
            title: "users",
            values: values,
            labels: names,
            allowMultipleSelection: true,
            showTitle: false,
          ),
        );
      }
    });
    return Builder(builder: (context) {
      if (userState.state == AsyncState.loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (userState.error != null) {
        return Center(
          child: Text("Error: ${userState.error}"),
        );
      } else {
        return SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        context.pop();
                      },
                      child: Text(
                        "Back",
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: context.colors.primaryBlue,
                                  fontSize: 14,
                                ),
                      )),
                  Text(
                    "Add Member",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextButton(
                      onPressed: () {
                        ref.read(groupProvider.notifier).createGroup(
                              group: GroupModel(
                                ownerId: currentUser!.id,
                                name: widget.groupName,
                                description: widget.groupDescription,
                                isPublic: widget.isPublic,
                                users: selectedUser
                                    .map((u) => GroupUser(
                                          id: u.id,
                                          avaterUrl: u.avaterUrl,
                                          firstName: u.firstName,
                                          lastName: u.lastName,
                                        ))
                                    .toList(),
                              ),
                              callback: () {
                                context.pop();
                              },
                            );
                      },
                      child: Text(
                        "Create",
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: context.colors.primaryBlue,
                                  fontSize: 14,
                                ),
                      )),
                ],
              ),
              FilterContent<UserModel>(
                hasHeader: false,
                sections: sections,
                initialFilters: {
                  "users": {
                    values
                        .firstWhere((u) => u.username == currentUser!.username)
                  },
                },
                onFiltersChanged: (Map<String, Set<UserModel>> filters) {
                  Set<UserModel> users = {};
                  users.addAll(filters['users'] ?? {});
                  selectedUser = users.toList();
                  Log.info(
                      selectedUser.map((s) => s.username).toList().toString());
                },
                onApply: () {
                  Log.info('Filters applied');
                },
                onReset: () {
                  Log.info('Filters reset');
                },
                hasActionButton: false,
              ),
            ],
          ),
        );
      }
    });
  }
}
