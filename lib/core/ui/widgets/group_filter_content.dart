import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/ui/widgets/filter__content.dart';
import 'package:feedback_work/models/group_model.dart';
import 'package:feedback_work/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GroupFilterContent extends StatefulWidget {
  final List<GroupModel> groups;
  final Map<String, List<UserModel>> selectedUsers; // Added this
  final Function(String groupId, List<UserModel> selectedUsers)?
      onUserSelection;
  final Function(String)? onGroupExpand;
  final String? searchHint;

  const GroupFilterContent({
    super.key,
    required this.groups,
    required this.selectedUsers, // Added this
    this.onUserSelection,
    this.onGroupExpand,
    this.searchHint,
  });

  @override
  _GroupFilterContentState createState() => _GroupFilterContentState();
}

class _GroupFilterContentState extends State<GroupFilterContent> {
  late TextEditingController _searchController;
  String _searchQuery = '';
  Set<String> expandedGroups = {};
  Set<String> selectionModeGroups = {};

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  List<GroupModel> _getFilteredGroups() {
    if (_searchQuery.isEmpty) return widget.groups;

    return widget.groups.where((group) {
      bool groupMatches = group.name.toLowerCase().contains(_searchQuery) ||
          (group.description?.toLowerCase().contains(_searchQuery) ?? false);
      bool usersMatch = group.users?.any(
            (user) =>
                (user.firstName?.toLowerCase().contains(_searchQuery) ??
                    false) ||
                (user.lastName?.toLowerCase().contains(_searchQuery) ??
                    false) ||
                (user.username?.toLowerCase().contains(_searchQuery) ??
                    false) ||
                (user.title?.toLowerCase().contains(_searchQuery) ?? false) ||
                (user.expertise?.toLowerCase().contains(_searchQuery) ?? false),
          ) ??
          false;
      return groupMatches || usersMatch;
    }).toList();
  }

  void _toggleUserSelection(String groupId, UserModel user) {
    final currentSelectedUsers =
        List<UserModel>.from(widget.selectedUsers[groupId] ?? []);

    if (currentSelectedUsers.any((u) => u.id == user.id)) {
      currentSelectedUsers.removeWhere((u) => u.id == user.id);
    } else {
      currentSelectedUsers.add(user);
    }

    widget.onUserSelection?.call(groupId, currentSelectedUsers);
  }

  void _selectAllUsers(GroupModel group) {
    final groupId = group.id ?? group.name;
    if (group.users == null || group.users!.isEmpty) return;

    final currentSelectedUsers = widget.selectedUsers[groupId] ?? [];
    final allSelected = group.users!.every((user) =>
        currentSelectedUsers.any((selectedUser) => selectedUser.id == user.id));

    if (allSelected) {
      widget.onUserSelection?.call(groupId, []);
    } else {
      widget.onUserSelection?.call(groupId, group.users!);
    }
  }

