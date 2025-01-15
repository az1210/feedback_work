import 'package:feedback_work/core/ui/widgets/filter__content.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:feedback_work/models/group_model.dart';
import 'package:feedback_work/providers/group_providers.dart';
import 'package:feedback_work/providers/user_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectFeedbackProvider extends ConsumerStatefulWidget {
  const SelectFeedbackProvider({
    required this.category,
    super.key,
  });

  final String category;

  @override
  ConsumerState<SelectFeedbackProvider> createState() =>
      _SelectFeedbackProviderState();
}

class _SelectFeedbackProviderState
    extends ConsumerState<SelectFeedbackProvider> {
  List<FilterSection> sections = [];
  List<GroupModel> groups = [];
  List<GroupModel> filteredGroups = [];

  @override
  void initState() {
    Future.microtask(() {
      ref
          .read(userProvider.notifier)
          .fetchUsersByExpertise(expertise: widget.category);

      ref.read(groupProvider.notifier).fetchAllGroups();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);
    ref.listen(userProvider, (_, newState) {
      if (newState.state == AsyncState.success) {
        List<String> names = [];
        for (var i in newState.data!) {
          names.add("${i.firstName ?? ''} ${i.lastName ?? ''}");
        }
        Log.info(names.first.toString());
        sections.add(
          FilterSection(
            title: "provider",
            values: names,
            labels: names,
            allowMultipleSelection: false,
            showTitle: false,
          ),
        );
      }
    });

    final groupState = ref.watch(groupProvider);
    ref.listen(groupProvider, (_, newState) {
      if (newState.state == AsyncState.success) {
        groups = newState.data ?? [];
      }
    });
    return Builder(builder: (context) {
      if (userState.state == AsyncState.loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (userState.error != null) {
        return Center(
          child: Text("Error: ${userState.error}"),
        );
      } else {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              Expanded(
                child: FilterContent(
                  hasHeader: false,
                  sections: sections,
                  onFiltersChanged: (filters) {
                    Log.info('Filters updated: $filters');
                  },
                  onApply: () {
                    Log.info('Filters applied');
                  },
                  onReset: () {
                    Log.info('Filters reset');
                  },
                  hasActionButton: false,
                ),
              ),
            ],
          ),
        );
      }
    });
  }
}
