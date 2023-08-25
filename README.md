# responsive_grid

![Pub Version](https://img.shields.io/pub/v/responsive_grid)

Responsive Grid Layout, List and many Utilities for Flutter, to achieve good UI look and feel for different screen sizes

**<<  Help is needed to implement required features by package users, and also to respond to open issues, I don't have much spare time  >>**

## Responsive Grid Layout

With `ResponsiveGridRow` and `ResponsiveGridCol` you can get the same behavior of [bootstrap](https://getbootstrap.com) Grid System

Give every col the width it shall occupy at every size category assuming the total width is 12 (by default)
    
```dart
        ResponsiveGridRow(
          children: [
            ResponsiveGridCol(
              lg: 12,
              child: Container(
                height: 100,
                alignment: Alignment(0, 0),
                color: Colors.purple,
                child: Text("lg : 12"),
              ),
            ),
            ResponsiveGridCol(
              xs: 6,
              md: 3,
              child: Container(
                height: 100,
                alignment: Alignment(0, 0),
                color: Colors.green,
                child: Text("xs : 6 \r\nmd : 3"),
              ),
            ),
            ResponsiveGridCol(
              xs: 6,
              md: 3,
              child: Container(
                height: 100,
                alignment: Alignment(0, 0),
                color: Colors.orange,
                child: Text("xs : 6 \r\nmd : 3"),
              ),
            ),
            ResponsiveGridCol(
              xs: 6,
              md: 3,
              child: Container(
                height: 100,
                alignment: Alignment(0, 0),
                color: Colors.red,
                child: Text("xs : 6 \r\nmd : 3"),
              ),
            ),
            ResponsiveGridCol(
              xs: 6,
              md: 3,
              child: Container(
                height: 100,
                alignment: Alignment(0, 0),
                color: Colors.blue,
                child: Text("xs : 6 \r\nmd : 3"),
              ),
            ),
          ],
        )

```

<img src="https://raw.githubusercontent.com/muhammad369/ResponsiveGrid_Flutter/master/images/1.jpg" width="300">   <img src="https://raw.githubusercontent.com/muhammad369/ResponsiveGrid_Flutter/master/images/2.jpg" height="300">


## Responsive Grid List

`ResponsiveGridList` works differently in that you only specify a desired width for the items and spacing, and it will decide how many items shall fit in a line, and the width of the item and spacing will change (only small change) to fill the entire width

```dart
    ResponsiveGridList(
        desiredItemWidth: 100,
        minSpacing: 10,
        children: List.generate(20, (index)=> index+1).map((i) {
          return Container(
            height: 100,
            alignment: Alignment(0, 0),
            color: Colors.cyan,
            child: Text(i.toString()),
          );
        }).toList()
    )

```

<img src="https://raw.githubusercontent.com/muhammad369/ResponsiveGrid_Flutter/master/images/3.jpg" width="300">   <img src="https://raw.githubusercontent.com/muhammad369/ResponsiveGrid_Flutter/master/images/4.jpg" height="300">

## Responsive Staggered Grid List

The same as the `ResponsiveGridList`, but arranges items in columns inside one big row, so every item has independent height


<img src="https://raw.githubusercontent.com/muhammad369/ResponsiveGrid_Flutter/master/images/5.png" width="500">


## Utilities

`ResponsiveWidget` , `ResponsiveBuilder`, `ResponsiveLayoutBuilder` and `responsiveValue()`

To provide a custom responsive Widget, Builder or a single value, for every size tier

`ResponsiveLocalWidget`, `ResponsiveLocalBuilder` and `ResponsiveLocalLayoutBuilder`

To provide a responsive Widget or Builder for its own width, not the viewport's, they are just wrappers on top of flutter `LayoutBuilder`

**Warning:** make sure not to use any of them inside unbounded width widget, as the width will be read infinity

### ResponsiveWidget and ResponsiveBuilder

To create widgets conditionally for every size tier

### ResponsiveLayoutBuilder

To create different layouts for every size tier, for example put children inside a `Column` for XS and in a `Row` from MD and larger

```dart
ResponsiveLayoutBuilder(
                  xs: (BuildContext context, List<Widget> children) => Column(
                    children: children,
                  ),
                  md: (BuildContext context, List<Widget> children) => Row(
                    children: children,
                  ),
                  children: .....,
                ),
```

### responsiveValue() 

A conditional value on size tier, may be used to achieve any complicated behavior, for example say you have a `GridView` you can make the `crossAxisCount` increase with the width

```dart
GridView.count(
            crossAxisCount: responsiveValue(context, xs: 2, sm: 3, md: 4, lg: 6, xl: 7),
            children: .....
          )
```

Another example you can make a widget visible in small sizes and hidden starting from MD tier

```dart
Visibility(
      visible: responsiveValue(context, xs: true, md: false),
      child: .....)
```

### ResponsiveLocalWidget and ResponsiveLocalBuilder

To create widgets conditionally for each specified available width for it

### ResponsiveLocalLayoutBuilder

To Layout widgets conditionally for each specified available width for them, for example say you want to put children inside a `Column` if available space width is less than 500 and in a `Row` if larger

```dart
ResponsiveLocalLayoutBuilder(configs: [
                  ResponsiveLayoutBuilderConfig(
                    upToWidth: 500,
                    builder: (BuildContext context, List<Widget> children) => Column(
                      children: children,
                    ),
                  ),
                  ResponsiveLayoutBuilderConfig(
                    upToWidth: double.infinity,
                    builder: (BuildContext context, List<Widget> children) => Row(
                      children: children,
                    ),
                  )
                ], children: .....)
```

## Override breakpoints

Add before attaching App widget 

```dart
ResponsiveGridBreakpoints.value = ResponsiveGridBreakpoints(
  xs: 600,
  sm: 905, 
  md: 1240,
  lg: 1440,
);
```
