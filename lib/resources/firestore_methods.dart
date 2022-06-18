import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // upload post
  Future<String> uploadPost({
    required String description,
    required String username,
    required Uint8List file,
    required String uid,
    required String profileImage,
  }) async {
    String res = 'An error occurred';
    try {
      String photoUrl = await StorageMethods().uploadImageToStorage('posts', file, true);
      
      String postId = const Uuid().v1();

      Post post = Post(
          description: description,
          uid: uid,
          username: username,
          postId: postId,
          datePublished: DateTime.now(),
          postUrl: photoUrl,
          profileImage: profileImage,
          likes: [],
        );

      firestore.collection('posts').doc(postId).set(post.toJson());

      res = 'success';

    } catch (e) {
      res = e.toString();
    }

    return res;
  }
}