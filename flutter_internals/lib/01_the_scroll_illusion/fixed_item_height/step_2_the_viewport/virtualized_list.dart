import 'package:flutter/material.dart';
import '../step_1_the_math/visible_range.dart';

/// Widget that renders a list of items with a fixed item height.
class VirtualizedList extends StatefulWidget {
  // The total number of items in the list.
  final int itemCount;

  // The height of each item.
  final double itemHeight;

  // The builder function to create each item widget.
  final Widget Function(BuildContext context, int index) itemBuilder;

  const VirtualizedList({
    super.key,
    required this.itemCount,
    required this.itemHeight,
    required this.itemBuilder,
  });

  @override
  State<VirtualizedList> createState() => _VirtualizedListState();
}

class _VirtualizedListState extends State<VirtualizedList> {
  // The scroll controller to control the scroll position.
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // When the scroll position changes, rebuild the widget.
    _scrollController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Step 1: Use the layout builder to get the viewport height.
    return LayoutBuilder(
      builder: (context, constraints) {
        // Step 1.1 Get the viewport height.
        final viewportHeight = constraints.maxHeight;

        // Step 2: Calculate the total height of the list.
        final totalHeight = widget.itemCount * widget.itemHeight;

        // Step 3: Get the current scroll offset.
        final scrollOffset = _scrollController.hasClients
            ? _scrollController.offset
            : 0.0;

        // Step 4: Calculate the visible range.
        final range = VisibleRange(
          scrollOffset: scrollOffset,
          viewportHeight: viewportHeight,
          itemHeight: widget.itemHeight,
          totalItemCount: widget.itemCount,
        );

        // Step 5: Build the visible items.
        final visibleItems = <Widget>[];
        for (int index = range.firstIndex; index <= range.lastIndex; index++) {
          // Step 5.1: Build the visible item.
          visibleItems.add(
            Positioned(
              // the top will be index * item height.
              top: index * widget.itemHeight,
              left: 0,
              right: 0,
              height: widget.itemHeight,
              child: widget.itemBuilder(context, index),
            ),
          );
        }

        // Step 6: Return the single child scroll view with the visible items.
        return SingleChildScrollView(
          controller: _scrollController,
          child: SizedBox(
            height: totalHeight,
            child: Stack(children: visibleItems),
          ),
        );
      },
    );
  }
}
