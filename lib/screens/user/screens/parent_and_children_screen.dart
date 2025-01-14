import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/router/routes.dart';
import 'package:feedback_work/core/ui/widgets/dotted_border_big_button.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:feedback_work/models/child_model.dart';
import 'package:feedback_work/models/parent_model.dart';
import 'package:feedback_work/providers/child_providers.dart';
import 'package:feedback_work/providers/parent_providers.dart';
import 'package:feedback_work/screens/user/widgets/parent_child_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ParentAndChildrenScreen extends ConsumerStatefulWidget {
  const ParentAndChildrenScreen({super.key, required this.userId});

  final String userId;

  @override
  ConsumerState<ParentAndChildrenScreen> createState() =>
      _ParentAndChildrenScreenState();
}

class _ParentAndChildrenScreenState
    extends ConsumerState<ParentAndChildrenScreen> {
  Relationships selectedRelationType = Relationships.all;

  List<ChildModel> children = [];
  List<ParentModel> parents = [];
  @override
  void initState() {
    Future.microtask(() {
      ref.read(childProvider.notifier).fetchAllChilds(parentId: widget.userId);
      ref.read(parentProvider.notifier).fetchAllParents(childId: widget.userId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final childState = ref.watch(childProvider);
    ref.listen(childProvider, (_, newState) {
      if (newState.state == AsyncState.success) {
        children = newState.data ?? [];
      }
    });
    final parentState = ref.watch(parentProvider);
    ref.listen(parentProvider, (_, newState) {
      if (newState.state == AsyncState.success) {
        parents = newState.data ?? [];
      }
    });
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
            Builder(builder: (context) {
              if (parentState.state == AsyncState.loading ||
                  childState.state == AsyncState.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (parentState.state == AsyncState.failure &&
                  childState.state == AsyncState.failure) {
                return const Center(
                  child: Text("Semething went wrong"),
                );
              } else {
                return Column(
                  children: [
                    if (selectedRelationType == Relationships.parents ||
                        selectedRelationType == Relationships.all &&
                            parents.isNotEmpty) ...[
                      ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, index) =>
                            Text(parents[index].firstName!),
                        itemCount: parents.length,
                      )
                    ],
                    if (selectedRelationType == Relationships.children ||
                        selectedRelationType == Relationships.all &&
                            children.isNotEmpty) ...[
                      ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, index) =>
                            Text(children[index].firstName!),
                        itemCount: children.length,
                      )
                    ],
                  ],
                );
              }
            }),
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
                onTap: selectedRelationType == Relationships.children
                    ? () {
                        context.pushNamed(Routes.addChild,
                            extra: widget.userId);
                      }
                    : () {
                        context.pushNamed(Routes.addParent,
                            extra: widget.userId);
                      },
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
