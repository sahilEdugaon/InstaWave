import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hive/hive.dart';
import 'package:social_media/Screen/profile_screen_controlller.dart';

import '../resources/auth_methods.dart';
import '../utils/colors.dart';
import '../utils/utils.dart';
import '../widgets/follow_button.dart';
import 'login.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserController userController = Get.put(UserController());
  var box = Hive.box('details');

  @override
  void initState() {
    super.initState();
    userController.getData();
  }

  @override
  Widget build(BuildContext context) {
    print('uniqsdf-${box.get('unique_id')}');
    print('uniqsdf-${AuthMethods().userDetails}');

    return Obx(() {
      return userController.isLoading.value
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Scaffold(
              appBar: AppBar(
                backgroundColor: mobileBackgroundColor,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      userController.userData['username'] ?? "",
                    ),
                    IconButton(
                      onPressed: () async {
                        bool shouldLogout = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Logout'),
                              content: Text('Are you sure you want to logout?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(false); // User chose not to logout
                                  },
                                  child: Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(true); // User chose to logout
                                  },
                                  child: Text('Logout'),
                                ),
                              ],
                            );
                          },
                        );

                        if (shouldLogout) {
                          await AuthMethods().signOut();
                          if (context.mounted) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(
                                'Logout successfully'.toUpperCase(),
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.logout_rounded),
                      tooltip: 'Logout',
                    )
                  ],
                ),
                centerTitle: false,
              ),
              body: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: 40,
                              child: ClipOval(
                                child: Image.network(
                                  userController.userData['photoUrl'] ?? "",
                                  fit: BoxFit.cover,
                                  width: 80,
                                  height: 80,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    } else {
                                      return const Center(
                                        child: Icon(
                                          Icons
                                              .person, // Use any icon you prefer
                                          size: 40,
                                          color: Colors.white,
                                        ),
                                      );
                                    }
                                  },
                                  errorBuilder: (BuildContext context,
                                      Object error, StackTrace? stackTrace) {
                                    return const Center(
                                      child: Icon(
                                        Icons.person, // Use any icon you prefer
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      buildStatColumn(
                                          userController.postLen.value,
                                          "posts"),
                                      buildStatColumn(
                                          userController.followers.value,
                                          "followers"),
                                      buildStatColumn(
                                          userController.following.value,
                                          "following"),
                                    ],
                                  ),

                                  // Row(
                                  //   children: [
                                  //     Expanded(
                                  //       child: FollowButton(
                                  //         text: 'Unfollow',
                                  //         backgroundColor: Colors.white,
                                  //         textColor: Colors.black,
                                  //         borderColor: Colors.grey,
                                  //         function: () async {
                                  //           // await FireStoreMethods()
                                  //           //     .followUser(
                                  //           //   FirebaseAuth.instance
                                  //           //       .currentUser!.uid,
                                  //           //   userData['uid'],
                                  //           // );
                                  //           //
                                  //           // setState(() {
                                  //           //   isFollowing = false;
                                  //           //   followers--;
                                  //           // });
                                  //         },
                                  //       ),
                                  //     ),
                                  //     Expanded(
                                  //       child: FollowButton(
                                  //         text: 'Follow',
                                  //         backgroundColor: Colors.blue,
                                  //         textColor: Colors.white,
                                  //         borderColor: Colors.blue,
                                  //         function: () async {
                                  //           // await FireStoreMethods()
                                  //           //     .followUser(
                                  //           //   FirebaseAuth.instance
                                  //           //       .currentUser!.uid,
                                  //           //   userData['uid'],
                                  //           // );
                                  //           //
                                  //           // setState(() {
                                  //           //   isFollowing = true;
                                  //           //   followers++;
                                  //           // });
                                  //         },
                                  //       ),
                                  //     )
                                  //     // FirebaseAuth.instance.currentUser!.uid.toString() == userController.userData['uid'].toString()
                                  //     //     ? Expanded(
                                  //     //       child: FollowButton(
                                  //     //   text: 'Sign Out',
                                  //     //   backgroundColor:
                                  //     //   mobileBackgroundColor,
                                  //     //   textColor: primaryColor,
                                  //     //   borderColor: Colors.grey,
                                  //     //   function: () async {
                                  //     //       await AuthMethods().signOut();
                                  //     //       if (context.mounted) {
                                  //     //         Navigator.of(context)
                                  //     //             .pushReplacement(
                                  //     //           MaterialPageRoute(
                                  //     //             builder: (context) =>
                                  //     //                 const LoginScreen(),
                                  //     //           ),
                                  //     //         );
                                  //     //       }
                                  //     //       ScaffoldMessenger.of(context).showSnackBar(
                                  //     //         SnackBar(
                                  //     //           backgroundColor: Colors.red,
                                  //     //           content: Text('Logout successfully'.toUpperCase(),style: TextStyle(color: Colors.white),textAlign: TextAlign.center),
                                  //     //         ),
                                  //     //       );
                                  //     //   },
                                  //     // ),
                                  //     //     )
                                  //     //     : userController.isFollowing.value
                                  //     //     ? FollowButton(
                                  //     //   text: 'Unfollow',
                                  //     //   backgroundColor: Colors.white,
                                  //     //   textColor: Colors.black,
                                  //     //   borderColor: Colors.grey,
                                  //     //   function: () async {
                                  //     //     // await FireStoreMethods()
                                  //     //     //     .followUser(
                                  //     //     //   FirebaseAuth.instance
                                  //     //     //       .currentUser!.uid,
                                  //     //     //   userData['uid'],
                                  //     //     // );
                                  //     //     //
                                  //     //     // setState(() {
                                  //     //     //   isFollowing = false;
                                  //     //     //   followers--;
                                  //     //     // });
                                  //     //   },
                                  //     // )
                                  //     //     : FollowButton(
                                  //     //   text: 'Follow',
                                  //     //   backgroundColor: Colors.blue,
                                  //     //   textColor: Colors.white,
                                  //     //   borderColor: Colors.blue,
                                  //     //   function: () async {
                                  //     //     // await FireStoreMethods()
                                  //     //     //     .followUser(
                                  //     //     //   FirebaseAuth.instance
                                  //     //     //       .currentUser!.uid,
                                  //     //     //   userData['uid'],
                                  //     //     // );
                                  //     //     //
                                  //     //     // setState(() {
                                  //     //     //   isFollowing = true;
                                  //     //     //   followers++;
                                  //     //     // });
                                  //     //   },
                                  //     // )
                                  //   ],
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(
                            top: 15,
                          ),
                          child: Text(
                            userController.userData['username'] ?? "",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(
                            top: 1,
                          ),
                          child: Text(
                            userController.userData['bio'] ?? "",
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: Colors.white, height: 1),
                  FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('posts')
                        .where('uid', isEqualTo: box.get('uid').toString())
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return (snapshot.data! as dynamic).docs.length >= 1
                          ? GridView.builder(
                              shrinkWrap: true,
                              itemCount:
                                  (snapshot.data! as dynamic).docs.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 1.5,
                                childAspectRatio: 1,
                              ),
                              itemBuilder: (context, index) {
                                DocumentSnapshot snap =
                                    (snapshot.data! as dynamic).docs[index];
                                return SizedBox(
                                  child: Image(
                                    image: NetworkImage(snap['postUrl']),
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.only(top: 150),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.camera_alt_outlined, size: 50),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      'No Post Yet',
                                      style: TextStyle(fontSize: 27),
                                    )
                                  ],
                                ),
                              ),
                            );
                    },
                  )
                ],
              ),
            );
    });
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
