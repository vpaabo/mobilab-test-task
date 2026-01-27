import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink, //Color.fromRGBO(255, 100, 178, 1),
          title: const Text("tere"),
        ),
        body: Center(child: Padding(padding: EdgeInsets.all(100), child: const Text("tere"))),
      ),
    );
  }
}
