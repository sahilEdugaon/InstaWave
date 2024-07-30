import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hive/hive.dart';
import 'package:social_media/resources/storage_methods.dart';
import 'package:string_validator/string_validator.dart' as strval;

import '../model/user.dart' as model;

class AuthMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var box = Hive.box('details');

  final RxMap userDetails = RxMap({});

  // get user details
  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot = await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(documentSnapshot);
  }

  // Signing Up User

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty || file != null) {
        // registering user in auth with email and password
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String photoUrl = await StorageMethods().uploadImageToStorage('profilePics', file, false);
         String created_account = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
        QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("users").get();

        model.User user = model.User(
          username: username,
          uid: cred.user!.uid,
          photoUrl: photoUrl,
          email: email,
          bio: bio,
          uniqueId:(snapshot.docs.length+1).toString() ,
          createdAccount: created_account,
          followers: [],
          following: [],
        );


        // adding user in our database
        await _firestore.collection("users").doc((snapshot.docs.length+1).toString()).set(user.toJson());


        await box.put('uid', cred.user!.uid);
        await box.put('unique_id', (snapshot.docs.length+1).toString());
        await box.put('uname', username);
        await  box.put('email', email);

        res = "success";
      }
      else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  // logging in user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // logging in user with email and password
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        User? currentUser = _auth.currentUser!;
        String uid = currentUser.uid.toString();

        print('uuui0-$uid');
        try {
          var userStream = FirebaseFirestore.instance
              .collection('users')
              .where('uid', isEqualTo: uid)
              .snapshots();

          userStream.listen((snapshot) async {
            if (snapshot.docs.isNotEmpty) {
              var data = snapshot.docs.first.data();
              print('data-$data');

              userDetails.value = data;

              await box.put('uid', data['uid']);
              await box.put('unique_id', data['uniqueId']);
              await box.put('uname', data['username']);
              await box.put('images', data['photoUrl']);
              await box.put('email', data['email']);


              print(['dsfkjdfkj-uni--${box.get('unique_id')}']);
            }
          });

        } catch (e) {
          Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
        }

        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
   // await _auth.signOut();
    await box.clear();
  }
}
