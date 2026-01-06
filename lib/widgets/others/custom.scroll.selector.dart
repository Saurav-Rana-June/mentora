import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomScrollSelector extends StatefulWidget {
  final int minValue;
  final int maxValue;
  final int initialValue;
  final double itemHeight;
  final double height;
  final String unit;
  final TextStyle selectedTextStyle;
  final TextStyle unselectedTextStyle;
  final Color dividerColor;
  final ValueChanged<int> onChanged;

  const CustomScrollSelector({
    super.key,
    required this.minValue,
    required this.maxValue,
    required this.initialValue,
    required this.onChanged,
    this.itemHeight = 48,
    this.height = 200,
    this.unit = '',
    this.dividerColor = const Color(0xFFE0E0E0),
    this.selectedTextStyle = const TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: Colors.green,
    ),
    this.unselectedTextStyle = const TextStyle(
      fontSize: 18,
      color: Colors.grey,
    ),
  });

  @override
  State<CustomScrollSelector> createState() => _CustomScrollSelectorState();
}

class _CustomScrollSelectorState extends State<CustomScrollSelector> {
  late FixedExtentScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FixedExtentScrollController(
      initialItem: widget.initialValue - widget.minValue,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: Get.width / 2,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Top Divider
          Positioned(
            top: widget.height / 2 - widget.itemHeight / 2,
            left: 0,
            right: 0,
            child: Divider(color: widget.dividerColor, thickness: 1),
          ),

          // Bottom Divider
          Positioned(
            top: widget.height / 2 + widget.itemHeight / 2,
            left: 0,
            right: 0,
            child: Divider(color: widget.dividerColor, thickness: 1),
          ),

          // Wheel
          ListWheelScrollView.useDelegate(
            controller: _controller,
            itemExtent: widget.itemHeight,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: (index) {
              widget.onChanged(widget.minValue + index);
            },
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: widget.maxValue - widget.minValue + 1,
              builder: (context, index) {
                final value = widget.minValue + index;
                return Center(
                  child: Container(
                    padding: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          value.toString(),
                          style: index == _controller.selectedItem
                              ? widget.selectedTextStyle
                              : widget.unselectedTextStyle,
                        ),
                        if (index == _controller.selectedItem &&
                            widget.unit.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: Text(
                              widget.unit,
                              style: widget.selectedTextStyle.copyWith(
                                fontSize:
                                    widget.selectedTextStyle.fontSize! - 6,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
