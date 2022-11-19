import 'package:blog/models/post_model.dart';
import 'package:blog/widgets/comment_show_button.dart';
import 'package:blog/widgets/new_comment_widget.dart';
import 'package:flutter/material.dart';

class CommentBody extends StatelessWidget {
  const CommentBody({
    Key? key,
    required this.getpost,
    required this.isloggedin,
  }) : super(key: key);

  final PostModel getpost;
  final bool isloggedin;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CommentShow(getpost: getpost, isloggedin: isloggedin),
        isloggedin
            ? NewComment(
                getpost: getpost,
              )
            : const SizedBox.shrink()
      ],
    );
  }
}
