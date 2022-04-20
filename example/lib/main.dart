import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  final Widget? homeWidget;

  const MyApp({
    this.homeWidget,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: homeWidget ?? const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: _buildGridList());
  }

  Widget _buildGridList() {
    return ResponsiveGridList(
        rowMainAxisAlignment: MainAxisAlignment.center,
        desiredItemWidth: 100,
        minSpacing: 10,
        children: [
          1,
          2,
          3,
          4,
          5,
          6,
          7,
          8,
          9,
          10,
          11,
          12,
          13,
          14,
          15,
          16,
          17,
          18,
          19,
          20
        ].map((i) {
          return Container(
            height: ((i % 5) + 1) * 100.0,
            alignment: const Alignment(0, 0),
            color: Colors.cyan,
            child: Text(i.toString()),
          );
        }).toList());
  }

  Widget _buildGridLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        ResponsiveGridRow(
          children: [
            ResponsiveGridCol(
              lg: 12,
              child: Container(
                height: 100,
                alignment: const Alignment(0, 0),
                color: Colors.purple,
                child: const Text("lg : 12"),
              ),
            ),
            ResponsiveGridCol(
              xs: 6,
              md: 3,
              child: Container(
                height: 100,
                alignment: const Alignment(0, 0),
                color: Colors.green,
                child: const Text("xs : 6 \r\nmd : 3"),
              ),
            ),
            ResponsiveGridCol(
              xs: 6,
              md: 3,
              child: Container(
                height: 100,
                alignment: const Alignment(0, 0),
                color: Colors.orange,
                child: const Text("xs : 6 \r\nmd : 3"),
              ),
            ),
            ResponsiveGridCol(
              xs: 6,
              md: 3,
              child: Container(
                height: 100,
                alignment: const Alignment(0, 0),
                color: Colors.red,
                child: const Text("xs : 6 \r\nmd : 3"),
              ),
            ),
            ResponsiveGridCol(
              xs: 6,
              md: 3,
              child: Container(
                height: 100,
                alignment: const Alignment(0, 0),
                color: Colors.blue,
                child: const Text("xs : 6 \r\nmd : 3"),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGridLayout_testCrossAlign() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        ResponsiveGridRow(
          children: [
            ResponsiveGridCol(
              xs: 6,
              child: Column(
                children: [
                  Container(
                    height: 100,
                    color: Colors.blue,
                    margin: const EdgeInsets.all(10),
                  ), // height 100px
                  Container(
                    height: 100,
                    color: Colors.blueGrey,
                    margin: const EdgeInsets.all(10),
                  ) // height 100px
                ],
              ),
            ),
            ResponsiveGridCol(
              xs: 6,
              child: Container(
                height: 400,
                color: Colors.black45,
                margin: const EdgeInsets.all(10),
              ), // height 500px
            )
          ],
        ),
      ],
    );
  }
}
