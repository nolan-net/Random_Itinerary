import'dart:async';
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


Future<void> writeUserInfo(String? username, String? password, String? email) async {
    if(!isInitialized){
      await initializeDefault();
    }
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    QuerySnapshot querySnapshot = await firestore.collection('users')
      .where('email', isEqualTo: email)
      .get();
  if(querySnapshot.size > 0){
    print('Error: User with email $email already exists');
    return;
  }

  // Create a new document with the given username, email and password
  await firestore.collection('users').add({
    'email': email,
    'password': password,
    'username': username,
  }).then((value){
    if (kDebugMode) {
      print('User added successfully with ID: ${value.id}');
    }
  }).catchError((error){
    if (kDebugMode) {
      print('writeUserInfo error: $error');
    }
  });
  }

Future <bool?> checkAccount(String? value) async{

  FirebaseFirestore firestore = FirebaseFirestore.instance;
               QuerySnapshot querySnapshot = await firestore.collection('users')
                .where('email', isEqualTo: value)
               .get();

                if (querySnapshot.size == 0) {
                  print('This email does not exist in our records. Please enter a valid email');
                  return false;
                }
}

Future<String> readUsername() async {
    if(!isInitialized){
      await initializeDefault();
    }
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot ds = await firestore.collection('users')
      .doc('6A3nN0DyOsanSsWcSl7M')
      .get();
    if(ds.data() != null){
      Map<String, dynamic> data = (ds.data() as Map<String, dynamic>);
      if(data.containsKey('name')){
        return data['name'];
      }
    }
    return 'none';
  }
}//END USER STORAGE