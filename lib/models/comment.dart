import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String description;
  final String uid;
  final String username;
  final String commentId;
  final datePublished;
  final String profileImage;
  final String postId;
  final likes;

  Comment({
    required this.description,
    required this.uid,
    required this.username,
    required this.commentId,
    required this.datePublished,
    required this.profileImage,
    required this.likes,
    required this.postId,
  });

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'uid': uid,
      'username': username,
      'commentId': commentId,
      'datePublished': datePublished,
      'profileImage': profileImage,
      'likes': likes,
      'postId': postId,
    };
  }

  static Comment fromSnapshot(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;
    return Comment(
      description: snap['description'],
      uid: snap['uid'],
      username: snap['username'],
      commentId: snap['postId'],
      datePublished: snap['datePublished'],
      profileImage: snap['profileImage'],
      likes: snap['likes'],
      postId: snap['postId'],
    );
  }
}
