import 'package:blog/models/comment_model.dart';
import 'package:blog/models/post_model.dart';
import 'package:blog/services/comment_service.dart';
import 'package:blog/services/post_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ModifyComment extends StatelessWidget {
  const ModifyComment({
    Key? key,
    required this.commentlist,
    required this.commentcontroller,
    required this.getpost,
    required this.index,
  }) : super(key: key);

  final List<CommentModel> commentlist;
  final List<TextEditingController> commentcontroller;
  final PostModel getpost;
  final int index;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.save),
        onPressed: () {
          Map datas = {
            'id': commentlist[index].id,
            'content': commentcontroller[index].text,
            'postid': getpost.id,
          };
          Provider.of<CommentService>(context, listen: false)
              .modifyComment(datas: datas)
              .then((value) => Provider.of<PostService>(context, listen: false)
                  .getPost(id: value));
          Provider.of<CommentService>(context, listen: false).changecomment();
        });
  }
}
