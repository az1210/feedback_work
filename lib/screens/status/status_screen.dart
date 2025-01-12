import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/router/routes.dart';
import 'package:feedback_work/screens/status/widgets/project_status_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

class StatusTabScreen extends StatefulWidget {
  const StatusTabScreen({super.key});

  @override
  State<StatusTabScreen> createState() => _StatusTabScreenState();
}

class _StatusTabScreenState extends State<StatusTabScreen> {
  bool isGrid = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Status",
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isGrid = !isGrid;
              });
            },
            icon: isGrid
                ? const Icon(
                    Icons.list,
                  )
                : const Icon(
                    Icons.grid_view,
                  ),
          ),
          8.pw,
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
        child: SingleChildScrollView(
          child: Column(
            children: [
              MasonryGridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 4,
                gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isGrid ? 2 : 1),
                itemBuilder: (context, index) => GestureDetector(
                  onTap: (){
                    context.pushNamed(Routes.statusReport);
                  },
                  child: const ProjectStatusCard(
                    title: "title",
                    problemBefore: "Manual Workflow",
                    solutionAfter: "Automate workflow",
                    functionExecuted: "Flutter",
                    projectStatus: "Completed",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
