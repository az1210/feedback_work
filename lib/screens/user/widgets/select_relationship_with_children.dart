import 'package:feedback_work/core/ui/widgets/filter__content.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectRelationship extends ConsumerStatefulWidget {
  const SelectRelationship({
    this.onFiltersChanged,
    super.key,
  });

  final void Function(Map<String, Set<dynamic>>)? onFiltersChanged;

  @override
  ConsumerState<SelectRelationship> createState() => _SelectFeedbackuserState();
}

class _SelectFeedbackuserState extends ConsumerState<SelectRelationship> {
  List<FilterSection<String>> sections = [
    FilterSection(
      title: "relationship",
      values: [
        'Mother',
        'Father',
        'Brother',
        'Sister',
        'Uncle',
        'Aunt',
        'Cousin',
        'Niece',
        'Nephew',
        'Guardian',
        'Grandmother',
        'Grandfather',
        'Grandma',
        'Grandpa',
        'In-law',
        'Nani',
        'Friend',
        'Other',
      ],
      labels: [
        'Mother',
        'Father',
        'Brother',
        'Sister',
        'Uncle',
        'Aunt',
        'Cousin',
        'Niece',
        'Nephew',
        'Guardian',
        'Grandmother',
        'Grandfather',
        'Grandma',
        'Grandpa',
        'In-law',
        'Nani',
        'Friend',
        'Other',
      ],
    )
  ];

  Map<String, Set<String>> selectedFilters = {
    'relationship': {'Mother'}
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