  void _toggleGroupExpansion(String groupId, {bool selectionMode = false}) {
    setState(() {
      if (expandedGroups.contains(groupId)) {
        expandedGroups.remove(groupId);
        selectionModeGroups.remove(groupId);
      } else {
        expandedGroups.add(groupId);
        if (selectionMode) {
          selectionModeGroups.add(groupId);
        }
      }
      widget.onGroupExpand?.call(groupId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredGroups = _getFilteredGroups();

    return Column(
      children: [
        BuildSearchBar(
          searchController: _searchController,
          hintText: "Search Group",
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: filteredGroups.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final group = filteredGroups[index];
            final isExpanded = expandedGroups.contains(group.id);
            final isSelectionMode = selectionModeGroups.contains(group.id);

            return Column(
              children: [
                _buildGroupItem(group, isExpanded),
                if (isExpanded)
                  _buildUsersList(group, showDetails: !isSelectionMode),
              ],
            );
          },
        ),
        32.ph,
      ],
    );
  }

  Widget _buildGroupItem(GroupModel group, bool isExpanded) {
    return GestureDetector(
      onTap: () => _toggleGroupExpansion(group.id ?? group.name),
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.pureWhite,
          borderRadius: isExpanded
              ? BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r))
              : BorderRadius.circular(20.r),
          border: Border.all(color: context.colors.inputBorder),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.only(left: 16.w),
          leading: CircleAvatar(
            backgroundColor: context.colors.primaryBlue.withValues(alpha: 0.1),
            child: Text(
              group.name[0].toUpperCase(),
              style: TextStyle(color: context.colors.primaryBlue),
            ),
          ),
          title: Text(
            group.name,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: group.description != null
              ? Text(
                  group.description!,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              : null,
          trailing: TextButton(
            onPressed: () {
              final groupId = group.id ?? group.name;
              if (isExpanded) {
                _selectAllUsers(group);
              } else {
                _toggleGroupExpansion(groupId, selectionMode: true);
                _selectAllUsers(group);
              }
            },
            child: Text(
              'Select',
              style: TextStyle(color: context.colors.primaryBlue),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUsersList(GroupModel group, {bool showDetails = false}) {
    if (group.users == null || group.users!.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 8.h),
        child: Container(
          decoration: BoxDecoration(
            color: context.colors.pureWhite,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.r),
              bottomRight: Radius.circular(20.r),
            ),
          ),
          child: Text(
            'No users in this group',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      );
    }

    final groupId = group.id ?? group.name;
    final isSelectionMode = selectionModeGroups.contains(groupId);

    return ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: group.users!.length,
      itemBuilder: (context, index) {
        final user = group.users![index];
        final isSelected =
            widget.selectedUsers[groupId]?.any((u) => u.id == user.id) ?? false;

        return showDetails
            ? GestureDetector(
                onTap: () => _toggleUserSelection(groupId, user),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? context.colors.primaryBlue.withValues(alpha: 0.1)
                        : context.colors.pureWhite,
                    borderRadius: index == (group.users!.length - 1)
                        ? BorderRadius.only(
                            bottomLeft: Radius.circular(20.r),
                            bottomRight: Radius.circular(20.r))
                        : const BorderRadius.all(Radius.zero),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 80.w,
                        child: Column(
                          children: [
                            user.avaterUrl != null
                                ? CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(user.avaterUrl!),
                                    onBackgroundImageError: (_, __) => Text(
                                      (user.firstName?[0] ?? '').toUpperCase(),
                                    ),
                                  )
                                : CircleAvatar(
                                    backgroundColor: context.colors.primaryBlue
                                        .withValues(alpha: 0.1),
                                    child: Text(
                                      (user.firstName?[0] ?? '').toUpperCase(),
                                      style: TextStyle(
                                          color: context.colors.primaryBlue),
                                    ),
                                  ),
                            Text(
                              '${user.firstName ?? ''} ${user.lastName ?? ''}'
                                  .trim(),
                              style: Theme.of(context).textTheme.bodySmall,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      8.pw,
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Expetise:",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        fontSize: 14,
                                      ),
                                ),
                                Expanded(
                                    child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    user.expertise ?? 'N/A',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: context.colors.primaryBlue,
                                          fontSize: 14,
                                        ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )),
                              ],
                            ),
                            Container(
                              height: 1,
                              color: context.colors.inputBorder,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Total Feedback Provided:",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        fontSize: 14,
                                      ),
                                ),
                                Expanded(
                                    child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    '20',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: context.colors.primaryBlue,
                                          fontSize: 14,
                                        ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )),
                              ],
                            ),
                            Container(
                              height: 1,
                              color: context.colors.inputBorder,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Total Problems Help Solved:",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontSize: 14),
                                ),
                                Expanded(
                                    child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    '10',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: context.colors.successGreen,
                                          fontSize: 14,
                                        ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            : ListTile(
                tileColor: context.colors.pureWhite,
                selected: isSelected,
                selectedTileColor:
                    context.colors.primaryBlue.withValues(alpha: 0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: index == (group.users!.length - 1)
                      ? BorderRadius.only(
                          bottomLeft: Radius.circular(20.r),
                          bottomRight: Radius.circular(20.r))
                      : const BorderRadius.all(Radius.zero),
                ),
                leading: user.avaterUrl != null
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(user.avaterUrl!),
                        onBackgroundImageError: (_, __) => Text(
                          (user.firstName?[0] ?? '').toUpperCase(),
                        ),
                      )
                    : CircleAvatar(
                        backgroundColor:
                            context.colors.primaryBlue.withValues(alpha: 0.1),
                        child: Text(
                          (user.firstName?[0] ?? '').toUpperCase(),
                          style: TextStyle(color: context.colors.primaryBlue),
                        ),
                      ),
                title: Text(
                  '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim(),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                subtitle: showDetails &&
                        (user.title != null || user.expertise != null)
                    ? Text(
                        [
                          if (user.title != null) user.title,
                          if (user.expertise != null) user.expertise,
                        ].where((e) => e != null).join(' • '),
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    : null,
                trailing: isSelected
                    ? Icon(Icons.check, color: context.colors.primaryBlue)
                    : null,
                onTap: () => _toggleUserSelection(groupId, user),
              );
      },
      separatorBuilder: (context, index) => Container(
        height: 1,
        color: context.colors.inputBorder,
      ),
    );
  }
}
