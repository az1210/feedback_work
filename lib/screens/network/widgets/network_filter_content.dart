import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/ui/widgets/filter__content.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:flutter/material.dart';

void showNetworkFilters(BuildContext context) {
  final sections = [
    FilterSection(
      title: 'Expertise',
      values: ['All', 'Private', 'Public', 'My Feedback'],
      labels: ['All', 'Private', 'Public', 'My Feedback'],
      allowMultipleSelection: true,
    ),
    FilterSection(
      title: 'Sort by Feedback Type',
      values: ['Feedback Provided', 'Feedback Applied', 'Feedback Requested'],
      labels: ['Feedback Provided', 'Feedback Applied', 'Feedback Requested'],
      allowMultipleSelection: false,
    ),
    FilterSection(
      title: 'Connection Type',
      values: [
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
      labels: [
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
      values: ['Feedback Provided', 'Feedback Applied', 'Feedback Requested'],
      labels: ['Feedback Provided', 'Feedback Applied', 'Feedback Requested'],
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

  RangeValues currentRange = const RangeValues(0, 100);
  Map<String, Set<String>> selectedFilters = {
    'Expertise': {'All'},
    'Sort by Feedback Type': {'Feedback Provided'},
    'Connection Type': {'Teacher'},
    'Sort by Feedback Count': {'Feedback Provided'},
  };
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: context.colors.background,
    useRootNavigator: true,
    useSafeArea: true,
    builder: (context) => FilterContent(
      title: 'Filters',
      sections: sections,
      rangeSliderConfig: rangeSliderConfig,
      selectedFilters: selectedFilters,
      currentRangeValues: currentRange,
      onFiltersChanged: (filters) {
        selectedFilters = filters;
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
