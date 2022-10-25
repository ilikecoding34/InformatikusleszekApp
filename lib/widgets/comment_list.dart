import 'package:blog/models/post_model.dart';
import 'package:blog/widgets/comment_line.dart';
import 'package:flutter/material.dart';

class CommentList extends StatelessWidget {
  CommentList({
    Key? key,
    required this.show,
    required this.commentheight,
    required this.getpost,
    required this.isloggedin,
  }) : super(key: key);

  final bool show;
  final double commentheight;
  final PostModel getpost;
  final bool isloggedin;

  @override
  Widget build(BuildContext context) {
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
