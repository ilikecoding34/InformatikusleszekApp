import 'package:blog/services/comment_service.dart';
import 'package:blog/services/post_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentIconButton extends StatelessWidget {
  const CommentIconButton(
      {Key? key,
      required this.icon,
      this.datas,
      this.index,
      required this.type})
      : super(key: key);

  final Map? datas;
  final String type;
  final IconData icon;
  final int? index;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(icon),
        onPressed: () {
          switch (type) {
            case 'delete':
              Provider.of<CommentService>(context, listen: false)
                  .deleteComment(datas: datas!)
                  .then((value) =>
                      Provider.of<PostService>(context, listen: false)
                          .getPost(id: value));
              break;
            case 'modify':
              Provider.of<CommentService>(context, listen: false)
                  .modifyComment(datas: datas!)
                  .then((value) =>
                      Provider.of<PostService>(context, listen: false)
                          .getPost(id: value));
              break;
            case 'change':
              Provider.of<CommentService>(context, listen: false)
                  .changecomment(index!);

              break;
            default:
          }
        });
  }
}
