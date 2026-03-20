# Flutter Internals

Rebuilding Flutter's core systems from scratch to understand how they actually work.

No Slivers. No RenderObjects. Just widgets and first principles.

<br>

---

## Episode 01 — The Scroll Illusion

**How does `ListView` only render what's on screen?**

Built a virtualized list from zero — first with fixed heights (simple math), then dynamic heights (prefix sums + binary search + post-frame measurement).

<br>

### Demo

<p align="center">
  <img src="https://raw.githubusercontent.com/gupta29470/flutter-internals/master/flutter_internals/results/01_the_scroll_illusion/fixed_height.gif" width="300" alt="Fixed height virtualized list" />
  &nbsp;&nbsp;&nbsp;
  <img src="https://raw.githubusercontent.com/gupta29470/flutter-internals/master/flutter_internals/results/01_the_scroll_illusion/dynamic_height.gif" width="300" alt="Dynamic height virtualized list" />
</p>

<p align="center">
  <em>Fixed height</em> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <em>Dynamic height</em>
</p>

<br>

### What's inside

```
lib/01_the_scroll_illusion/
├── fixed_item_height/
│   ├── step_1_the_math/
│   │   └── visible_range.dart         → O(1) index calculation via floor/ceil
│   └── step_2_the_viewport/
│       └── virtualized_list.dart       → Stack + Positioned, only visible items exist
│
└── dynamic_item_height/
    ├── step_1_height_cache/
    │   └── height_cache.dart           → Prefix-sum array + binary search (O(log n) lookup)
    ├── step_2_dynamic_visible_range/
    │   └── dynamic_visible_range.dart  → Binary search for first index, linear scan for last
    ├── step_3_measuring_size/
    │   └── measuring_size.dart         → Post-frame callback to measure real rendered height
    └── step_4_the_viewport/
        └── dynamic_virtualized_list.dart → Full implementation: estimate → measure → correct
```

<br>

### Key concepts

| Concept | How it's used |
|---|---|
| **Prefix-sum array** | `HeightCache` stores cumulative heights. O(1) position lookup for any item index. |
| **Binary search** | Find the first visible item at a scroll offset — O(log n) instead of scanning every item. |
| **Post-frame measurement** | `MeasuringSize` uses `addPostFrameCallback` to capture real rendered height, then feeds the diff back into the prefix-sum array. |
| **Estimate → measure → correct** | Dynamic list starts with estimated heights (100px default). As items scroll into view, real heights replace estimates — the list self-corrects. Same pattern Flutter's `SliverList` uses internally. |

<br>

### The trick

Both lists use `SingleChildScrollView` → `SizedBox(height: totalHeight)` → `Stack` with `Positioned` children.

The `SizedBox` creates the full scrollable height (the illusion). Only visible items exist as widgets in the `Stack`. This is essentially `ListView.builder` built from scratch.

**522 lines of Dart. No packages. No shortcuts.**

<br>

---

## Run

```bash
cd flutter_internals
flutter run
```


