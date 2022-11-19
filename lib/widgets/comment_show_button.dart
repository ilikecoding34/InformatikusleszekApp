import 'package:blog/config/ui_config.dart';
import 'package:blog/models/post_model.dart';
import 'package:blog/widgets/comment_tile.dart';
import 'package:flutter/material.dart';

class CommentShow extends StatelessWidget {
  const CommentShow({
    Key? key,
    required this.getpost,
    required this.isloggedin,
  }) : super(key: key);

  final PostModel getpost;
  final bool isloggedin;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
            style: UIconfig.buttonBasicStyle,
            onPressed: () => showModalBottomSheet<void>(
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  context: context,
                  builder: (BuildContext context) {
                    return SingleChildScrollView(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ...getpost.comments.map((element) {
                          return CommentTile(
                              comment: element, isloggedin: isloggedin);
                        }),
                        Padding(
                            padding: const EdgeInsets.all(10),
                            child: ElevatedButton(
                              child: const Text('Bezár'),
                              onPressed: () => Navigator.pop(context),
                            )),
                      ],
                    ));
                  },
                ),
            child:
                const Text('Hozzászólások', style: TextStyle(fontSize: 15.0)))
      ],
    );
  }
}
