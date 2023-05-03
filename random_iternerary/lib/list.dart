import 'package:flutter/material.dart';

class ListPage extends StatelessWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lists'),
      ),
      body: Center(
        child: Text(
          'Created lists go here',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}