import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class UserController extends GetxController {
  var isLoading = false.obs;
  var userData = {}.obs;
  var postLen = 0.obs;
  var followers = 0.obs;
  var following = 0.obs;
  var isFollowing = false.obs;
  var box = Hive.box('details');

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  void getData() async {
    isLoading.value = true;
    print('uniqsdf-${box.get('unique_id')}');
    try {
      var userSnap = FirebaseFirestore.instance
          .collection('users')
          .doc(box.get('unique_id')??'0')
          .snapshots();

      userSnap.listen((userSnapshot) async {
        if (userSnapshot.exists) {
          var postSnap = await FirebaseFirestore.instance
              .collection('posts')
              .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid.toString())
              .get();
        print('lllslkdakljas-${postSnap.docs.length}');
          postLen.value = postSnap.docs.length??10;
          userData.value = userSnapshot.data()!;
          followers.value = userSnapshot.data()!['followers'].length;
          following.value = userSnapshot.data()!['following'].length;
          isFollowing.value = userSnapshot.data()!['followers'].contains(FirebaseAuth.instance.currentUser!.uid);
        }
      });
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
