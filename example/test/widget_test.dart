// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:responsive_grid/responsive_grid.dart';

import '../lib/main.dart';

void main() {
  testWidgets('gridlist test', (WidgetTester tester) async {
    // test grid list
    await tester.pumpWidget(MyApp(homeWidget: _buildGridList()));

    for(int i = 1; i <= 20; i ++) {
      await tester.scrollUntilVisible(find.text('$i'), 10);
    }
  });

  testWidgets('gridlayout test', (WidgetTester tester) async {
    // test grid list
    await tester.pumpWidget(MyApp(homeWidget: _buildGridLayout()));

    // expect no exceptions

  });
}


Widget _buildGridList() {
  return ResponsiveGridList(
      rowMainAxisAlignment: MainAxisAlignment.start,

      desiredItemWidth: 100,
      //squareCells: true,
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
          height: ((i%5) +1) * 100.0,
          alignment: Alignment(0, 0),
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
      ),
    ],
  );
}