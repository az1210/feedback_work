import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/ui/assets/app_assets.dart';
import 'package:feedback_work/features/network/presentation/widgets/connection_info_card.dart';
import 'package:feedback_work/features/network/presentation/widgets/network_search_and_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class NetworkScreen extends StatefulWidget {
  const NetworkScreen({super.key});

  @override
  State<NetworkScreen> createState() => _NetworkScreenState();
}

class _NetworkScreenState extends State<NetworkScreen> {
  bool isGrid = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Network",
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
      body: Column(
        children: [
          const NetworkSearchAndFilter(),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Text(
                  "My Teacher Connection",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
          Expanded(
            child: MasonryGridView.builder(
              itemCount: 3,
              gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isGrid ? 2 : 1),
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.all(8.r),
                child: const ConnectionInfoCard(
                  name: 'John Thompson',
                  role: "Teacher",
                  specialty: "Mathematics",
                  feedbackCount: 20,
                  problemsSolved: 10,
                  isConnected: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
