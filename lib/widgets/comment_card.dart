import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentCard extends StatefulWidget {
  const CommentCard({Key? key, required this.snap}) : super(key: key);

  final snap;

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  void deleteComment() async {
    try {
      final res = await FirestoreMethods().deleteComment(
        commentId: widget.snap['commentId'],
        postId: widget.snap['postId'],
        userId: widget.snap['uid'],
      );

      showSnackBar(res, context);
    } catch (e) {
      showSnackBar('$e', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).user;

    DateTime commentDate = widget.snap['datePublished'].toDate();

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 18,
        horizontal: 16,
      ),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.snap['profileImage']),
                radius: 18,
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${widget.snap['username']} ',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: widget.snap['description'],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FittedBox(
                        child: Text(
                          commentDate.isBefore(DateTime.now()
                                  .subtract(const Duration(days: 4)))
                              ? DateFormat.yMMMd().format(commentDate)
                              : timeago.format(
                                  commentDate,
                                  locale: 'en_short',
                                ),
                        ),
                      ),

                      FittedBox(
                        child: Text('${widget.snap['likes'].length} likes'),
                      ),

                      IconButton(
                        onPressed: () {
                          deleteComment();
                        },
                        icon: const FittedBox(
                          child: Text('delete'),
                        ),
                      ),

                      const SizedBox(width: 20),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                child: LikeAnimation(
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}
