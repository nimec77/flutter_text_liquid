import 'package:flutter/material.dart';
import 'package:flutter_text_liquid/text_liquid_fill.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(
        body: Center(
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: TextLiquidFill(text: 'LOADING...'),
          ),
        ),
      ),
    );
  }
}
