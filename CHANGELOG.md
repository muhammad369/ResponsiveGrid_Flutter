## [2.0.0-nullsafety.0] - Feb 10, 2021

* Migrate to null safety

- **BREAKING CHANGES:**
    - Properties `desiredItemWidth` and `children` of `ResponsiveGridList` are now set as required

## [1.2.1] - Aug 23, 2020

* `ResponsiveGridList` uses ` ListView.builder` for better performance 

## [1.2.0] - Jun 20, 2020

* added property `ResponsiveGridRow.crossAxisAlignment` default value `CrossAxisAlignment.start`
* added property `ResponsiveGridList.rowMainAxisAlignment` default value `MainAxisAlignment.start`

## [1.1.1] - Nov 19, 2019

* (beta) use the scale() global function to scale font size, margin, padding, width, etc, but you must call initScaling() before

## [1.1.0] - Nov 9, 2019

* you can set the ResponsiveGridList to be rendered as a Column not a List (not scrollable), by setting 'scroll' to false

## [1.0.1] - Jul 28, 2019

* initial release.

