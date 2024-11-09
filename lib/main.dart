import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/entry_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '博森科技',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EntryPage(),
    );
  }
}
