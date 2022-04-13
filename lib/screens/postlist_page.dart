import 'package:blog/models/post_model.dart';
import 'package:blog/screens/singlepost_page.dart';
import 'package:blog/services/auth_service.dart';
import 'package:blog/services/post_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'login_page.dart';
import 'newpost_page.dart';

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
                ? IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                NewPostPage(pagetitle: 'Új bejegyzés')),
                      );
                    },
                    icon: const Icon(Icons.playlist_add_outlined))
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
              return ListView.separated(
                  separatorBuilder: (context, index) => const Divider(
                        color: Colors.black,
                      ),
                  padding: const EdgeInsets.all(8),
                  itemCount: post.postlist.length,
                  itemBuilder: (BuildContext context, int index) {
                    PostModel postitem = post.postlist[index];
                    return Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0, 4),
                                blurRadius: 5.0)
                          ],
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            stops: const [0.0, 1.0],
                            colors: [
                              Colors.deepPurple.shade400,
                              Colors.deepPurple.shade200,
                            ],
                          ),
                          color: Colors.deepPurple.shade300,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              // elevation: MaterialStateProperty.all(3),
                              shadowColor:
                                  MaterialStateProperty.all(Colors.transparent),
                            ),
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
