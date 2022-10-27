import 'package:blog/models/comment_model.dart';
import 'package:blog/services/comment_service.dart';
import 'package:blog/services/post_service.dart';
import 'package:blog/widgets/input_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentTile extends StatefulWidget {
  const CommentTile({Key? key, required this.comment, required this.isloggedin})
      : super(key: key);
  final CommentModel comment;
  final bool isloggedin;

  @override
  State<CommentTile> createState() => _CommentState();
}

class _CommentState extends State<CommentTile> {
  TextEditingController controller = TextEditingController();
  bool? isEdit;

  late Map datas;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isEdit = false;
    controller.text = widget.comment.body!;
    datas = {
      'id': widget.comment.id,
      'commentid': widget.comment.id,
      'userid': widget.comment.userId,
      'postid': widget.comment.postId
    };
  }

  messageSnackBar(String content) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(content),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: InputFieldWidget(
          enable: isEdit ?? true,
          controller: controller,
          title: '',
        )),
        widget.isloggedin
            ? Row(
                children: [
                  IconButton(
                      onPressed: () => setState(() {
                            isEdit = !isEdit!;
                          }),
                      icon: const Icon(Icons.edit)),
                  IconButton(
                      onPressed: () {
                        isEdit = false;
                        datas['content'] = controller.text;
                        Provider.of<CommentService>(context, listen: false)
                            .modifyComment(datas: datas)
                            .then((value) =>
                                Provider.of<PostService>(context, listen: false)
                                    .getPost(id: value));
                        ScaffoldMessenger.of(context).showSnackBar(
                            messageSnackBar("Mósodítás elmentve"));
                      },
                      icon: const Icon(Icons.save)),
                  IconButton(
                      onPressed: () {
                        Provider.of<CommentService>(context, listen: false)
                            .deleteComment(datas: datas)
                            .then((value) =>
                                Provider.of<PostService>(context, listen: false)
                                    .getPost(id: value));
                        ScaffoldMessenger.of(context)
                            .showSnackBar(messageSnackBar("Komment törölve"));
                      },
                      icon: const Icon(Icons.delete))
                ],
              )
            : const SizedBox.shrink()
      ],
    );
  }
}
