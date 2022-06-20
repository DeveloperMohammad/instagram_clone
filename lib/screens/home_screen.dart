import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/auth_methods.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            AuthMethods().logout();
          },
          child: const Text('Log out'),
        ),
      ),
    );
  }
}