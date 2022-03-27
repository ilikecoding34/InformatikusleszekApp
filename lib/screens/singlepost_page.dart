import 'package:blog/services/post_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SinglePostScreen extends StatelessWidget {
  SinglePostScreen({Key? key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Consumer<Postservice>(builder: (context, post, child) {
          if (post.singlepost != null) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(post.singlepost['title'],
                    style: const TextStyle(fontSize: 20.0)),
                Text(post.singlepost['body']),
                const Text('Kommentek:'),
                Expanded(
                    child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: post.singlepost['comments'].length,
                        itemBuilder: (BuildContext context, int index) {
                          var comment = post.singlepost['comments'][index];
                          return Text('${comment['id']}: ${comment['body']}');
                        })),
              ],
            );
          } else {
            return Container();
          }
        }));
  }
}
