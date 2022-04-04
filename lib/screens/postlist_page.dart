import 'package:blog/screens/singlepost_page.dart';
import 'package:blog/services/post_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostListScreen extends StatelessWidget {
  PostListScreen({Key? key, required this.title}) : super(key: key);

  String? title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Bejegyzések'),
        ),
        body: Consumer<Postservice>(
          builder: (context, post, child) {
            if (post.postlist.isNotEmpty) {
              return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: post.postlist.length,
                  itemBuilder: (BuildContext context, int index) {
                    var postitem = post.postlist[index];
                    return Container(
                        padding: const EdgeInsets.all(10),
                        height: 80.0,
                        child: ElevatedButton(
                            onPressed: () {
                              Provider.of<Postservice>(context, listen: false)
                                  .getPost(id: index + 1);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SinglePostScreen(
                                        title: postitem.title)),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(postitem.title,
                                    style: const TextStyle(fontSize: 20.0)),
                                Text(postitem.body)
                              ],
                            )));
                  });
            } else {
              return Container();
            }
          },
        ));
  }
}
