import 'package:feedback_work/core/ui/widgets/filter__content.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:feedback_work/providers/category_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectFeedbackCategory extends ConsumerStatefulWidget {
  const SelectFeedbackCategory({
    this.onFiltersChanged,
    super.key,
  });

  final void Function(String?)? onFiltersChanged;

  @override
  ConsumerState<SelectFeedbackCategory> createState() =>
      _SelectFeedbackCategoryState();
}

class _SelectFeedbackCategoryState
    extends ConsumerState<SelectFeedbackCategory> {
  List<FilterSection<String>> sections = [];
  Map<String, Set<String>> selectedFilters = {};

  @override
  void initState() {
    Future.microtask(() {
      ref.read(categoryProvider.notifier).fetchAllCategories();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final categoryState = ref.watch(categoryProvider);
    ref.listen(categoryProvider, (_, newState) {
      if (newState.state == AsyncState.success) {
        Log.info(newState.data.toString());
        final data = newState.data;
        List<String> options = [];
        if (data != null || data!.isNotEmpty) {
          for (var i in data) {
            options.add(i.categoryTitle);
          }
          sections = [
            FilterSection<String>(
                title: "category",
                showTitle: false,
                values: options,
                labels: options,
                allowMultipleSelection: false),
          ];
          // selectedFilters = {
          //   "category": {options.first}
          // };
        }
      }
    });
    return Builder(builder: (context) {
      if (categoryState.state == AsyncState.loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (categoryState.state == AsyncState.failure) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                FilterContent<String>(
                  hasHeader: false,
                  sections: sections,
                  onFiltersChanged: (p0) {
                    setState(() {
                      selectedFilters = p0;
                      widget.onFiltersChanged!(p0['category']?.first ?? '');
                    });
                  },
                  selectedFilters: selectedFilters,
                  onApply: () {
                    Log.info('Filters applied');
                  },
                  onReset: () {
                    Log.info('Filters reset');
                  },
                  hasActionButton: false,
                ),
              ],
            ),
          ),
        );
      }
    });
  }
}
