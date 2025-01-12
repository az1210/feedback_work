import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/extensions/string_extension.dart';
import 'package:feedback_work/screens/network/widgets/network_filter_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum GroupType {
  all,
  myGroups,
  monitoringGroups,
}

class GroupSearchAndFilter extends StatefulWidget {
  const GroupSearchAndFilter({
    super.key,
    this.onChangedSearchText,
    this.onChangedGroupType,
  });

  final void Function(String)? onChangedSearchText;
  final void Function(GroupType)? onChangedGroupType;

  @override
  State<GroupSearchAndFilter> createState() => _GroupSearchAndFilterState();
}

class _GroupSearchAndFilterState extends State<GroupSearchAndFilter> {
  List<GroupType> groupTypes = [
    GroupType.all,
    GroupType.myGroups,
    GroupType.monitoringGroups,
  ];

  GroupType selectedNetworkType = GroupType.all;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colors.pureWhite,
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    onChanged: widget.onChangedSearchText,
                    decoration: context.inputDecor.outlinedInputDecor(
                      prefix: Icon(
                        Icons.search,
                        color: context.colors.primaryBlue,
                      ),
                      hint: "Search",
                    ),
                  ),
                ),
                8.pw,
                InkWell(
                  onTap: () {
                    showNetworkFilters(context);
                  },
                  borderRadius: BorderRadius.circular(40.r),
                  child: Container(
                    height: 43.r,
                    width: 43.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: context.colors.inputBorder,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.sort_by_alpha,
                        color: context.colors.primaryBlue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            16.ph,
            SizedBox(
              height: 32.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    setState(() {
                      selectedNetworkType = groupTypes[index];
                      widget.onChangedGroupType!(groupTypes[index]);
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                    ),
                    decoration: BoxDecoration(
                      color: selectedNetworkType == groupTypes[index]
                          ? context.colors.primaryBlue.withValues(alpha: 0.1)
                          : context.colors.transparent,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: context.colors.inputBorder,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        groupTypes[index].name.toTitleCase(),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                              fontSize: 14,
                              fontWeight:
                                  selectedNetworkType == groupTypes[index]
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                              color: selectedNetworkType == groupTypes[index]
                                  ? context.colors.primaryBlue
                                  : context.colors.textBlack,
                            ),
                      ),
                    ),
                  ),
                ),
                separatorBuilder: (_, __) => 8.pw,
                itemCount: groupTypes.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
