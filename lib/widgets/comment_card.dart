import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentCard extends StatefulWidget {
  const CommentCard({Key? key, required this.snap}) : super(key: key);

  final snap;

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).user;

    return ListTile(
      leading: CircleAvatar(
        radius: 18,
        backgroundImage: NetworkImage(
          widget.snap['profileImage'],
        ),
      ),
      title: Text(widget.snap['username']),
      subtitle: Text(widget.snap['description']),
      trailing: FittedBox(
        child: Column(
          children: [
            Text(
              DateFormat('MMM dd, yyyy HH:mm').format(
                widget.snap['datePublished'].toDate(),
              ),
            ),
            Row(
              children: [
                Text('${widget.snap['likes'].length}'),
                LikeAnimation(
                  isAnimating: widget.snap['likes'].contains(user.uid),
                  child: IconButton(
                    onPressed: () {
                      FirestoreMethods().likeComment(
                        commentId: widget.snap['commentId'],
                        postId: widget.snap['postId'],
                        uid: user.uid,
                        likes: widget.snap['likes'],
                      );
                    },
                    icon: widget.snap['likes'].contains(user.uid)
                        ? const Icon(Icons.favorite, color: Colors.red)
                        : const Icon(Icons.favorite_border),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
