import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MonitorGroupScreen extends StatefulWidget {
  const MonitorGroupScreen({super.key});

  @override
  State<MonitorGroupScreen> createState() => _MonitorGroupScreenState();
}

class _MonitorGroupScreenState extends State<MonitorGroupScreen> {
  List<String> users = [
    "Group",
    "User1",
    "User2",
  ];
  String selectedUser = "Group";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.pureWhite,
      appBar: AppBar(
        title: const Text(
          "Solution Function",
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.refresh,
              color: context.colors.primaryBlue,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 32.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  setState(() {
                    selectedUser = users[index];
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                  ),
                  decoration: BoxDecoration(
                    color: selectedUser == users[index]
                        ? context.colors.primaryBlue.withValues(alpha: 0.1)
                        : context.colors.transparent,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: context.colors.inputBorder,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      users[index],
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontSize: 14,
                            fontWeight: selectedUser == users[index]
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: selectedUser == users[index]
                                ? context.colors.primaryBlue
                                : context.colors.textBlack,
                          ),
                    ),
                  ),
                ),
              ),
              separatorBuilder: (_, __) => 8.pw,
              itemCount: users.length,
            ),
          ),
        ],
      ),
    );
  }
}
