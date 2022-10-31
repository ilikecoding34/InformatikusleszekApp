import 'package:blog/models/post_model.dart';
import 'package:blog/widgets/comment_tile.dart';
import 'package:flutter/material.dart';

class CommentList extends StatelessWidget {
  CommentList({
    Key? key,
    required this.show,
    required this.getpost,
    required this.isloggedin,
  }) : super(key: key);

  final bool show;
  final PostModel getpost;
  final bool isloggedin;

  double commentheight = 0.0;

  @override
  Widget build(BuildContext context) {
    commentheight = getpost.comments.length * 0.1;

    if (commentheight > 0.5) {
      commentheight = 0.5;
    }
    return AnimatedContainer(
        duration: const Duration(seconds: 1),
        height: show ? 0 : (MediaQuery.of(context).size.height * commentheight),
        child: SingleChildScrollView(
          child: Column(children: [
            ...getpost.comments.map((element) {
              return CommentTile(comment: element, isloggedin: isloggedin);
            })
          ]),
        ));
  }
}
