import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/ui/theme.dart';
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

class CategoryItem {
  final String name;
  final String iconPath;
  final int count;
  final bool isSelected;

  CategoryItem({
    required this.name,
    required this.iconPath,
    required this.count,
    this.isSelected = false,
  });

  CategoryItem copyWith({bool? isSelected}) {
    return CategoryItem(
      name: name,
      iconPath: iconPath,
      count: count,
      isSelected: isSelected ?? this.isSelected,
    );
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

typedef OnFiltersChanged = void Function(
    Map<String, Set<String>> selectedFilters);
typedef OnCategoryChanged = void Function(Set<String> selectedCategories);
typedef OnSliderChanged = void Function(double value);

class FilterBottomSheetContent extends StatefulWidget {
  final String title;
  final List<FilterSection>? sections;
  final List<CategoryItem>? categories;
  final RangeSliderConfig? rangeSliderConfig;
  final Map<String, Set<String>>? initialFilters;
  final Set<String>? initialCategories;
  final double? initialSliderValue;
  final OnFiltersChanged? onFiltersChanged;
  final OnCategoryChanged? onCategoryChanged;
  Function(RangeValues)? onRangeChanged;
  final VoidCallback? onApply;
  final VoidCallback? onReset;
  final String? applyButtonText;
  final String? resetButtonText;

  FilterBottomSheetContent({
    super.key,
    required this.title,
    this.sections,
    this.categories,
    this.rangeSliderConfig,
    this.initialFilters,
    this.initialSliderValue,
    this.onFiltersChanged,
    this.onCategoryChanged,
    this.onRangeChanged,
    this.onApply,
    this.onReset,
    this.applyButtonText,
    this.resetButtonText,
    this.initialCategories,
  });

  @override
  _FilterBottomSheetContentState createState() =>
      _FilterBottomSheetContentState();
}

class _FilterBottomSheetContentState extends State<FilterBottomSheetContent> {
  late TextEditingController _searchController;
  late Map<String, Set<String>> selectedSectionFilters;
  late RangeValues rangeValues;
  late double sliderValue;
  late List<CategoryItem> _categories;
  late List<CategoryItem> _filteredCategories;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    if (widget.sections != null) {
      selectedSectionFilters = widget.initialFilters?.map(
            (key, value) => MapEntry(key, Set<String>.from(value)),
          ) ??
          {
            for (var section in widget.sections!) section.title: <String>{},
          };
    }

    if (widget.rangeSliderConfig != null) {
      rangeValues = widget.rangeSliderConfig!.initialRange ??
          RangeValues(
            widget.rangeSliderConfig!.min,
            widget.rangeSliderConfig!.max,
          );
    }

    // Initialize the categories with default values or from the initialCategories
    _categories = widget.categories ?? [];
    _filteredCategories = _categories;
    if (widget.initialCategories != null) {
      for (var i = 0; i < _categories.length; i++) {
        if (widget.initialCategories!.contains(_categories[i].name)) {
          _categories[i] = _categories[i].copyWith(isSelected: true);
        }
      }
    }
  }

  void _filterCategories(String query) {
    setState(() {
      _filteredCategories = _categories
          .where((category) =>
              category.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _toggleCategory(int index) {
    setState(() {
      _categories[index] = _categories[index].copyWith(
        isSelected: !_categories[index].isSelected,
      );
    });

    // Get the set of selected category names
    final selectedCategories = _categories
        .where((category) => category.isSelected)
        .map((category) => category.name)
        .toSet();

    // Notify the parent widget about the change in selected categories
    if (widget.onCategoryChanged != null) {
      widget.onCategoryChanged!(selectedCategories);
      // widget.onCategoryChanged(selectedCategories);
    }

    // Notify the parent widget of the overall filter changes
    if (widget.onFiltersChanged != null) {
      widget.onFiltersChanged!({
        'categories': selectedCategories,
      });
    }
  }

  void _resetFilters() {
    setState(() {
      if (widget.sections != null) {
        selectedSectionFilters = {
          for (var section in widget.sections!) section.title: <String>{},
        };
      }

      if (widget.categories != null) {
        selectedSectionFilters = {
          for (var category in widget.categories!) category.name: <String>{},
        };
      }

      sliderValue = widget.rangeSliderConfig?.min ?? 0.0;
    });
    widget.onReset?.call();
  }

  void _updateFilters(String section, String option) {
    FilterSection? sectionConfig;
    setState(() {
      if (widget.sections != null) {
        sectionConfig = widget.sections!.firstWhere((s) => s.title == section);
        if (sectionConfig!.allowMultipleSelection) {
          if (selectedSectionFilters[section]!.contains(option)) {
            selectedSectionFilters[section]!.remove(option);
          } else {
            selectedSectionFilters[section]!.add(option);
          }
        } else {
          selectedSectionFilters[section] = {option};
        }

        widget.onFiltersChanged?.call(selectedSectionFilters);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          if (widget.categories != null) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                children: [
                  Text(
                    'Category',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: context.colors.darkGrey,
                        ),
                  ),
                ],
              ),
            ),
            12.ph,
            _buildSearchBar(),
            16.ph,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: _buildCategoryGrid(),
            ),
          ],
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

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefix: Icon(
                  Icons.search,
                  color: AppColors().primaryBlue,
                ),
                hintText: 'Search feedback category',
                border: InputBorder.none,
                hintStyle: const TextStyle(color: Colors.grey),
                fillColor: context.colors.pureWhite,
              ),
              onChanged: _filterCategories,
            ),
          ),
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(40.r),
            child: Container(
              height: 43.r,
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

  Widget _buildCategoryGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1, // Adjust aspect ratio for tile size
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final category = _categories[index];
        return _buildCategoryTile(category, index);
      },
    );
  }

  Widget _buildCategoryTile(CategoryItem category, int index) {
    return InkWell(
      onTap: () => _toggleCategory(index),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: category.isSelected
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
              Image.network(
                category.iconPath,
                width: 32.w,
                height: 32.h,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.image),
              ),
              SizedBox(height: 8.h),
              Text(
                category.name,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                '(${category.count})',
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

  Widget _buildFilterOption(String section, String option) {
    final isSelected =
        selectedSectionFilters[section]?.contains(option) ?? false;
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
