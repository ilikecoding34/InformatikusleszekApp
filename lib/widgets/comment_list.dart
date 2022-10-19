import 'package:blog/models/post_model.dart';
import 'package:blog/widgets/comment_tile_widget.dart';
import 'package:flutter/material.dart';

class CommentList extends StatelessWidget {
  const CommentList({
    Key? key,
    required this.show,
    required this.commentheight,
    required this.getpost,
    required this.commentcontroller,
    required this.isloggedin,
  }) : super(key: key);

  final bool show;
  final double commentheight;
  final PostModel getpost;
  final List<TextEditingController> commentcontroller;
  final bool isloggedin;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: const Duration(seconds: 1),
        height: show ? 0 : (MediaQuery.of(context).size.height * commentheight),
        child: ListView.separated(
            separatorBuilder: (context, index) => const Divider(
                  color: Colors.black,
                ),
            padding: const EdgeInsets.all(8),
            shrinkWrap: true,
            primary: false,
            itemCount: getpost.comments.length,
            itemBuilder: (BuildContext context, int index) {
              TextEditingController comedit = TextEditingController();
              commentcontroller.add(comedit);
              return CommentTile(
                  commentlist: getpost.comments,
                  commentcontroller: commentcontroller,
                  getpost: getpost,
                  index: index,
                  isloggedin: isloggedin);
            }));
  }
}
