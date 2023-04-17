import 'dart:async';
import 'package:flutter/foundation.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

class UserStorage {
  bool _initialized = false;

Future<void> initializeDefault() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    _initialized = true;
  }

bool get isInitialized => _initialized;


Future<void> writeUserInfo(String name, bool metric, int age) async {
    if(!isInitialized){
      await initializeDefault();
    }
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection('users').doc('cins467').set({
      'name': name,
      'metric': metric,
      'age': age,
    }).then((value){
      if (kDebugMode) {
        print('user updated successfully');
      }
    }).catchError((error){
      if (kDebugMode) {
        print('writeUserInfo error: $error');
      }
    });
  }


Future<String> readUsername() async {
    if(!isInitialized){
      await initializeDefault();
    }
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot ds = await firestore.collection('users')
      .doc('cins467')
      .get();
    if(ds.data() != null){
      Map<String, dynamic> data = (ds.data() as Map<String, dynamic>);
      if(data.containsKey('name')){
        return data['name'];
      }
    }
    return 'none';
  }



}