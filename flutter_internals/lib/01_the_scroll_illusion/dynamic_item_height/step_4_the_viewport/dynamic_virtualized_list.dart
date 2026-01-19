import 'package:flutter/material.dart';
import 'package:flutter_internals/01_the_scroll_illusion/dynamic_item_height/step_1_height_cache/height_cache.dart';
import 'package:flutter_internals/01_the_scroll_illusion/dynamic_item_height/step_2_dynamic_visible_range/dynamic_visible_range.dart';
import 'package:flutter_internals/01_the_scroll_illusion/dynamic_item_height/step_3_measuring_size/measuring_size.dart';

// Class that renders a list of items with dynamic item heights.
class DynamicVirtualizedList extends StatefulWidget {
  // The total number of items in the list.
  final int itemCount;

  // The builder function to create each item widget.
  final Widget Function(BuildContext context, int index) itemBuilder;

  const DynamicVirtualizedList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
  });

  @override
  State<DynamicVirtualizedList> createState() => _DynamicVirtualizedListState();
}

class _DynamicVirtualizedListState extends State<DynamicVirtualizedList> {
  // The scroll controller to control the scroll position.
  late ScrollController _scrollController;

  // The height cache to store the measured heights of the items.
  late final HeightCache heightCache;

  @override
  void initState() {
    super.initState();

    // Initialize the height cache.
    heightCache = HeightCache(totalItems: widget.itemCount);

    // Initialize the scroll controller.
    _scrollController = ScrollController();

    // When the scroll position changes, rebuild the widget.
    _scrollController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // Step 1: Use the layout builder to get the viewport height.
    return LayoutBuilder(
      builder: (context, constraints) {
        // Step 1.1: Get the viewport height.
        final viewportHeight = constraints.maxHeight;

        // Step 2: Get the current scroll offset.
        double scrollOffset = _scrollController.hasClients
            ? _scrollController.offset
            : 0.0;

        // Step 3: Calculate the visible range.
        final range = DynamicVisibleRange(
          scrollOffset: scrollOffset,
          viewHeightPort: viewportHeight,
          heightCache: heightCache,
          totalItemCount: widget.itemCount,
        );

        // Step 4: Build the visible items.
        List<Widget> visibleItems = [];

        for (int index = range.firstIndex; index <= range.lastIndex; index++) {
          // Step 4.1: Get the top position of the item.
          final top = heightCache.getCumulativeHeight(index);

          // Step 4.2: Build the visible item.
          visibleItems.add(
            Positioned(
              top: top,
              left: 0,
              right: 0,
              child: MeasuringSize(
                child: widget.itemBuilder(context, index),
                onSizeChanged: (size) {
                  // Step 4.3: Get the current height of the item.
                  double currentHeight = heightCache.getHeight(index);

                  // Step 4.4: If the current height is not the same as the
                  // size height, set the height of the item in the
                  // height cache.
                  if (currentHeight != size.height) {
                    heightCache.setHeight(
                      currentIndex: index,
                      height: size.height,
                    );

                    // Step 4.5: Rebuild the widget.
                    setState(() {});
                  }
                },
              ),
            ),
          );
        }

        // Step 5: Return the single child scroll view with the visible items.
        return SingleChildScrollView(
          controller: _scrollController,
          child: SizedBox(
            height: heightCache.getTotalHeight(widget.itemCount),
            child: Stack(children: visibleItems),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
