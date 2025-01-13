import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/extensions/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum Relationships {
  all,
  parents,
  children,
}

class ParentChildFilter extends StatefulWidget {
  const ParentChildFilter({super.key, this.onChangedRelation});

  final void Function(Relationships)? onChangedRelation;

  @override
  _ParentChildFilterState createState() => _ParentChildFilterState();
}

class _ParentChildFilterState extends State<ParentChildFilter> {
  Relationships selectedRelationType = Relationships.all;
  List<Relationships> relations = [
    Relationships.all,
    Relationships.parents,
    Relationships.children,
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) => InkWell(
          onTap: () {
            setState(() {
              selectedRelationType = relations[index];
              widget.onChangedRelation != null
                  ? widget.onChangedRelation!(relations[index])
                  : null;
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 8.w,
            ),
            decoration: BoxDecoration(
              color: selectedRelationType == relations[index]
                  ? context.colors.primaryBlue.withValues(alpha: 0.1)
                  : context.colors.transparent,
              borderRadius: BorderRadius.circular(4.r),
              border: Border.all(
                color: context.colors.inputBorder,
              ),
            ),
            child: Center(
              child: Text(
                relations[index].name.toTitleCase(),
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontSize: 14,
                      fontWeight: selectedRelationType == relations[index]
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: selectedRelationType == relations[index]
                          ? context.colors.primaryBlue
                          : context.colors.textBlack,
                    ),
              ),
            ),
          ),
        ),
        separatorBuilder: (_, __) => 8.pw,
        itemCount: relations.length,
      ),
    );
  }
}
