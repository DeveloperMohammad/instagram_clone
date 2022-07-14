import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/models/comment.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

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
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);

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

  Future<void> likePost({
    required String postId,
    required String uid,
    required List likes,
  }) async {
    try {
      if (likes.contains(uid)) {
        await firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      log(e.toString());
    }
  }

  //! Like comment
  Future<void> likeComment({
    required String commentId,
    required String postId,
    required String uid,
    required List likes,
  }) async {
    try {
      if (likes.contains(uid)) {
        await firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      log(e.toString());
    }
  }

  //! upload comment
  Future<String> uploadComment({
    required String description,
    required String uid,
    required String username,
    required String profileImage,
    required String postId,
  }) async {
    String res = 'An Error Occurred';

    String commentId = const Uuid().v4();
    DateTime datePublished = DateTime.now();

    try {
      if (description.isNotEmpty) {
        Comment comment = Comment(
          description: description,
          uid: uid,
          username: username,
          commentId: commentId,
          datePublished: datePublished,
          profileImage: profileImage,
          likes: [],
          postId: postId,
        );

        await firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set(comment.toJson());

            res = 'success';
      } else {
        res = 'Text is empty';
      }
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  Future<String> deletePost({
    required String postId,
    required String userId,
  }) async {
    String res = 'An error occurred deleting the post';

    try {
      if (userId == auth.currentUser!.uid) {
        await firestore.collection('posts').doc(postId).delete();
        res = 'success';
      } else {
        res = 'You are now allowed to delete others posts';
      }
    } on FirebaseAuthException catch (e) {
      res = e.code;
    } catch (e) {
      log(e.toString());
      res = e.toString();
    }
    return res;
  }

  Future<void> followUser({
    required String uid,
    required String followId,
  }) async {
    try {
      DocumentSnapshot snap =
          await firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid]),
        });

        await firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId]),
        });
      } else {
        await firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid]),
        });

        await firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId]),
        });
      }
    } catch (e) {
      log('Follow method: $e');
    }
  }

  //! Delete Comment Method
  Future<String> deleteComment({
    required String postId,
    required String userId,
    required String commentId,
  }) async {
    String res = 'An error occurred deleting the post';

    try {
      if (userId == auth.currentUser!.uid) {
        await firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .delete();
        res = 'success';
      } else {
        res = "You are now allowed to delete others' comments";
      }
    } on FirebaseAuthException catch (e) {
      res = e.code;
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
