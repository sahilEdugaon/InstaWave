import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Screen/add_post_screen.dart';
import '../Screen/feed_screen.dart';
import '../Screen/profile_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const AddPostScreen(),
  const ProfileScreen(),
];
