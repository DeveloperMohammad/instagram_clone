import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/add_post_screen.dart';
import 'package:instagram_clone/screens/feed_screen.dart';
import 'package:instagram_clone/screens/home_screen.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/screens/search_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenOptions = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const HomeScreen(),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
];
