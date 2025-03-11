import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/router/routes.dart';
import 'package:feedback_work/core/ui/widgets/stat_item_card.dart';
import 'package:feedback_work/core/utils/network_image_helper.dart';
import 'package:feedback_work/models/user_model.dart';
import 'package:feedback_work/screens/network/widgets/network_search_and_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ConnectionInfoCard extends StatefulWidget {
  final String name;
  final String role;
  final String? specialty;
  final String? imageUrl;
  final int feedbackCount;
  final int problemsSolved;
  final VoidCallback? onRequestFeedback;
  final VoidCallback? onConnect;
  final VoidCallback? onDisconnect;
  final bool isConnected;
  final NetworkScreenConnectionType appearedAs;

  const ConnectionInfoCard({
    super.key,
    required this.name,
    required this.role,
    this.specialty,
    this.imageUrl,
    required this.feedbackCount,
    required this.problemsSolved,
    this.onRequestFeedback,
    this.onConnect,
    this.onDisconnect,
    this.isConnected = false,
    required this.appearedAs,
  });

  @override
  State<ConnectionInfoCard> createState() => _ConnectionInfoCardState();
}

class _ConnectionInfoCardState extends State<ConnectionInfoCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: context.colors.pureWhite,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildProfileImage(
            context: context,
            name: widget.name,
            title: widget.role,
            specialty: widget.specialty,
          ),
          12.ph,
          _buildNameAndRole(context: context),
          8.ph,
          _buildStats(context: context),
          8.ph,
          _buildButtons(context: context),
        ],
      ),
    );
  }

  Widget _buildProfileImage({
    required BuildContext context,
    required String name,
    required String title,
    String? specialty,
  }) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(Routes.networkProfile,
            extra: UserModel(
              firstName: name.split(" ").first,
              lastName: name.split(" ").last,
              expertise: specialty ?? '',
              title: title,
            ));
      },
      child: Container(
        width: 80.r,
        height: 80.r,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: context.colors.inputBorder,
        ),
        child: Image.network(
          networkImage(widget.imageUrl),
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.person,
          ),
        ),
      ),
    );
  }

  Widget _buildNameAndRole({required BuildContext context}) {
    return Column(
      children: [
        Text(
          widget.name,
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          widget.role != '' && widget.specialty != ''
              ? [widget.role, widget.specialty]
                  .where((e) => e != null)
                  .join(' • ')
              : widget.role != ''
                  ? widget.role
                  : widget.specialty != ''
                      ? widget.specialty!
                      : '',
          style: Theme.of(context).textTheme.bodyMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildStats({required BuildContext context}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StateItemCard(
            context: context,
            value: widget.feedbackCount.toString(),
            label: 'Total Feedback Provided',
            color: context.colors.primaryBlue),
        8.pw,
        StateItemCard(
            context: context,
            value: widget.problemsSolved.toString(),
            label: 'Total Problems Help Solved',
            color: context.colors.successGreen),
      ],
    );
  }

  Widget _buildButtons({required BuildContext context}) {
    String connectButton = 'Connect';
    return Column(
      children: [
        if (widget.appearedAs == NetworkScreenConnectionType.myConnections) ...[
          InkWell(
            onTap: widget.onRequestFeedback,
            borderRadius: BorderRadius.circular(8.r),
            child: Container(
              height: 36.h,
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 6.h),
              decoration: BoxDecoration(
                color: context.colors.primaryBlue,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Center(
                child: Text(
                  "Request Feedback",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: context.colors.pureWhite,
                        fontSize: 14,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          8.ph,
          InkWell(
            onTap: widget.onConnect,
            borderRadius: BorderRadius.circular(8.r),
            child: Container(
              height: 36.h,
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 6.h),
              decoration: BoxDecoration(
                color: context.colors.primaryBlue.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Connect As",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: context.colors.primaryBlue,
                          fontSize: 14,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: context.colors.primaryBlue,
                  ),
                ],
              ),
            ),
          ),
          8.ph,
          InkWell(
            onTap: widget.onDisconnect,
            borderRadius: BorderRadius.circular(8.r),
            child: Container(
              height: 36.h,
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 6.h),
              decoration: BoxDecoration(
                border: Border.all(
                  color: context.colors.textBlack,
                ),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Center(
                child: Text(
                  "Disconnect",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 14,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ],
        if (widget.appearedAs == NetworkScreenConnectionType.suggestions) ...[
          InkWell(
            onTap: () {
              widget.onConnect?.call();
            },
            borderRadius: BorderRadius.circular(8.r),
            child: Container(
              height: 36.h,
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 6.h),
              decoration: BoxDecoration(
                color: context.colors.primaryBlue.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Center(
                child: Text(
                  connectButton,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: context.colors.primaryBlue,
                        fontSize: 14,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ],
        if (widget.appearedAs == NetworkScreenConnectionType.requests) ...[
          InkWell(
            onTap: widget.onRequestFeedback,
            borderRadius: BorderRadius.circular(8.r),
            child: Container(
              height: 36.h,
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 6.h),
              decoration: BoxDecoration(
                color: context.colors.primaryBlue,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Center(
                child: Text(
                  "Accept",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: context.colors.pureWhite,
                        fontSize: 14,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          8.ph,
          InkWell(
            onTap: widget.onDisconnect,
            borderRadius: BorderRadius.circular(8.r),
            child: Container(
              height: 36.h,
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 6.h),
              decoration: BoxDecoration(
                border: Border.all(
                  color: context.colors.textBlack,
                ),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Center(
                child: Text(
                  "Decline",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 14,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
