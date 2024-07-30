
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:social_media/Screen/feed_screen.dart';
import 'package:social_media/responsive/mobile_screen_layout.dart';
import 'package:social_media/utils/colors.dart';

import 'Screen/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  // Add Firebase AppCheck activation
  await FirebaseAppCheck.instance.activate();

  await Hive.initFlutter();
  await Hive.openBox<String>('my_box');
  await Hive.openBox('details');
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var box = Hive.box('details');


    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Instagram Clone',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: mobileBackgroundColor,
      ),
      home:box.get('uname')==null
          ?const LoginScreen()
          :const MobileScreenLayout()
    );
  }


  //  _checkConnectivityAndAuth(context) async {
  //   final connectivityResult = await Connectivity().checkConnectivity();
  //   if (connectivityResult == ConnectivityResult.none) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         backgroundColor: Colors.green,
  //         content: Text('Internet Lost'.toUpperCase(),style: TextStyle(color: Colors.white)),
  //       ),
  //     );
  //     return false;
  //   }
  // }
}

