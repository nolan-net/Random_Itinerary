//This page will diplay the current surface information of the logged in user
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {

  const ProfilePage({Key? key}) : super(key: key);

  @override
   Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lists'),
      ),
      body: Center(
        child: Text(
          'Profile info goes here',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}