/// Class that calculates the visible range based upon the scroll,
/// viewport height, item height and total item count.
class VisibleRange {
  // The first index of the visible range.
  int firstIndex = 0;

  // The last index of visible range.
  int lastIndex = 0;

  VisibleRange({
    // How much pexels has been scrolled can be 0.
    required double scrollOffset,

    // The height of the viewport.
    required double viewportHeight,

    // The height of each item.
    required double itemHeight,

    // The total number of items.
    required int totalItemCount,
  }) {
    // Calculate the first index of the visible range.
    // How much pexels user has scrolled divided by the height of each item.
    // The first index should be range from 0 to totalItemCount - 1.
    firstIndex = (scrollOffset / itemHeight).floor().clamp(
      0,
      totalItemCount - 1,
    );

    // Calculate the last index of the visible range.
    // How much pexels user has scrolled plus the viewport height
    // divided by height of each item
    // The last index should be range from 0 to totalItemCount - 1.
    lastIndex = ((scrollOffset + viewportHeight) / itemHeight).ceil() - 1;
    lastIndex = lastIndex.clamp(0, totalItemCount - 1);
  }

  // The number of items visible in the viewport.
  int get count => lastIndex - firstIndex + 1;
}
