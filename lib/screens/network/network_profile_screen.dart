import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/utils/network_image_helper.dart';
import 'package:feedback_work/models/user_model.dart';
import 'package:feedback_work/screens/network/widgets/stat_item_Card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NetworkProfileScreen extends StatelessWidget {
  final UserModel user;

  const NetworkProfileScreen({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.pureWhite,
      appBar: AppBar(
        title: Text("${user.firstName} ${user.lastName}"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Section
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: context.colors.inputBorder,
                    child: Image.network(
                      networkImage(user.avatarUrl),
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.person,
                        color: context.colors.darkGrey,
                        size: 40.r,
                      ),
                    ),
                  ),
                  16.ph,
                  Text(
                    "${user.firstName} ${user.lastName}",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    user.title != null && user.expertise != null
                        ? [user.title, user.expertise]
                            .where((e) => e != null)
                            .join(' • ')
                        : user.title != null
                            ? user.title!
                            : user.expertise != null
                                ? user.expertise!
                                : '',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(8.r),
                          child: Container(
                            height: 36.h,
                            padding: EdgeInsets.symmetric(vertical: 6.h),
                            decoration: BoxDecoration(
                              color: context.colors.primaryBlue,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Center(
                              child: Text(
                                "Connect",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      color: context.colors.pureWhite,
                                      fontSize: 14,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ),
                      8.pw,
                      Expanded(
                        child: InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(8.r),
                          child: Container(
                            height: 36.h,
                            padding: EdgeInsets.symmetric(vertical: 6.h),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: context.colors.primaryBlue,
                              ),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Center(
                              child: Text(
                                "Request Feedback",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      color: context.colors.primaryBlue,
                                      fontSize: 14,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Stats Grid
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.9,
              children: [
                StatItemCard(
                  value: "20",
                  label:
                      // stats.feedbackProvided.toString(),
                      'Total Feedback Provided',
                  valueColor: context.colors.primaryBlue,
                ),
                StatItemCard(
                  value: "20",
                  label:
                      // stats.feedbackApplied.toString(),
                      'Total Feedback Applied',
                  valueColor: context.colors.primaryBlue,
                ),
                StatItemCard(
                  value: "20",
                  label:
                      // stats.feedbackRequested.toString(),
                      'Total Feedback Requested',
                  valueColor: context.colors.primaryBlue,
                ),
                StatItemCard(
                  value: "20",
                  label:
                      // stats.problemsHelped.toString(),
                      'Total Problems Help Solved',
                  valueColor: context.colors.successGreen,
                ),
                StatItemCard(
                  value: "20",
                  label:
                      // stats.problemsSolved.toString(),
                      'Total Problems Solved',
                  valueColor: context.colors.successGreen,
                ),
                StatItemCard(
                  value: "20",
                  label:
                      // stats.projectsCompleted.toString(),
                      'Total Projects Completed',
                  valueColor: context.colors.successGreen,
                ),
              ],
            ),
            // Footer
            Padding(
              padding: EdgeInsets.all(16.r),
              child: Row(
                children: [
                  Icon(
                    Icons.lock,
                    size: 20.r,
                  ),
                  8.pw,
                  Text(
                    'Feedback with connection only',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 14,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
