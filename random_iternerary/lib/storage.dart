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
    'Schedule': [],
  }).then((value){
    if (kDebugMode) {
      print('User added successfully with ID: $email');
    }
  }).catchError((error){
    if (kDebugMode) {
      print('writeUserInfo error: $error');
    }
  });
  }

Future <void> writeUserBookmark(String? email, String? placeid) async{
  if (!isInitialized) {
    await initializeDefault();
  }
  
//THIS FUNCTION W+IS SUPPOSED TO WRITE BOOKMARKS TO THE
  //SCHEDULE ARRAY
  //SOME WACKY STUFF WILL TAKE PLACE HERE SINCE THE .ADD FUNCTION DOESNT
  //WORK WITH STRINGS RAAAAAAAAAAAAAAAAA

}


/* 
if(!isInitialized){
      await initializeDefault();
    }
    FirebaseFirestore firestore = FirebaseFirestore.instance;


    if(querySnapshot.exists){
      await firestore.collection('users').doc(email).update({
        'Schedule': placeid, 
      });
    }else{ 
      print("User not within system");
    }

}
*/


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