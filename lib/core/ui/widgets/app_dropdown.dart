import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppDropdownDropdownItem<T> {
  const AppDropdownDropdownItem({
    required this.value,
    this.child,
    this.label,
    this.height = 40,
  });

  final T value;
  final Widget? child;
  final String? label;
  final double height;
}

class AppDropdown<T> extends StatefulWidget {
  const AppDropdown({
    required this.button,
    required this.items,
    this.customItems,
    this.selectedValue,
    super.key,
    this.onItemSelected,
    this.itemWidth,
    this.overlayPadding,
    this.decoration,
    this.overlayAlignment = Alignment.centerLeft,
    this.itemBorderRadius,
    this.itemGap,
    this.selectedItemBackgroundColor,
    this.selectedItemForegroundColor,
    this.overlayColor,
    this.itemsAlignment,
    this.overlayHeight,
  });

  final T? selectedValue;
  final Widget button;
  final List<AppDropdownDropdownItem<T>> items;
  final List<Widget>? customItems;
  final void Function(T)? onItemSelected;
  final double? itemWidth;
  final double? itemBorderRadius;
  final double? overlayHeight;
  final EdgeInsetsGeometry? overlayPadding;
  final int? itemGap;
  final BoxDecoration? decoration;
  final Color? selectedItemBackgroundColor;
  final Color? selectedItemForegroundColor;
  final Color? overlayColor;
  final AlignmentGeometry overlayAlignment;
  final AlignmentGeometry? itemsAlignment;

  @override
  State<AppDropdown<T>> createState() => _AppDropdownState<T>();
}

class _AppDropdownState<T> extends State<AppDropdown<T>> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  final _buttonKey = GlobalKey();

  double _overlayHeight = 0;

  @override
  void initState() {
    if (widget.overlayHeight == null) {
      for (final i in widget.items) {
        _overlayHeight += i.height;
      }
      if (_overlayHeight > 0.2.sh) {
        _overlayHeight = 0.2.sh;
      }
    } else {
      _overlayHeight = widget.overlayHeight!;
    }
    super.initState();
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _removeOverlay();
    } else {
      _createOverlay();
    }
    setState(() {
      _isOpen = !_isOpen;
    });
  }

  Offset _getOffset(
    Size buttonSize,
    bool showAbove,
  ) {
    final alignment = widget.overlayAlignment;
    var dx = 0.0;
    final dy = !showAbove ? buttonSize.height + 5 : -_overlayHeight - 5;

    if (alignment == Alignment.centerLeft) {
      dx = 0;
    } else if (alignment == Alignment.center) {
      dx = (buttonSize.width - (widget.itemWidth ?? 0)) / 2;
    } else if (alignment == Alignment.centerRight) {
      dx = buttonSize.width - (widget.itemWidth ?? 0);
    }

    return Offset(
      dx,
      dy,
    );
  }

  void _createOverlay() {
    _overlayEntry = _customDropdownOverlay();
    Overlay.of(context).insert(_overlayEntry!);
  }

  double _getButtonWidth() {
    final renderBox =
        _buttonKey.currentContext?.findRenderObject() as RenderBox?;
    return renderBox?.size.width ?? 0;
  }

  OverlayEntry _customDropdownOverlay() {
    final renderBox = context.findRenderObject()! as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final buttonSize = renderBox.size;
    final buttonWidth = _getButtonWidth();
    final showAbove =
        offset.dy + _overlayHeight > MediaQuery.of(context).size.height;

    return OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _toggleDropdown,
        behavior: HitTestBehavior.translucent,
        child: ColoredBox(
          color: Colors.transparent,
          child: Stack(
            children: [
              CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: _getOffset(
                  buttonSize,
                  showAbove,
                ),
                child: Column(
                  children: [
                    Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(8),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: _overlayHeight,
                          minWidth: widget.itemWidth ?? buttonWidth,
                          maxWidth: widget.itemWidth ?? buttonWidth,
                        ),
                        child: Container(
                          padding: widget.overlayPadding,
                          decoration: widget.decoration ??
                              BoxDecoration(
                                color: widget.overlayColor ??
                                    context.colors.background,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                          child: ListView.separated(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: widget.items.length,
                            itemBuilder: (context, index) {
                              final item = widget.items[index];
                              final isSelected = widget.items[index].value ==
                                  widget.selectedValue;
                              return InkWell(
                                onTap: () {
                                  widget.onItemSelected?.call(item.value);
                                  _toggleDropdown();
                                },
                                child: Container(
                                  // margin: widget.overlayItemsMargin ??
                                  //     EdgeInsets.symmetric(
                                  //       horizontal: 16.w,
                                  //       vertical: 8.h,
                                  //     ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                  ),
                                  height: widget.items[index].height,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? widget.selectedItemBackgroundColor ??
                                            context.colors.pureWhite
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(
                                      widget.itemBorderRadius ?? 4.r,
                                    ),
                                  ),
                                  alignment: widget.itemsAlignment,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: item.child ??
                                        SizedBox(
                                          width:
                                              widget.itemWidth ?? buttonWidth,
                                          child: Text(
                                            item.label!,
                                            style: TextStyle(
                                              color: isSelected
                                                  ? widget.selectedItemForegroundColor ??
                                                      context.colors.primaryBlue
                                                  : context.colors.textBlack,
                                            ),
                                          ),
                                        ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) =>
                                widget.itemGap != null
                                    ? widget.itemGap!.ph
                                    : 8.ph,
                          ),
                        ),
                      ),
                    ),
                    8.ph,
                    if (widget.customItems != null)
                      ...widget.customItems!.map(
                        (c) => Material(
                          elevation: 4,
                          child: SizedBox(
                            width: widget.itemWidth ?? buttonSize.width,
                            child: c,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Container(
        key: _buttonKey,
        child: InkWell(
          onTap: _toggleDropdown,
          child: widget.button,
        ),
      ),
    );
  }
}
