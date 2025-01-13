import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/ui/widgets/dotted_border_big_button.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:feedback_work/screens/user/widgets/parent_child_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ParentAndChildrenScreen extends StatefulWidget {
  const ParentAndChildrenScreen({super.key});

  @override
  State<ParentAndChildrenScreen> createState() =>
      _ParentAndChildrenScreenState();
}

class _ParentAndChildrenScreenState extends State<ParentAndChildrenScreen> {
  Relationships selectedRelationType = Relationships.all;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.pureWhite,
      appBar: AppBar(
        title: const Text("My Children"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ParentChildFilter(
              onChangedRelation: (r) {
                setState(() {
                  selectedRelationType = r;
                });
                Log.info(selectedRelationType.toString());
              },
            ),
            16.ph,
            if (selectedRelationType == Relationships.children ||
                selectedRelationType == Relationships.parents) ...[
              DottedBorderBigButton(
                title: selectedRelationType == Relationships.parents
                    ? "Add Parent"
                    : "Add Children",
                titleStyle: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: context.colors.primaryBlue),
                onTap: () {},
                icon: Icon(
                  Icons.add_circle,
                  size: 32.r,
                  color: context.colors.primaryBlue,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
