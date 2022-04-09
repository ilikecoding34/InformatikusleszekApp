import 'package:blog/models/post_model.dart';
import 'package:blog/screens/singlepost_page.dart';
import 'package:blog/services/auth_service.dart';
import 'package:blog/services/post_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'login_page.dart';

class PostListScreen extends StatelessWidget {
  PostListScreen({Key? key, required this.title}) : super(key: key);

  String? title;

  @override
  Widget build(BuildContext context) {
    bool isloggedin =
        Provider.of<AuthService>(context, listen: true).authenticated;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Bejegyzések'),
          actions: [
            isloggedin
                ? Container(
                    padding: const EdgeInsets.all(10),
                    child: const Icon(Icons.check))
                : IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                    icon: const Icon(Icons.login))
          ],
        ),
        body: Consumer<PostService>(
          builder: (context, post, child) {
            if (post.postlist.isNotEmpty) {
              return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: post.postlist.length,
                  itemBuilder: (BuildContext context, int index) {
                    PostModel postitem = post.postlist[index];
                    return Container(
                        padding: const EdgeInsets.all(10),
                        height: 80.0,
                        child: ElevatedButton(
                            onPressed: () {
                              Provider.of<PostService>(context, listen: false)
                                  .collapse = true;
                              Provider.of<PostService>(context, listen: false)
                                  .getPost(id: postitem.id);
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
                              ],
                            )));
                  });
            } else {
              return CircularProgressIndicator(value: null);
            }
          },
        ));
  }
}
