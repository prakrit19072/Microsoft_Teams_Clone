import 'package:flutter/material.dart';

import './src/pages/index.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This defines the color of the upper title of our app
        primarySwatch: Colors.red,
      ),
      debugShowCheckedModeBanner: false,
      home: IndexPage(), // the index.dart file /page will be called when the application starts
    );
  }
}
