import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/ui/widgets/filter_bottom_sheet_content.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:flutter/material.dart';

void showFeedbackFilters(BuildContext context) {
  final sections = [
    FilterSection<String>(
      title: 'Privacy',
      values: ['All', 'Private', 'Public', 'My Feedback'],
      labels: ['All', 'Private', 'Public', 'My Feedback'],
      allowMultipleSelection: false,
    ),
    FilterSection(
      title: 'Sort by',
      values: ['Date', 'A-Z'],
      labels: ['Date', 'A-Z'],
      allowMultipleSelection: false,
    ),
    FilterSection(
      title: 'Category',
      values: [
        'Social Media',
        'Automotive & Mechanics',
        'Accounting, Consulting & Finance',
        'Education & Tutoring',
        'Arts & Creative',
        'IT, Data & Analytics',
        'Engineering & Architecture',
        'Web, Mobile & Software Development',
        'Business Support & Admin',
        'Sales & Marketing',
        'Legal Services',
        'Writing & Translation',
        'Health & Beauty',
        'Home & Real Estate',
        'Lifestyle',
        'Sports & Outdoors',
        'Books & Publishing',
        'Electronics & Gadgets',
        'Antiques & Collectibles',
        'Tools & Equipment',
        'Security Services',
        'Labor & Technical Support',
        'Fraud & Scams',
      ],
      labels: [
        'Social Media',
        'Automotive & Mechanics',
        'Accounting, Consulting & Finance',
        'Education & Tutoring',
        'Arts & Creative',
        'IT, Data & Analytics',
        'Engineering & Architecture',
        'Web, Mobile & Software Development',
        'Business Support & Admin',
        'Sales & Marketing',
        'Legal Services',
        'Writing & Translation',
        'Health & Beauty',
        'Home & Real Estate',
        'Lifestyle',
        'Sports & Outdoors',
        'Books & Publishing',
        'Electronics & Gadgets',
        'Antiques & Collectibles',
        'Tools & Equipment',
        'Security Services',
        'Labor & Technical Support',
        'Fraud & Scams',
      ],
      allowMultipleSelection: true,
    ),
  ];

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
