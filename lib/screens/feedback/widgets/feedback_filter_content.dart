import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/ui/widgets/filter_bottom_sheet_content.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:flutter/material.dart';

void showFeedbackFilters(BuildContext context) {
  final categories = [
    CategoryItem(
      name: 'Social Media',
      iconPath: 'assets/icons/social_media.png',
      count: 12,
    ),
    CategoryItem(
      name: 'Automotive & Mechanics',
      iconPath: 'assets/icons/automotive.png',
      count: 12,
    ),
    // ... add other categories
  ];
  final sections = [
    FilterSection(
      title: 'Privacy',
      options: ['All', 'Private', 'Public', 'My Feedback'],
      allowMultipleSelection: false, // Radio button behavior
    ),
    FilterSection(
      title: 'Sort by',
      options: ['Date', 'A-Z'],
      allowMultipleSelection: false, // Radio button behavior
    ),
    FilterSection(
      title: 'Category',
      options: [
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
      allowMultipleSelection: true, // Checkbox behavior
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
      categories: categories,
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
