import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/ui/widgets/filter__content.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectPrincipleToDerive extends StatefulWidget {
  const SelectPrincipleToDerive({
    super.key,
  });

  @override
  State<SelectPrincipleToDerive> createState() =>
      _SelectPrincipleToDeriveState();
}

class _SelectPrincipleToDeriveState extends State<SelectPrincipleToDerive> {
  final sections = [
    FilterSection(
      title: 'Select Principle to derive from',
      values: [
        'The Given Set of Communication Principle',
        'The Given Set of Information Principle',
        'The Given Set of Instrumentation Principle',
        'The Given Set of Marketing Principle',
        'The Given Set of Exchange Principle',
        'The Given Set of Gaming Principle',
        'The Given Set of Work Principle',
      ],
      labels: [
        'The Given Set of Communication Principle',
        'The Given Set of Information Principle',
        'The Given Set of Instrumentation Principle',
        'The Given Set of Marketing Principle',
        'The Given Set of Exchange Principle',
        'The Given Set of Gaming Principle',
        'The Given Set of Work Principle',
      ],
      allowMultipleSelection: true,
    ),
  ];

  Map<String, Set<String>> selectedFilters = {
    'Select Principle to derive from': {
      'The Given Set of Communication Principle'
    }
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: SingleChildScrollView(
        child: Column(
          children: [
            FilterContent(
              hasHeader: false,
              hasSearchOption: false,
              sections: sections,
              selectedFilters: selectedFilters,
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
            16.ph,
          ],
        ),
      ),
    );
  }
}
