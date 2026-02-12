library responsive_grid;

import 'package:flutter/widgets.dart';

//
// responsive grid layout
//

class ResponsiveGridBreakpoints {
  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;

  ResponsiveGridBreakpoints({
    this.xs = 576,
    this.sm = 768,
    this.md = 992,
    this.lg = 1200,
    this.xl = double.infinity,
  });

  static ResponsiveGridBreakpoints value = ResponsiveGridBreakpoints();
}

enum _GridTier { xs, sm, md, lg, xl }

_GridTier _currentSize(BuildContext context) {
  final breakpoints = ResponsiveGridBreakpoints.value;
  final mediaQueryData = MediaQuery.of(context);
  final width = mediaQueryData.size.width;

  if (width < breakpoints.xs) {
    return _GridTier.xs;
  } else if (width < breakpoints.sm) {
    return _GridTier.sm;
  } else if (width < breakpoints.md) {
    return _GridTier.md;
  } else if (width < breakpoints.lg) {
    return _GridTier.lg;
  } else {
    // width >= 1200
    return _GridTier.xl;
  }
}

class ResponsiveGridRow extends StatelessWidget {
  final List<ResponsiveGridCol> children;
  final CrossAxisAlignment crossAxisAlignment;
  final int rowSegments;
  final bool setSameHeightForChildrenInRow = false;

  const ResponsiveGridRow({
    required this.children,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.rowSegments = 12,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];

    int accumulatedWidth = 0;
    var cols = <Widget>[];

    for (var col in children) {
      var colWidth = col.currentConfig(context);
      //
      if (accumulatedWidth + colWidth > rowSegments) {
        if (accumulatedWidth < rowSegments) {
          cols.add(Spacer(
            flex: rowSegments - accumulatedWidth,
          ));
        }

        if(setSameHeightForChildrenInRow){
          rows.add(IntrinsicHeight(
            child: Row(
              crossAxisAlignment: crossAxisAlignment,
              children: cols,
            ),
          ));
        }else{
          rows.add(Row(
            crossAxisAlignment: crossAxisAlignment,
            children: cols,
          ));
        }

        // clear
        cols = <Widget>[];
        accumulatedWidth = 0;
      }
      //
      cols.add(col);
      accumulatedWidth += colWidth;
    }

    if (accumulatedWidth >= 0) {
      if (accumulatedWidth < rowSegments) {
        cols.add(Spacer(
          flex: rowSegments - accumulatedWidth,
        ));
      }
      if(setSameHeightForChildrenInRow){
        rows.add(IntrinsicHeight(
          child: Row(
            crossAxisAlignment: crossAxisAlignment,
            children: cols,
          ),
        ));
      }else{
        rows.add(Row(
          crossAxisAlignment: crossAxisAlignment,
          children: cols,
        ));
      }
    }

    return Column(
      children: rows,
    );
  }
}

class ResponsiveGridCol extends StatelessWidget {
  final _config = [0,0,0,0,0];
  final Widget child;

  ResponsiveGridCol({
    int xs = 12,
    int? sm,
    int? md,
    int? lg,
    int? xl,
    required this.child,
    Key? key,
  }) : super(key: key) {
    _config[_GridTier.xs.index] = xs;
    _config[_GridTier.sm.index] = sm ?? _config[_GridTier.xs.index];
    _config[_GridTier.md.index] = md ?? _config[_GridTier.sm.index];
    _config[_GridTier.lg.index] = lg ?? _config[_GridTier.md.index];
    _config[_GridTier.xl.index] = xl ?? _config[_GridTier.lg.index];
  }

  int currentConfig(BuildContext context) {
    return _config[_currentSize(context).index];
  }

  @override
  Widget build(BuildContext context) {
    final configFlex = currentConfig(context);
    return configFlex == 0
        ? Container()
        : Expanded(
            flex: configFlex,
            child: child,
          );
  }
}

//
// responsive grid list
//

