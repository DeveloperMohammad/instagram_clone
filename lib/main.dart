import 'package:flutter/material.dart';
import 'package:instagram/utils/colors.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: mobileBackgroundColor,
      ),
      home: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Wow! Hot reload works now just fine and fast'),
      ),
    );
  }
}

