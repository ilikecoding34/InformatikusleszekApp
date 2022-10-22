import 'package:blog/models/comment_model.dart';
import 'package:blog/models/post_model.dart';
import 'package:blog/services/comment_service.dart';
import 'package:blog/services/post_service.dart';
import 'package:blog/widgets/comment_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentTile extends StatelessWidget {
  CommentTile(
      {Key? key,
      required this.commentlist,
      required this.getpost,
      required this.index,
      required this.isloggedin})
      : super(key: key);

  final int index;
  final List<CommentModel> commentlist;
  final bool isloggedin;
  final PostModel getpost;

  TextEditingController commentcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CommentService comment = Provider.of<CommentService>(context);
    bool isCommentEdit = comment.commentedit;
    bool edittile = isCommentEdit && comment.commentchangeid == index;
    Map datas = {
      'id': commentlist[index].id,
      'userid': commentlist[index].userId,
      'postid': commentlist[index].postId
    };

    if (edittile) {
      commentcontroller.text = commentlist[index].body!;
    }

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
                  controller: commentcontroller,
                  onChanged: (val) {
                    datas['content'] = val;
                  },
                ))
              : Flexible(
                  child: Text(
                  '${commentlist[index].body}',
                  style: const TextStyle(fontSize: 15.0),
                  textAlign: TextAlign.center,
                )),
          if (isloggedin) ...[
            CommentIconButton(icon: Icons.delete, datas: datas, type: 'delete'),
            isCommentEdit && comment.commentchangeid == index
                ? CommentIconButton(
                    icon: Icons.save, datas: datas, type: 'modify')
                : CommentIconButton(
                    icon: Icons.edit,
                    type: 'change',
                    index: index,
                  )
          ] else
            const SizedBox.shrink(),
        ],
      ),
    );
  }
}
