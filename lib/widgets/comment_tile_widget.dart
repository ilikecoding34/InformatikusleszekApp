import 'package:blog/models/comment_model.dart';
import 'package:blog/models/post_model.dart';
import 'package:blog/services/comment_service.dart';
import 'package:blog/widgets/delete_comment_widget.dart';
import 'package:blog/widgets/modify_comment_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentTile extends StatelessWidget {
  const CommentTile(
      {Key? key,
      required this.commentlist,
      required this.commentcontroller,
      required this.getpost,
      required this.index,
      required this.isEditing,
      required this.isloggedin})
      : super(key: key);

  final bool isEditing;
  final int index;
  final List<CommentModel> commentlist;
  final bool isloggedin;
  final PostModel getpost;
  final List<TextEditingController> commentcontroller;

  @override
  Widget build(BuildContext context) {
    bool edittile = isEditing &&
        Provider.of<CommentService>(context).commentchangeid == index;
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
          isloggedin
              ? DeleteComment(commentlist: commentlist, index: index)
              : Container(),
          isloggedin
              ? isEditing &&
                      Provider.of<CommentService>(context).commentchangeid ==
                          index
                  ? ModifyComment(
                      commentlist: commentlist,
                      commentcontroller: commentcontroller,
                      getpost: getpost,
                      index: index)
                  : IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Provider.of<CommentService>(context, listen: false)
                            .changecomment(index);
                        commentcontroller[index].text =
                            commentlist[index].body.toString();
                      })
              : Container()
        ],
      ),
    );
  }
}
