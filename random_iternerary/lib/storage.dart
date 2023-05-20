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


Future<void> writeUserInfo(String? email, String? password, String? username) async {
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
  await firestore.collection('users').doc(email).set({
    'email': email,
    'password': password,
    'username': username,
  }).then((value){
    if (kDebugMode) {
      print('User added successfully with ID: $email');
    }
  }).catchError((error){
    if (kDebugMode) {
      print('writeUserInfo error: $error');
    }
  });

//create bookmarks collection within the user
firestore.collection('users').doc(email).collection('bookmarks').doc('placeid').set({
    'title': '',
    'address': '',
  }).then((value) {
    if (kDebugMode) {
      print('Bookmark initialized');
    }
  }).catchError((error) {
    if (kDebugMode) {
      print('Error creating Bookmark collection: $error');
    }
  });

  }

Future <void> writeUserBookmark(String? email, String? placeId, String? placeName, String? placeAddress) async{
  if (!isInitialized) {
    await initializeDefault();
  }
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  
  try {
    // Create a reference to the 'bookmarks' collection within the user document
    CollectionReference<Map<String, dynamic>> bookmarksCollection = firestore
        .collection('users')
        .doc(email)
        .collection('bookmarks');

    // Add a new document to the 'bookmarks' collection with the specified place ID
    await bookmarksCollection.doc(placeId).set({
      'title': placeName,
      'address': placeAddress,
    });

    if (kDebugMode) {
      print('User bookmark added $placeName successfully with place ID: $placeId');
    }
  } catch (error) {
    if (kDebugMode) {
      print('Error adding user bookmark: $error');
    }
  }
}

  Future <void> writeUserList(String? email, String? listname, String? jsonString) async{
    if (!isInitialized) {
      await initializeDefault();
    }
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Create a reference to the 'bookmarks' collection within the user document
      CollectionReference<Map<String, dynamic>> listsCollection = firestore
          .collection('users')
          .doc(email)
          .collection('lists');

      // Add a new document to the 'bookmarks' collection with the specified place ID
      await listsCollection.doc(listname).set({
        'jsonString': jsonString,
      });

      if (kDebugMode) {
        print('User list added $listname successfully');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error adding user list: $error');
      }
    }
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