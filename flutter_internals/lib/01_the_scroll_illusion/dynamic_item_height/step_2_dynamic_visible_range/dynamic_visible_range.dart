import 'package:flutter_internals/01_the_scroll_illusion/dynamic_item_height/step_1_height_cache/height_cache.dart';

// Class that calculates the dynamic visible range based upon the scroll,
// viewport height, height cache and total item count.
class DynamicVisibleRange {
  // The first index of the visible range.
  final int firstIndex;

  // The last index of the visible range.
  final int lastIndex;

  DynamicVisibleRange({
    // How much pexels has been scrolled can be 0.
    required double scrollOffset,

    // The height of the viewport.
    required double viewHeightPort,

    // The height cache of the items.
    required HeightCache heightCache,

    // The total number of items.
    required int totalItemCount,
  }) : firstIndex = _calculateFirstIndex(
         scrollOffset: scrollOffset,
         heightCache: heightCache,
         totalItemCount: totalItemCount,
       ),
       lastIndex = _calculateLastIndex(
         scrollOffset: scrollOffset,
         heightCache: heightCache,
         totalItemCount: totalItemCount,
         viewPortHeight: viewHeightPort,
       );

  static int _calculateFirstIndex({
    required double scrollOffset,
    required HeightCache heightCache,
    required int totalItemCount,
  }) {
    // Get the index of the item at the given offset.
    int index = heightCache.getFirstIndexAtOffset(
      offset: scrollOffset,
      totalItems: totalItemCount,
    );

    // The index should be between 0 and totalItemCount - 1.
    index = index.clamp(0, totalItemCount - 1);

    return index;
  }

  static int _calculateLastIndex({
    required double scrollOffset,
    required double viewPortHeight,
    required HeightCache heightCache,
    required int totalItemCount,
  }) {
    // Get the first index of the visible range.
    final firstIndex = _calculateFirstIndex(
      scrollOffset: scrollOffset,
      heightCache: heightCache,
      totalItemCount: totalItemCount,
    );

    // Get the last index of the visible range.
    int index = heightCache.getLastIndexAtOffset(
      startIndex: firstIndex,
      offset: scrollOffset,
      viewPortHeight: viewPortHeight,
      totalItems: totalItemCount,
    );

    // The index should be between 0 and totalItemCount - 1.
    index = index.clamp(0, totalItemCount - 1);

    return index;
  }

  // The number of items visible in the viewport.
  int get count => lastIndex - firstIndex + 1;
}
