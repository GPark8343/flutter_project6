import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  static const routeName = '/splash';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
          child: TextButton(
        child: Text('Loading...'),
        onPressed: () {
          Navigator.of(context).pop();
        },
      )),
    );
  }
}