class ResponsiveGridList extends StatelessWidget {
  final double desiredItemWidth, minSpacing;
  final List<Widget> children;
  final bool squareCells, scroll;
  final MainAxisAlignment rowMainAxisAlignment;
  final bool shrinkWrap;
  final ScrollController? controller;
  final ScrollPhysics? physics;

  const ResponsiveGridList({
    required this.desiredItemWidth,
    this.minSpacing = 1,
    this.squareCells = false,
    this.scroll = true,
    required this.children,
    this.rowMainAxisAlignment = MainAxisAlignment.start,
    this.shrinkWrap = false,
    this.controller,
    this.physics,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (children.isEmpty) return Container();

        double width = constraints.maxWidth;

        double N = (width - minSpacing) / (desiredItemWidth + minSpacing);

        int n;
        double spacing, itemWidth;

        if (N % 1 == 0) {
          n = N.floor();
          spacing = minSpacing;
          itemWidth = desiredItemWidth;
        } else {
          if (N >= 2) {
            n = N.floor();
          } else {
            n = 1;
          }

          double dw = width - (n * (desiredItemWidth + minSpacing) + minSpacing);

          itemWidth = desiredItemWidth + (dw / n) * (desiredItemWidth / (desiredItemWidth + minSpacing));

          spacing = (width - itemWidth * n) / (n + 1);
        }

        if (scroll) {
          return ListView.builder(
              controller: controller,
              physics: physics,
              shrinkWrap: shrinkWrap,
              itemCount: (children.length / n).ceil() * 2 - 1,
              itemBuilder: (context, index) {
                //if (index * n >= children.length) return null;
                //separator
                if (index % 2 == 1) {
                  return SizedBox(
                    height: minSpacing,
                  );
                }
                //item
                final rowChildren = <Widget>[];
                index = index ~/ 2;
                for (int i = index * n; i < (index + 1) * n; i++) {
                  if (i >= children.length) break;
                  rowChildren.add(children[i]);
                }
                return _ResponsiveGridListRow(
                  mainAxisAlignment: rowMainAxisAlignment,
                  itemWidth: itemWidth,
                  spacing: spacing,
                  squareCells: squareCells,
                  children: rowChildren,
                );
              });
        } else {
          final rows = <Widget>[];
          rows.add(SizedBox(
            height: minSpacing,
          ));
          //
          for (int j = 0; j < (children.length / n).ceil(); j++) {
            final rowChildren = <Widget>[];
            //
            for (int i = j * n; i < (j + 1) * n; i++) {
              if (i >= children.length) break;
              rowChildren.add(children[i]);
            }
            //
            rows.add(_ResponsiveGridListRow(
              mainAxisAlignment: rowMainAxisAlignment,
              itemWidth: itemWidth,
              spacing: spacing,
              squareCells: squareCells,
              children: rowChildren,
            ));

            rows.add(SizedBox(
              height: minSpacing,
            ));
          }

          return Column(
            children: rows,
          );
        }
      },
    );
  }
}

class _ResponsiveGridListRow extends StatelessWidget {
  final double spacing, itemWidth;
  final List<Widget> children;
  final bool squareCells;
  final MainAxisAlignment mainAxisAlignment;

  const _ResponsiveGridListRow({
    required this.itemWidth,
    required this.spacing,
    required this.squareCells,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: mainAxisAlignment,
      children: _buildChildren(),
    );
  }

  List<Widget> _buildChildren() {
    final list = <Widget>[];

    list.add(SizedBox(
      width: spacing,
    ));

    for (var child in children) {
      list.add(SizedBox(
        width: itemWidth,
        height: squareCells ? itemWidth : null,
        child: child,
      ));
      list.add(SizedBox(
        width: spacing,
      ));
    }

    return list;
  }
}

//
// ResponsiveStaggeredGridList
//

class ResponsiveStaggeredGridList extends StatelessWidget {
  final double desiredItemWidth, minSpacing;
  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;
  final ScrollController? controller;
  final ScrollPhysics? physics;
  final bool scroll;

