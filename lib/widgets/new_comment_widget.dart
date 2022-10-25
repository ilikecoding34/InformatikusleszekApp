import 'package:blog/config/ui_config.dart';
import 'package:blog/models/post_model.dart';
import 'package:blog/services/comment_service.dart';
import 'package:blog/services/post_service.dart';
import 'package:blog/widgets/input_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewComment extends StatelessWidget {
  NewComment({
    Key? key,
    required this.getpost,
  }) : super(key: key);

  final PostModel getpost;

  TextEditingController newcommentcontroller = TextEditingController();

  storeComment(BuildContext context) {
    Map datas = {
      'content': newcommentcontroller.text,
      'postid': getpost.id,
    };
    CommentService comment =
        Provider.of<CommentService>(context, listen: false);
    PostService post = Provider.of<PostService>(context, listen: false);
    comment
        .storeComment(datas: datas)
        .then((value) => {post.getPost(id: value)});
    newcommentcontroller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        padding: const EdgeInsets.all(10),
        child: InputFieldWidget(
            controller: newcommentcontroller, title: 'Új hozzászólás'),
      ),
      Container(
          padding: const EdgeInsets.all(10),
          child: ElevatedButton(
              style: UIconfig.buttonBasicStyle,
              onPressed: storeComment(context),
              child: const Text('Hozzászólás mentése',
                  style: TextStyle(fontSize: UIconfig.mySize))))
    ]);
  }
}
