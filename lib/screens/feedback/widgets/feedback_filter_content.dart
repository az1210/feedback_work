import 'package:feedback_work/core/ui/widgets/filter__content.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:flutter/material.dart';

class FeedbackFilterContent extends StatefulWidget {
  const FeedbackFilterContent({super.key});

  @override
  State<FeedbackFilterContent> createState() => _FeedbackFilterContentState();
}

class _FeedbackFilterContentState extends State<FeedbackFilterContent> {
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

  Map<String, Set<String>> selectedFilters = {
    'Privacy': {'All'},
    'Sort by': {'Date'},
    'Category': {'Social Media'},
  };

  RangeValues currentRange = const RangeValues(0, 100);

  @override
  Widget build(BuildContext context) {
    return FilterContent(
      title: 'Filters',
      sections: sections,
      selectedFilters: selectedFilters,
      currentRangeValues: currentRange,
      onFiltersChanged: (filters) {
        setState(() {
          selectedFilters = filters;
        });
        Log.info('Filters updated: $filters');
      },
      onRangeChanged: (RangeValues values) {
        setState(() {
          currentRange = values;
        });
        Log.info('Range changed: ${values.start} - ${values.end}');
      },
      onApply: () {
        Log.info('Filters applied');
      },
      onReset: () {
        Log.info('Filters reset');
      },
    );
  }
}
