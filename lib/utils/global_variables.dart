import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/add_post_screen.dart';
import 'package:instagram_clone/screens/feed_screen.dart';
import 'package:instagram_clone/screens/home_screen.dart';

const webScreenSize = 600;

const homeScreenOptions = [
  FeedScreen(),
  Center(child: Text('Search')),
  AddPostScreen(),
  Center(child: Text('Favorite')),
  HomeScreen(),
];
