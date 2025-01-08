import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/extensions/string_extension.dart';
import 'package:feedback_work/screens/feedback/widgets/feedback_filter_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum FeedbackScreenConnectionType {
  all,
  requested,
  received,
  applied,
  provided,
}

class FeedbackSearchAndFilter extends StatefulWidget {
  const FeedbackSearchAndFilter({
    super.key,
    this.onChangedSearchText,
    this.onChangedConnectionState,
  });

  final void Function(String)? onChangedSearchText;
  final void Function(FeedbackScreenConnectionType)? onChangedConnectionState;

  @override
  State<FeedbackSearchAndFilter> createState() =>
      _FeedbackSearchAndFilterState();
}

class _FeedbackSearchAndFilterState extends State<FeedbackSearchAndFilter> {
  List<FeedbackScreenConnectionType> networkTypes = [
    FeedbackScreenConnectionType.all,
    FeedbackScreenConnectionType.requested,
    FeedbackScreenConnectionType.received,
    FeedbackScreenConnectionType.applied,
    FeedbackScreenConnectionType.provided,
  ];

  FeedbackScreenConnectionType selectedNetworkType =
      FeedbackScreenConnectionType.all;

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
                    showFeedbackFilters(context);
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
                        Icons.filter_list,
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
                      selectedNetworkType = networkTypes[index];
                      widget.onChangedConnectionState!(networkTypes[index]);
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                    ),
                    decoration: BoxDecoration(
                      color: selectedNetworkType == networkTypes[index]
                          ? context.colors.primaryBlue.withValues(alpha: 0.1)
                          : context.colors.transparent,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: context.colors.inputBorder,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        networkTypes[index].name.toTitleCase(),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                              fontSize: 14,
                              fontWeight:
                                  selectedNetworkType == networkTypes[index]
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                              color: selectedNetworkType == networkTypes[index]
                                  ? context.colors.primaryBlue
                                  : context.colors.textBlack,
                            ),
                      ),
                    ),
                  ),
                ),
                separatorBuilder: (_, __) => 8.pw,
                itemCount: networkTypes.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
