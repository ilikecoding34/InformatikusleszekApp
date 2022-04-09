import 'package:blog/config/ui_config.dart';
import 'package:blog/models/post_model.dart';
import 'package:blog/services/comment_service.dart';
import 'package:blog/services/post_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewComment extends StatelessWidget {
  const NewComment({
    Key? key,
    required this.newcommentcontroller,
    required this.getpost,
  }) : super(key: key);

  final TextEditingController newcommentcontroller;
  final PostModel getpost;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
          padding: const EdgeInsets.all(10),
          child: TextField(
            minLines: 1,
            maxLines: 5,
            keyboardType: TextInputType.multiline,
            controller: newcommentcontroller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Új hozzászólás',
            ),
          )),
      Container(
          padding: const EdgeInsets.all(10),
          width: 300.0,
          height: 70.0,
          child: ElevatedButton(
              onPressed: () async {
                Map datas = {
                  'userid': 1,
                  'content': newcommentcontroller.text,
                  'postid': getpost.id,
                };
                Provider.of<CommentService>(context, listen: false)
                    .storeComment(datas: datas)
                    .then((value) => {
                          Provider.of<PostService>(context, listen: false)
                              .getPost(id: value)
                        });
                newcommentcontroller.clear();
              },
              child: const Text('Hozzászólás mentése',
                  style: TextStyle(fontSize: UIconfig.mySize))))
    ]);
  }
}
