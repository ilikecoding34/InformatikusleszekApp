import 'package:blog/models/comment_model.dart';
import 'package:blog/services/comment_service.dart';
import 'package:blog/services/post_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeleteComment extends StatelessWidget {
  const DeleteComment({
    Key? key,
    required this.commentlist,
    required this.index,
  }) : super(key: key);

  final List<CommentModel> commentlist;
  final int index;
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          Map datas = {
            'commentid': commentlist[index].id,
            'userid': commentlist[index].userId,
            'postid': commentlist[index].postId
          };
          Provider.of<CommentService>(context, listen: false)
              .deleteComment(datas: datas)
              .then((value) => Provider.of<PostService>(context, listen: false)
                  .getPost(id: value));
        },
        icon: const Icon(Icons.delete));
  }
}
