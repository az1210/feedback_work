import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/ui/widgets/filter_bottom_sheet_content.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:flutter/material.dart';

void showNetworkFilters(BuildContext context) {
  final sections = [
    FilterSection(
      title: 'Expertise',
      options: ['All', 'Private', 'Public', 'My Feedback'],
      allowMultipleSelection: true,
    ),
    FilterSection(
      title: 'Sort by Feedback Type',
      options: ['Feedback Provided', 'Feedback Applied', 'Feedback Requested'],
      allowMultipleSelection: false,
    ),
    FilterSection(
      title: 'Connection Type',
      options: [
        'Teacher',
        'Student',
        'Manager',
        'Coworker',
        'Employee',
        'Friend',
        'Classmate',
        'My Customer',
        'My Client',
        'Other',
      ],
      allowMultipleSelection: false,
    ),
    FilterSection(
      title: 'Sort by Feedback Count',
      options: ['Feedback Provided', 'Feedback Applied', 'Feedback Requested'],
      allowMultipleSelection: false,
    ),
  ];

  final rangeSliderConfig = RangeSliderConfig(
    title: 'Project Completion Status',
    min: 0,
    max: 100,
    divisions: 100,
    initialRange: const RangeValues(20, 80),
    labelFormatter: (value) => value.round().toString(),
  );

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: context.colors.background,
    useRootNavigator: true,
    useSafeArea: true,
    builder: (context) => FilterBottomSheetContent(
      title: 'Filters',
      sections: sections,
      rangeSliderConfig: rangeSliderConfig,
      initialFilters: const {
        'Expertise': {'Private'},
        'Connection Type': {'Student'},
      },
      initialSliderValue: 50,
      onFiltersChanged: (filters) {
        Log.info('Filters updated: $filters');
      },
      onRangeChanged: (RangeValues values) {
        Log.info('Range changed: ${values.start} - ${values.end}');
      },
      onApply: () {
        Log.info('Filters applied');
      },
      onReset: () {
        Log.info('Filters reset');
      },
    ),
  );
}
