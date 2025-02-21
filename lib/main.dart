import 'package:flutter/material.dart';
import 'my_home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  // Main Colors are #6491fc, #36a5cd, #36a5cd, #b17cef, #111645
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '1bite2min',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: '1bite2min'),
    );
  }
}




