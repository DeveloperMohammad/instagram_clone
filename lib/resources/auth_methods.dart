import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/models/post.dart';

import 'package:instagram_clone/resources/storage_methods.dart';
import 'package:instagram_clone/models/user.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserInfo() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnapshot(snap);
  }

  // function to sign up user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = 'Some error occurred';
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty &&
          bio.isNotEmpty) {
        // register our user (will be saved in authentication part)
        UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(email: email, password: password);

        log(userCredential.user!.uid);

        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePictures', file, false);

        //! Add user to the database
        model.User user = model.User(
          email: email,
          uid: userCredential.user!.uid,
          photoUrl: photoUrl,
          username: username,
          bio: bio,
          followers: [],
          following: [],
        );

        // save user info in firestore database to later upload in profile
        _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(user.toJson());

        res = 'success';
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'invalid-email') {
        res = 'The email is badly formatted.';
      } else if (error.code == 'weak-password') {
        res = 'Password should be at least 6 characters';
      } else if (error.code == 'email-already-in-use') {
        res = 'There is already an account with this email';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // logging in user
  Future<String> login({
    required String email,
    required String password,
  }) async {
    String res = 'an error occurred';

    try {
      FirebaseAuth auth = FirebaseAuth.instance;

      if (email.isNotEmpty && password.isNotEmpty) {
        await auth.signInWithEmailAndPassword(email: email, password: password);
        res = 'success';
      } else {
        res = 'Email and Password cannot be empty';
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'user-not-found') {
        res = 'There is no user with entered username and password';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // logout
  void logout() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
  }
}
