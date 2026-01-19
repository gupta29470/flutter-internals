/// Class that caches the measured heights of the items.
class HeightCache {
  // The estimated height of the item - initial
  final double estimatedHeight;

  // The cumulative heights of the items.
  final List<double> _cumulativeHeights = [0];

  // The constructor to initialize the height cache.
  HeightCache({this.estimatedHeight = 100.0, required int totalItems}) {
    for (int index = 1; index <= totalItems; index++) {
      _cumulativeHeights.add(index * estimatedHeight);
    }
  }

  // The function to get the height of the item.
  double getHeight(int index) {
    return _cumulativeHeights[index + 1] - _cumulativeHeights[index];
  }

  // The function to set the height of the item.
  void setHeight({required int currentIndex, required double height}) {
    // fetching the old height of the item.
    double oldHeight =
        _cumulativeHeights[currentIndex + 1] - _cumulativeHeights[currentIndex];

    // calculating the difference between the new and old height.
    double diff = height - oldHeight;

    // if the difference is not 0, we need to update the cumulative heights.
    if (diff != 0) {
      // updating the cumulative heights for the items after the current index.
      // current index + 1 because first item is 0 and items list starts from 1.
      for (
        int index = currentIndex + 1;
        index < _cumulativeHeights.length;
        index++
      ) {
        // updating the cumulative heights for current index and all
        //the items after it.
        _cumulativeHeights[index] += diff;
      }
    }
  }

  // Then function to get the cumulative height from 0
  // to the given index.
  double getCumulativeHeight(int itemIndex) {
    return _cumulativeHeights[itemIndex];
  }

  // The function to get the index of the item at the given offset.
  int getFirstIndexAtOffset({required double offset, required int totalItems}) {
    // binary search to find the index of the item at the given offset.
    // left is the left index of the search range.
    // right is the right index of the search range.
    int left = 0, right = totalItems - 1;

    // while the left index is less than the right index, we need to find the
    // index of the item at the given offset.
    while (left < right) {
      // mid is the middle index of the search range.
      int mid = (left + right) ~/ 2;

      // if the cumulative height at the middle index is less than the offset,
      // we need to search in the right half of the range.
      if (_cumulativeHeights[mid] < offset) {
        left = mid + 1;
        // if the cumulative height at the middle index is greater
        // than or equal to the offset, we need to search in the left half
        //of the range.
      } else {
        right = mid;
      }
    }

    // return the index of the item at the given offset.
    // we subtract 1 because the index is 0-based and the cumulative heights
    // are 1-based.
    return left - 1;
  }

  // The function to get the last index of the item at the given offset.
  // The  last index is the index of the item that will be visible
  // in the viewport.
  // The start index is the first index of the item that is
  // visible in the viewport.
  // The view port height is the height of the viewport.
  // The total items is the total number of items in the list.
  int getLastIndexAtOffset({
    required double offset,
    required double viewPortHeight,
    required int totalItems,
    required int startIndex,
  }) {
    // Get the cumulative height from 0 to the start index.
    double currentPosition = getCumulativeHeight(startIndex);

    // Get the end of the viewport.
    final viewPortEnd = offset + viewPortHeight;

    // Loop through the items and add the height of the item to
    //the cumulative height.
    for (int index = startIndex; index < totalItems; index++) {
      // If the cumulative height is greater than the end of the viewport,
      // return the index.
      if (currentPosition >= viewPortEnd) {
        return index - 1;
      }

      // Add the height of the item to the cumulative height.
      currentPosition += getHeight(index);
    }

    // If the cumulative height is less than the end of the viewport,
    // return the last index.
    return totalItems - 1;
  }

  // The function to get the total height of the items.
  double getTotalHeight(int totalItems) {
    double height = 0;

    // Loop through the items and add the height of the item to
    //the cumulative height.
    for (int index = 0; index < totalItems; index++) {
      height += getHeight(index);
    }

    return height;
  }
}
