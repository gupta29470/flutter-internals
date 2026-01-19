import 'package:flutter/material.dart';
import '01_the_scroll_illusion/dynamic_item_height/step_4_the_viewport/dynamic_virtualized_list.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Dynamic Heights')),
        body: DynamicVirtualizedList(
          itemCount: 100,
          itemBuilder: (context, index) {
            // Variable height items!
            final lines = (index % 5) + 1;
            return Card(
              margin: const EdgeInsets.all(8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Item $index\n' * lines),
              ),
            );
          },
        ),
      ),
    );
  }
}
