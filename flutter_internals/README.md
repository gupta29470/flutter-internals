# Flutter Internals

Rebuilding Flutter's core systems from scratch to understand how they work.

No Slivers. No RenderObjects. Just widgets and first principles.


## Modules

### 01 - The Scroll Illusion
Building a virtualized list from scratch.

**Fixed Height**
- `visible_range.dart` - Calculate first/last visible indices
- `virtualized_list.dart` - Stack + Positioned viewport

**Dynamic Height**
- `height_cache.dart` - Prefix sums for O(1) position lookup
- `dynamic_visible_range.dart` - Binary search for visible indices
- `measuring_size.dart` - Post-frame measurement widget
- `dynamic_virtualized_list.dart` - Complete implementation

**Key Concepts**
- Prefix sums for cumulative heights
- Binary search on sorted arrays
- Post-frame callbacks for measurement
- LayoutBuilder + ScrollController pattern


## Run

```bash
cd flutter_internals
flutter run
```


## Structure

```
lib/
└── 01_the_scroll_illusion/
    ├── fixed_item_height/
    │   ├── step_1_the_math/
    │   └── step_2_the_viewport/
    └── dynamic_item_height/
        ├── step_1_height_cache/
        ├── step_2_dynamic_visible_range/
        ├── step_3_measuring_size/
        └── step_4_the_viewport/
```
