import 'package:feedback_work/core/ui/widgets/filter__content.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectResidence extends ConsumerStatefulWidget {
  const SelectResidence({
    this.onFiltersChanged,
    super.key,
  });

  final void Function(Map<String, Set<dynamic>>)? onFiltersChanged;

  @override
  ConsumerState<SelectResidence> createState() => _SelectFeedbackuserState();
}

class _SelectFeedbackuserState extends ConsumerState<SelectResidence> {
  List<FilterSection<String>> sections = [
    FilterSection<String>(
      title: "residences",
      showTitle: false,
      values: [
        'Same Residence',
        'Separate Residence',
      ],
      labels: [
        'Same Residence',
        'Separate Residence',
      ],
      allowMultipleSelection: false,
    ),
  ];

  Map<String, Set<String>> selectedFilters = {
    'residences': {'Same Residence'}
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          Expanded(
            child: FilterContent<String>(
              hasHeader: false,
              hasSearchOption: false,
              sections: sections,
              selectedFilters: selectedFilters,
              onFiltersChanged: widget.onFiltersChanged,
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
}
