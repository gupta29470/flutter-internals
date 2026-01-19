import 'package:flutter/material.dart';

// Class that measures the size of the child widget.
class MeasuringSize extends StatefulWidget {
  // The child widget to measure the size of.
  final Widget child;

  // The function to call when the size of the child widget changes.
  final void Function(Size size) onSizeChanged;

  const MeasuringSize({
    super.key,
    required this.child,
    required this.onSizeChanged,
  });

  @override
  State<MeasuringSize> createState() => _MeasuringSizeState();
}

class _MeasuringSizeState extends State<MeasuringSize> {
  // The key to the child widget.
  final _key = GlobalKey();

  // The last size of the child widget.
  Size? _lastSize;

  @override
  void initState() {
    super.initState();

    // We can only measure a widget after Flutter lays it out.
    WidgetsBinding.instance.addPostFrameCallback(_measureSize);
  }

  void _measureSize(_) {
    // Get the render box of the child widget.
    final renderBox = _key.currentContext?.findRenderObject() as RenderBox?;
    // If the render box is not null and the size of the child widget
    // has changed, call the onSizeChanged function.
    if (renderBox != null && renderBox.size != _lastSize) {
      // Set the last size of the child widget.
      _lastSize = renderBox.size;
      // Call the onSizeChanged function.
      widget.onSizeChanged(renderBox.size);
    }
  }

  @override
  void didUpdateWidget(covariant MeasuringSize oldWidget) {
    super.didUpdateWidget(oldWidget);

    WidgetsBinding.instance.addPostFrameCallback(_measureSize);
  }

  @override
  Widget build(BuildContext context) {
    // Return a sized box with the key and the child widget.
    return SizedBox(key: _key, child: widget.child);
  }
}
