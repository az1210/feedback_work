import 'package:feedback_work/core/extensions/string_extension.dart';
import 'package:feedback_work/core/utils/network_image_helper.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/ui/theme.dart';

class FilterSection<T> {
  final String title;
  final List<T> values;
  final List<String> labels;
  final List<String>? imageUrls;
  final List<String>? counts;
  final bool allowMultipleSelection;
  final bool showTitle;

  FilterSection({
    this.imageUrls,
    this.counts,
    required this.title,
    required this.values,
    required this.labels,
    this.allowMultipleSelection = true,
    this.showTitle = true,
  }) {
    assert(values.length == labels.length,
        'Values and labels must have the same length');
    assert(imageUrls == null || imageUrls!.length == values.length,
        'ImageUrls must have the same length as values');
    assert(counts == null || counts!.length == values.length,
        'Counts must have the same length as values');
  }
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

typedef OnFiltersChanged<T> = void Function(
    Map<String, Set<T>> selectedFilters);

class FilterContent<T> extends StatefulWidget {
  final String? title;
  final List<FilterSection<T>>? sections;
  final RangeSliderConfig? rangeSliderConfig;
  final Map<String, Set<T>>
      selectedFilters; // Changed to required, non-nullable
  final RangeValues? currentRangeValues; // Added for controlling range slider
  final OnFiltersChanged<T>? onFiltersChanged;
  final Function(RangeValues)? onRangeChanged;
  final VoidCallback? onApply;
  final VoidCallback? onReset;
  final String? applyButtonText;
  final String? resetButtonText;
  final bool hasActionButton;
  final bool hasHeader;
  final bool hasSearchOption;
  final bool isGrid;
  final String? hintText;

  const FilterContent({
    super.key,
    this.title,
    this.sections,
    this.rangeSliderConfig,
    required this.selectedFilters, // Made required
    this.currentRangeValues,
    this.onFiltersChanged,
    this.onRangeChanged,
    this.onApply,
    this.onReset,
    this.applyButtonText,
    this.resetButtonText,
    this.hasActionButton = true,
    this.hasHeader = true,
    this.hasSearchOption = true,
    this.isGrid = false,
    this.hintText,
  });

  @override
  _FilterContentState<T> createState() => _FilterContentState<T>();
}

class _FilterContentState<T> extends State<FilterContent<T>> {
  late TextEditingController _searchController;
  late RangeValues rangeValues;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_onSearchChanged);

