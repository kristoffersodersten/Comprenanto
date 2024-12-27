import 'package:flutter/material.dart';

class UnknownPage extends StatelessWidget {
  const UnknownPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page Not Found'),
      ),
      body: Center(
        child: Text(
          'The page you are looking for does not exist.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
