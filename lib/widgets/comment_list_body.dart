import 'package:blog/models/post_model.dart';
import 'package:blog/services/post_service.dart';
import 'package:blog/widgets/comment_list.dart';
import 'package:blog/widgets/comment_show_button.dart';
import 'package:blog/widgets/new_comment_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    bool show = Provider.of<PostService>(context, listen: true).getCollapse;
    return Column(
      children: [
        CommentList(show: show, getpost: getpost, isloggedin: isloggedin),
        CommentShow(show: show),
        isloggedin
            ? NewComment(
                getpost: getpost,
              )
            : const SizedBox.shrink()
      ],
    );
  }
}
