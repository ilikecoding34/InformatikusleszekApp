import 'package:blog/models/post_model.dart';
import 'package:blog/widgets/comment_list.dart';
import 'package:blog/widgets/comment_show_button.dart';
import 'package:flutter/material.dart';

class CommentListBody extends StatelessWidget {
  const CommentListBody({
    Key? key,
    required this.show,
    required this.commentheight,
    required this.getpost,
    required this.commentcontroller,
    required this.isloggedin,
  }) : super(key: key);

  final bool show;
  final double commentheight;
  final PostModel getpost;
  final List<TextEditingController> commentcontroller;
  final bool isloggedin;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CommentList(
            show: show,
            commentheight: commentheight,
            getpost: getpost,
            commentcontroller: commentcontroller,
            isloggedin: isloggedin),
        CommentShow(show: show)
      ],
    );
  }
}
