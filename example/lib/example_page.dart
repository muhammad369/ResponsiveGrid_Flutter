
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExamplePage extends StatelessWidget{

  final Widget child;
  final String title;

  const ExamplePage({Key? key, required this.child, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title),),
      body: child,
    );
  }

}