    if (widget.rangeSliderConfig != null) {
      rangeValues = widget.currentRangeValues ??
          widget.rangeSliderConfig!.initialRange ??
          RangeValues(
            widget.rangeSliderConfig!.min,
            widget.rangeSliderConfig!.max,
          );
    }
  }

  @override
  void didUpdateWidget(FilterContent<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentRangeValues != null &&
        widget.currentRangeValues != oldWidget.currentRangeValues) {
      setState(() {
        rangeValues = widget.currentRangeValues!;
      });
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  List<FilterItem<T>> _getFilteredOptions(FilterSection<T> section) {
    if (_searchQuery.isEmpty) {
      return List.generate(
        section.values.length,
        (i) => FilterItem(
          value: section.values[i],
          label: section.labels[i],
          imageUrl: section.imageUrls?[i],
          count: section.counts?[i],
        ),
      );
    }

    return List.generate(
      section.values.length,
      (i) => FilterItem(
        value: section.values[i],
        label: section.labels[i],
        imageUrl: section.imageUrls?[i],
        count: section.counts?[i],
      ),
    ).where((item) => item.label.toLowerCase().contains(_searchQuery)).toList();
  }

  void _resetFilters() {
    if (widget.sections != null) {
      final emptyFilters = {
        for (var section in widget.sections!) section.title: <T>{},
      };
      widget.onFiltersChanged?.call(emptyFilters);
    }
    widget.onReset?.call();
  }

  void _updateFilters(String section, T value) {
    final updatedFilters = Map<String, Set<T>>.from(widget.selectedFilters);
    final sectionConfig =
        widget.sections!.firstWhere((s) => s.title == section);

    if (sectionConfig.allowMultipleSelection) {
      if (updatedFilters[section]!.contains(value)) {
        updatedFilters[section]!.remove(value);
      } else {
        updatedFilters[section]!.add(value);
      }
    } else {
      updatedFilters[section] = {value};
    }

    widget.onFiltersChanged?.call(updatedFilters);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.hasHeader)
          BuildHeader(
            title: widget.title?.toTitleCase(),
            resetButtonText: widget.resetButtonText,
            resetFilter: _resetFilters,
          ),
        if (widget.hasSearchOption)
          BuildSearchBar(
            searchController: _searchController,
            hintText: widget.hintText ?? 'Search',
          ),
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.sections != null)
                ...widget.sections!.map((section) => _buildSection(section)),
              if (widget.rangeSliderConfig != null) ...[
                _buildRangeSlider(widget.rangeSliderConfig!),
                16.ph,
              ],
            ],
          ),
        ),
        if (widget.hasActionButton) _buildApplyButton(),
        16.ph,
      ],
    );
  }

  Widget _buildSection(FilterSection<T> section) {
    final filteredOptions = _getFilteredOptions(section);

    if (filteredOptions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (section.showTitle)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Text(
              section.title,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: context.colors.darkGrey,
                  ),
            ),
          ),
        widget.isGrid
            ? _buildGridView(section, filteredOptions)
            : _buildListView(section, filteredOptions),
      ],
    );
  }

  Widget _buildGridView(FilterSection<T> section, List<FilterItem<T>> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildGridFilterOption(
          sectionTitle: section.title,
          item: item,
        );
      },
    );
  }

  Widget _buildListView(FilterSection<T> section, List<FilterItem<T>> items) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: context.colors.pureWhite,
      ),
      child: ListView.separated(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final item = items[index];
          return _buildListFilterOption(
            sectionTitle: section.title,
            item: item,
          );
        },
        separatorBuilder: (_, __) => Container(
          height: 1,
          color: context.colors.inputBorder,
        ),
        itemCount: items.length,
      ),
    );
  }

  Widget _buildListFilterOption({
    required String sectionTitle,
    required FilterItem<T> item,
  }) {
    Log.info(item.imageUrl.toString());
    final isSelected =
        widget.selectedFilters[sectionTitle]?.contains(item.value) ?? false;

    return InkWell(
      onTap: () => _updateFilters(sectionTitle, item.value),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 16.h,
          horizontal: 10.w,
        ),
        child: Row(
          children: [
            if (item.imageUrl != null && item.imageUrl!.isNotEmpty) ...[
              Image.network(
                networkImage(item.imageUrl),
                errorBuilder: (context, error, stackTrace) =>
                    const SizedBox.shrink(),
              ),
              8.pw,
            ],
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: item.label,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (item.count != null)
                      TextSpan(
                        text: ' (${item.count})',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: context.colors.primaryBlue,
                              decoration: TextDecoration.underline,
                            ),
                      ),
                  ],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
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

  Widget _buildGridFilterOption({
    required String sectionTitle,
    required FilterItem<T> item,
  }) {
    final isSelected =
        widget.selectedFilters[sectionTitle]?.contains(item.value) ?? false;
    return InkWell(
      onTap: () => _updateFilters(sectionTitle, item.value),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? context.colors.primaryBlue
                : context.colors.inputBorder,
            width: 1.5,
          ),
          color: AppColors().pureWhite,
        ),
        child: Padding(
          padding: EdgeInsets.all(8.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (item.imageUrl != null && item.imageUrl!.isNotEmpty) ...[
                Image.network(
                  networkImage(item.imageUrl),
                  width: 32.w,
                  height: 32.h,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox.shrink(),
                ),
              ],
              8.ph,
              Text(
                item.label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              if (item.count != null)
                Text(
                  ' (${item.count})',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: context.colors.primaryBlue,
                        decoration: TextDecoration.underline,
                      ),
                ),
            ],
          ),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onApply,
          child: Center(
            child: Text(
              widget.applyButtonText ?? 'Apply',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: context.colors.pureWhite,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}

class FilterItem<T> {
  final T value;
  final String label;
  final String? imageUrl;
  final String? count;

  FilterItem({
    required this.value,
    required this.label,
    this.imageUrl,
    this.count,
  });
}

class BuildSearchBar extends StatelessWidget {
  const BuildSearchBar({
    super.key,
    required TextEditingController searchController,
    this.hintText,
  }) : _searchController = searchController;

  final TextEditingController _searchController;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: SizedBox(
        height: 43.h,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  filled: true,
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors().primaryBlue,
                  ),
                  hintText: hintText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.r),
                    borderSide: BorderSide.none,
                  ),
                  hintStyle: const TextStyle(color: Colors.grey),
                  fillColor: context.colors.pureWhite,
                ),
              ),
            ),
            8.pw,
            InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(40.r),
              child: Container(
                width: 43.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.colors.pureWhite,
                ),
                child: Center(
                  child: Icon(
                    Icons.filter_list,
                    color: context.colors.primaryBlue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BuildHeader extends StatelessWidget {
  const BuildHeader(
      {super.key, this.title, this.resetFilter, this.resetButtonText});

  final String? title;
  final String? resetButtonText;
  final void Function()? resetFilter;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          title != null
              ? Text(
                  title!,
                  style: Theme.of(context).textTheme.displaySmall,
                )
              : const SizedBox.shrink(),
          TextButton(
            onPressed: resetFilter,
            child: Text(
              resetButtonText ?? 'Reset Filters',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: context.colors.primaryBlue,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
