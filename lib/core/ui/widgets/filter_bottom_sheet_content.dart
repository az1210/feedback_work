import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FilterSection {
  final String title;
  final List<String> options;
  final bool allowMultipleSelection;

  FilterSection({
    required this.title,
    required this.options,
    this.allowMultipleSelection = true,
  });
}

class RangeSliderConfig {
  final String title;
  final double min;
  final double max;
  final int? divisions;
  final String Function(double)? labelFormatter;
  final RangeValues? initialRange;

  RangeSliderConfig({
    required this.title,
    this.min = 0,
    this.max = 100,
    this.divisions,
    this.labelFormatter,
    this.initialRange,
  });
}

typedef OnFiltersChanged = void Function(
    Map<String, Set<String>> selectedFilters);
typedef OnSliderChanged = void Function(double value);

class FilterBottomSheetContent extends StatefulWidget {
  final String title;
  final List<FilterSection> sections;
  final RangeSliderConfig? rangeSliderConfig;
  final Map<String, Set<String>>? initialFilters;
  final double? initialSliderValue;
  final OnFiltersChanged? onFiltersChanged;
  Function(RangeValues)? onRangeChanged;
  final VoidCallback? onApply;
  final VoidCallback? onReset;
  final String? applyButtonText;
  final String? resetButtonText;

  FilterBottomSheetContent({
    super.key,
    required this.title,
    required this.sections,
    this.rangeSliderConfig,
    this.initialFilters,
    this.initialSliderValue,
    this.onFiltersChanged,
    this.onRangeChanged,
    this.onApply,
    this.onReset,
    this.applyButtonText,
    this.resetButtonText,
  });

  @override
  _FilterBottomSheetContentState createState() =>
      _FilterBottomSheetContentState();
}

class _FilterBottomSheetContentState extends State<FilterBottomSheetContent> {
  late Map<String, Set<String>> selectedFilters;
  late RangeValues rangeValues;
  late double sliderValue;

  @override
  void initState() {
    super.initState();
    selectedFilters = widget.initialFilters?.map(
          (key, value) => MapEntry(key, Set<String>.from(value)),
        ) ??
        {
          for (var section in widget.sections) section.title: <String>{},
        };
    if (widget.rangeSliderConfig != null) {
      rangeValues = widget.rangeSliderConfig!.initialRange ??
          RangeValues(
            widget.rangeSliderConfig!.min,
            widget.rangeSliderConfig!.max,
          );
    }
  }

  void _resetFilters() {
    setState(() {
      selectedFilters = {
        for (var section in widget.sections) section.title: <String>{},
      };
      sliderValue = widget.rangeSliderConfig?.min ?? 0.0;
    });
    widget.onReset?.call();
  }

  void _updateFilters(String section, String option) {
    setState(() {
      final sectionConfig =
          widget.sections.firstWhere((s) => s.title == section);

      if (sectionConfig.allowMultipleSelection) {
        if (selectedFilters[section]!.contains(option)) {
          selectedFilters[section]!.remove(option);
        } else {
          selectedFilters[section]!.add(option);
        }
      } else {
        selectedFilters[section] = {option};
      }

      widget.onFiltersChanged?.call(selectedFilters);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...widget.sections.map((section) => _buildSection(section)),
                if (widget.rangeSliderConfig != null) ...[
                  _buildRangeSlider(widget.rangeSliderConfig!),
                  16.ph,
                ],
                _buildApplyButton(),
                16.ph,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          TextButton(
            onPressed: _resetFilters,
            child: Text(
              widget.resetButtonText ?? 'Reset Filters',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: context.colors.primaryBlue,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(FilterSection section) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 8.h,
            ),
            child: Text(
              section.title,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: context.colors.darkGrey,
                  ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: context.colors.pureWhite,
            ),
            child: ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) =>
                  _buildFilterOption(section.title, section.options[index]),
              separatorBuilder: (_, __) => Container(
                height: 1,
                color: context.colors.inputBorder,
              ),
              itemCount: section.options.length,
            ),
          ),
          16.ph,
        ],
      ),
    );
  }

  Widget _buildFilterOption(String section, String option) {
    final isSelected = selectedFilters[section]?.contains(option) ?? false;
    return InkWell(
      onTap: () => _updateFilters(section, option),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              option,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (isSelected)
              Icon(
                Icons.check,
                color: context.colors.primaryBlue,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRangeSlider(RangeSliderConfig config) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: 8.h,
            horizontal: 16.w,
          ),
          child: Text(
            config.title,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: context.colors.darkGrey,
                ),
          ),
        ),
        Column(
          children: [
            SliderTheme(
              data: SliderThemeData(
                rangeTrackShape: const RoundedRectRangeSliderTrackShape(),
                activeTrackColor: context.colors.primaryBlue,
                inactiveTrackColor: context.colors.inputBorder,
                rangeThumbShape: const RoundRangeSliderThumbShape(
                  elevation: 4,
                ),
                thumbColor: context.colors.pureWhite,
                overlayColor: context.colors.primaryBlue,
                activeTickMarkColor: Colors.transparent,
                inactiveTickMarkColor: Colors.transparent,
              ),
              child: RangeSlider(
                values: rangeValues,
                min: config.min,
                max: config.max,
                divisions: config.divisions,
                onChanged: (RangeValues values) {
                  setState(() {
                    rangeValues = values;
                    widget.onRangeChanged?.call(values);
                  });
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    config.labelFormatter?.call(config.min) ??
                        config.min.round().toString(),
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: context.colors.darkGrey,
                        ),
                  ),
                  Text(
                    config.labelFormatter
                            ?.call((config.min + config.max) / 2) ??
                        ((config.min + config.max) / 2).round().toString(),
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: context.colors.darkGrey,
                        ),
                  ),
                  Text(
                    config.labelFormatter?.call(config.max) ??
                        config.max.round().toString(),
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: context.colors.darkGrey,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildApplyButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      height: 52.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: context.colors.primaryBlue,
      ),
      child: Center(
        child: Text(
          widget.applyButtonText ?? 'Apply',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: context.colors.pureWhite,
              ),
        ),
      ),
    );
  }
}
