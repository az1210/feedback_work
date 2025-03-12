import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppDropdownItem<T> {
  const AppDropdownItem({
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
  final List<AppDropdownItem<T>> items;
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
    super.initState();
    _calculateOverlayHeight();
  }

  void _calculateOverlayHeight() {
    if (widget.overlayHeight == null) {
      _overlayHeight = widget.items.fold(0, (sum, item) => sum + item.height);
      _overlayHeight = _overlayHeight > 0.2.sh ? 0.2.sh : _overlayHeight;
    } else {
      _overlayHeight = widget.overlayHeight!;
    }
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() => _isOpen = false);
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _removeOverlay();
    } else {
      _createOverlay();
      setState(() => _isOpen = true);
    }
  }

  void _createOverlay() {
    _overlayEntry = _customDropdownOverlay();
    Overlay.of(context).insert(_overlayEntry!);
  }

  OverlayEntry _customDropdownOverlay() {
    final renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final buttonSize = renderBox.size;
    final buttonWidth = _getButtonWidth();
    final showAbove =
        offset.dy + _overlayHeight > MediaQuery.of(context).size.height;

    return OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _removeOverlay,
        behavior: HitTestBehavior.translucent,
        child: ColoredBox(
          color: Colors.transparent,
          child: Stack(
            children: [
              CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: _getOffset(buttonSize, showAbove),
                child: Material(
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
                                color: Colors.black.withOpacity(0.1),
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
                          final isSelected = item.value == widget.selectedValue;
                          return InkWell(
                            onTap: () {
                              widget.onItemSelected?.call(item.value);
                              _removeOverlay(); // Ensure dropdown closes on selection
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              height: item.height,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? widget.selectedItemBackgroundColor ??
                                        context.colors.pureWhite
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(
                                    widget.itemBorderRadius ?? 4.r),
                              ),
                              alignment: widget.itemsAlignment,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: item.child ??
                                    SizedBox(
                                      width: widget.itemWidth ?? buttonWidth,
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
                            widget.itemGap != null ? widget.itemGap!.ph : 8.ph,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _getButtonWidth() {
    final renderBox =
        _buttonKey.currentContext?.findRenderObject() as RenderBox?;
    return renderBox?.size.width ?? 0;
  }

  Offset _getOffset(Size buttonSize, bool showAbove) {
    final dx = switch (widget.overlayAlignment) {
      Alignment.centerLeft => 0.0,
      Alignment.center => (buttonSize.width - (widget.itemWidth ?? 0)) / 2,
      Alignment.centerRight => buttonSize.width - (widget.itemWidth ?? 0),
      _ => 0.0,
    };
    final dy = showAbove ? -_overlayHeight - 5 : buttonSize.height + 5;
    return Offset(dx, dy);
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Container(
        key: _buttonKey,
        child: InkWell(onTap: _toggleDropdown, child: widget.button),
      ),
    );
  }
}
