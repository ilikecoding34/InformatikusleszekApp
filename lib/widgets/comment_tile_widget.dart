import 'package:blog/models/comment_model.dart';
import 'package:blog/models/post_model.dart';
import 'package:blog/services/comment_service.dart';
import 'package:blog/services/post_service.dart';
import 'package:blog/services/sharedpreferences_service.dart';
import 'package:blog/widgets/comment_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentTile extends StatelessWidget {
  const CommentTile(
      {Key? key,
      required this.commentlist,
      required this.commentcontroller,
      required this.getpost,
      required this.index,
      required this.isloggedin})
      : super(key: key);

  final int index;
  final List<CommentModel> commentlist;
  final bool isloggedin;
  final PostModel getpost;
  final List<TextEditingController> commentcontroller;

  Future changeActionButton(BuildContext context) async {
    Provider.of<CommentService>(context, listen: false).changecomment(index);
    commentcontroller[index].text = commentlist[index].body.toString();
  }

  @override
  Widget build(BuildContext context) {
    CommentService comment = Provider.of<CommentService>(context);
    bool isCommentEdit = comment.commentedit;
    bool edittile = isCommentEdit && comment.commentchangeid == index;
    Map datas = {
      'commentid': commentlist[index].id,
      'userid': commentlist[index].userId,
      'postid': commentlist[index].postId
    };
    Future deleteAction = Provider.of<CommentService>(context, listen: false)
        .deleteComment(datas: datas)
        .then((value) => Provider.of<PostService>(context, listen: false)
            .getPost(id: value));

    Future modifyAction = Provider.of<CommentService>(context, listen: false)
        .modifyComment(datas: datas)
        .then((value) => Provider.of<PostService>(context, listen: false)
            .getPost(id: value));
    Future changeAction = changeActionButton(context);
    return Container(
      decoration: BoxDecoration(
        color: edittile ? Colors.blueGrey : Colors.grey,
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          edittile
              ? Flexible(
                  child: TextField(
                  minLines: 1,
                  maxLines: 5,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 3, color: Colors.blue),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 3, color: Colors.lime),
                        borderRadius: BorderRadius.circular(15),
                      )),
                  controller: commentcontroller[index],
                ))
              : Flexible(
                  child: Text(
                  '${commentlist[index].body}',
                  style: const TextStyle(fontSize: 15.0),
                  textAlign: TextAlign.center,
                )),
          if (isloggedin) ...[
            CommentIconButton(
                icon: Icons.delete, datas: datas, action: deleteAction),
            isCommentEdit && comment.commentchangeid == index
                ? CommentIconButton(
                    icon: Icons.save, datas: datas, action: modifyAction)
                : CommentIconButton(icon: Icons.edit, action: changeAction)
          ] else
            const SizedBox.shrink(),
        ],
      ),
    );
  }
}