  const ResponsiveStaggeredGridList({
    required this.desiredItemWidth,
    this.minSpacing = 1,
    required this.children,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.controller,
    this.physics,
    this.scroll = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (children.isEmpty) return Container();

        double width = constraints.maxWidth;

        double N = (width - minSpacing) / (desiredItemWidth + minSpacing);

        int n;
        double spacing, itemWidth;

        if (N % 1 == 0) {
          n = N.floor();
          spacing = minSpacing;
          itemWidth = desiredItemWidth;
        } else {
          if (N >= 2) {
            n = N.floor();
          } else {
            n = 1;
          }

          double dw = width - (n * (desiredItemWidth + minSpacing) + minSpacing);

          itemWidth = desiredItemWidth + (dw / n) * (desiredItemWidth / (desiredItemWidth + minSpacing));

          spacing = (width - itemWidth * n) / (n + 1);
        }

        final List<List<Widget>> colsChildren = [];
        colsChildren.addAll(List.generate(
            n,
            (index) => <Widget>[
                  SizedBox(
                    height: spacing,
                  )
                ]));

        //
        for (int j = 0; j < children.length; j++) {
          final index = j % n;
          colsChildren[index].add(children[j]);
          colsChildren[index].add(SizedBox(
            height: spacing,
          ));
        }

        final cols = <Widget>[];

        cols.add(SizedBox(
          width: spacing,
        ));
        //
        for (int i = 0; i < colsChildren.length; i++) {
          cols.add(SizedBox(
            width: itemWidth,
            child: Column(
              children: colsChildren[i],
            ),
          ));
          cols.add(SizedBox(
            width: spacing,
          ));
        }

        return scroll
            ? SingleChildScrollView(
                physics: physics,
                child: Row(
                  crossAxisAlignment: crossAxisAlignment,
                  children: cols,
                ),
              )
            : Row(
                crossAxisAlignment: crossAxisAlignment,
                children: cols,
              );
      },
    );
  }
}

//
// Utilities
//

/// a widget for certain tier applies also for larger tiers unless overridden, so you must set xs at least
class ResponsiveWidget extends StatelessWidget {
  final Widget? sm, md, lg, xl;
  final Widget xs;

  const ResponsiveWidget({Key? key, this.lg, this.md, this.sm, this.xl, required this.xs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    if (w >= ResponsiveGridBreakpoints.value.lg && xl != null) {
      return xl!;
    }
    if (w >= ResponsiveGridBreakpoints.value.md && lg != null) {
      return lg!;
    }
    if (w >= ResponsiveGridBreakpoints.value.sm && md != null) {
      return md!;
    }
    if (w >= ResponsiveGridBreakpoints.value.xs && sm != null) {
      return sm!;
    }
    return xs;
  }
}

/// a builder for certain tier applies also for larger tiers, so you must set xs at least
class ResponsiveBuilder extends StatelessWidget {
  final Widget child;
  final Function(BuildContext context, Widget child)? sm, md, lg, xl;
  final Function(BuildContext context, Widget child) xs;

  const ResponsiveBuilder({
    Key? key,
    required this.child,
    required this.xs,
    this.sm,
    this.md,
    this.lg,
    this.xl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    if (w >= ResponsiveGridBreakpoints.value.lg && xl != null) {
      return xl!(context, child);
    }
    if (w >= ResponsiveGridBreakpoints.value.md && lg != null) {
      return lg!(context, child);
    }
    if (w >= ResponsiveGridBreakpoints.value.sm && md != null) {
      return md!(context, child);
    }
    if (w >= ResponsiveGridBreakpoints.value.xs && sm != null) {
      return sm!(context, child);
    }
    return xs(context, child);
  }
}

/// a builder for certain tier applies also for larger tiers, so you must set xs at least
class ResponsiveLayoutBuilder extends StatelessWidget {
  final List<Widget> children;
  final Widget Function(BuildContext context, List<Widget> children)? sm, md, lg, xl;
  final Widget Function(BuildContext context, List<Widget> children) xs;

