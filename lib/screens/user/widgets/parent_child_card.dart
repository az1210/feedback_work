import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/utils/network_image_helper.dart';
import 'package:feedback_work/models/child_model.dart';
import 'package:feedback_work/models/parent_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ParentChildCard extends StatelessWidget {
  const ParentChildCard({super.key, this.parent, this.child});
  final ParentModel? parent;
  final ChildModel? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: context.colors.inputBorder,
        ),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (parent != null) ...[
            CircleAvatar(
              radius: 32.r,
              child: Image.network(
                networkImage(parent!.avaterUrl),
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.person),
              ),
            ),
            8.ph,
            Text(
              "${parent!.firstName ?? ''} ${parent!.lastName ?? ''}",
              style: Theme.of(context).textTheme.titleMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              parent!.relationship ?? '',
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          if (child != null) ...[
            CircleAvatar(
              radius: 32.r,
              child: Image.network(
                networkImage(child!.avaterUrl),
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.person),
              ),
            ),
            8.ph,
            Text(
              "${child!.firstName} ${child!.lastName}",
              style: Theme.of(context).textTheme.titleMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'Children',
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}
