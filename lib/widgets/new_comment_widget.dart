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
            decoration: InputDecoration(
                labelText: 'Új hozzászólás',
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 3, color: Colors.blue),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 3, color: Colors.lime),
                  borderRadius: BorderRadius.circular(15),
                )),
          )),
      Container(
          padding: const EdgeInsets.all(10),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.cyan,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold)),
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