  const ResponsiveLayoutBuilder({
    Key? key,
    required this.children,
    required this.xs,
    this.sm,
    this.md,
    this.lg,
    this.xl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    if (w >= ResponsiveGridBreakpoints.value.lg && xl != null) {
      return xl!(context, children);
    }
    if (w >= ResponsiveGridBreakpoints.value.md && lg != null) {
      return lg!(context, children);
    }
    if (w >= ResponsiveGridBreakpoints.value.sm && md != null) {
      return md!(context, children);
    }
    if (w >= ResponsiveGridBreakpoints.value.xs && sm != null) {
      return sm!(context, children);
    }
    return xs(context, children);
  }
}

/// a value for certain tier applies also for larger tiers unless overridden, so you must set xs at least
T responsiveValue<T>(BuildContext context, {required T xs, T? sm, T? md, T? lg, T? xl}) {
  var w = MediaQuery.of(context).size.width;
  if (w >= ResponsiveGridBreakpoints.value.lg && xl != null) {
    return xl;
  }
  if (w >= ResponsiveGridBreakpoints.value.md && lg != null) {
    return lg;
  }
  if (w >= ResponsiveGridBreakpoints.value.sm && md != null) {
    return md;
  }
  if (w >= ResponsiveGridBreakpoints.value.xs && sm != null) {
    return sm;
  }
  return xs;
}

// local responsive

class ResponsiveWidgetConfig {
  final double upToWidth;
  final Widget child;

  ResponsiveWidgetConfig({required this.upToWidth, required this.child});
}

class ResponsiveBuilderConfig {
  final double upToWidth;
  final Widget Function(BuildContext context, Widget child) builder;

  ResponsiveBuilderConfig({required this.upToWidth, required this.builder});
}

class ResponsiveLocalWidget extends StatelessWidget {
  final List<ResponsiveWidgetConfig> configs;

  /// a widget that changes according to its own width,
  /// the configs are assumed to be provided in ascending order
  ResponsiveLocalWidget({Key? key, required this.configs}) : super(key: key) {
    assert(configs.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.hasInfiniteWidth) {
        print(
          "ResponsiveGrid: Warning, You're using the ResponsiveLocalWidget inside an unbounded width parent, "
          "Your configuration is useless",
        );
      }

      for (var config in configs) {
        if (constraints.maxWidth <= config.upToWidth) {
          return config.child;
        }
      }
      //
      return configs.last.child;
    });
  }
}

class ResponsiveLocalBuilder extends StatelessWidget {
  final List<ResponsiveBuilderConfig> configs;
  final Widget child;

  /// a widget that changes according to its own width,
  /// the configs are assumed to be provided in ascending order
  ResponsiveLocalBuilder({Key? key, required this.configs, required this.child}) : super(key: key) {
    assert(configs.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.hasInfiniteWidth) {
        print(
          "ResponsiveGrid: Warning, You're using the ResponsiveLocalBuilder inside an unbounded width parent, "
          "Your configuration is useless",
        );
      }

      for (var config in configs) {
        if (constraints.maxWidth <= config.upToWidth) {
          return config.builder(context, child);
        }
      }
      //
      return configs.last.builder(context, child);
    });
  }
}

class ResponsiveLayoutBuilderConfig {
  final double upToWidth;
  final Widget Function(BuildContext context, List<Widget> children) builder;

  ResponsiveLayoutBuilderConfig({required this.upToWidth, required this.builder});
}

class ResponsiveLocalLayoutBuilder extends StatelessWidget {
  final List<ResponsiveLayoutBuilderConfig> configs;
  final List<Widget> children;

  /// a widget that changes according to its own width,
  /// the configs are assumed to be provided in ascending order
  ResponsiveLocalLayoutBuilder({Key? key, required this.configs, required this.children}) : super(key: key) {
    assert(configs.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.hasInfiniteWidth) {
        print(
          "ResponsiveGrid: Warning, You're using the ResponsiveLocalLayoutBuilder inside an unbounded width parent, "
          "Your configuration is useless",
        );
      }

      for (var config in configs) {
        if (constraints.maxWidth <= config.upToWidth) {
          return config.builder(context, children);
        }
      }
      //
      return configs.last.builder(context, children);
    });
  }
}
