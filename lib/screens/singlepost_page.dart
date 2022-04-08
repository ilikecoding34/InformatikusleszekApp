import 'package:blog/config/ui_config.dart';
import 'package:blog/models/comment_model.dart';
import 'package:blog/models/post_model.dart';
import 'package:blog/services/auth_service.dart';
import 'package:blog/services/comment_service.dart';
import 'package:blog/services/post_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'login_page.dart';

class SinglePostScreen extends StatelessWidget {
  SinglePostScreen({Key? key, required this.title});

  final String title;
  TextEditingController titlecontroller = TextEditingController();

  String? datas;

  _launchURL(String url) async {
    if (!await launch(
      url,
      forceSafariVC: true,
      forceWebView: true,
      enableJavaScript: true,
    )) throw 'Could not launch';
  }

  @override
  Widget build(BuildContext context) {
    bool isloggedin =
        Provider.of<AuthService>(context, listen: true).authenticated;
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: [
            IconButton(
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
        body: Consumer<PostService>(builder: (context, post, child) {
          if (post.singlepost != null) {
            bool show = Provider.of<PostService>(context).collapse;
            PostModel? getpost = post.singlepost;
            List<CommentModel>? commentlist = [];
            for (var com in getpost!.comments ?? commentlist) {
              commentlist.add(CommentModel.fromJson(com));
            }

            return SingleChildScrollView(
                reverse: true,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        padding: const EdgeInsets.all(10),
                        child: Text(getpost.title,
                            style: const TextStyle(fontSize: 30.0))),
                    Visibility(
                      child: Container(
                          padding: const EdgeInsets.all(10),
                          child: ElevatedButton(
                              onPressed: () => _launchURL(getpost.link ?? ''),
                              child: const Text('Link megnyitása'))),
                      visible: getpost.link != null,
                    ),
                    Container(
                        padding: const EdgeInsets.all(10),
                        child: Text(getpost.body,
                            style: const TextStyle(fontSize: 20.0))),
                    commentlist.isNotEmpty
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  padding: const EdgeInsets.all(10),
                                  child: const Text('Kommentek:',
                                      style: TextStyle(fontSize: 15.0))),
                              ElevatedButton(
                                  onPressed: () => Provider.of<PostService>(
                                          context,
                                          listen: false)
                                      .changecollapse(),
                                  child: show
                                      ? const Text('Kinyit')
                                      : const Text('Összecsuk'))
                            ],
                          )
                        : Container(),
                    commentlist.isNotEmpty
                        ? AnimatedContainer(
                            duration: const Duration(seconds: 1),
                            height: show ? 0 : 300,
                            child: ListView.separated(
                                separatorBuilder: (context, index) =>
                                    const Divider(
                                      color: Colors.black,
                                    ),
                                padding: const EdgeInsets.all(8),
                                shrinkWrap: true,
                                itemCount: commentlist.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Flexible(
                                            child: Text(
                                          '${commentlist[index].body}',
                                          style:
                                              const TextStyle(fontSize: 15.0),
                                          textAlign: TextAlign.center,
                                        )),
                                        isloggedin
                                            ? IconButton(
                                                onPressed: () {
                                                  Map datas = {
                                                    'commentid':
                                                        commentlist[index].id,
                                                    'userid': commentlist[index]
                                                        .userId,
                                                    'postid': commentlist[index]
                                                        .postId
                                                  };
                                                  Provider.of<CommentService>(
                                                          context,
                                                          listen: false)
                                                      .deleteComment(
                                                          datas: datas)
                                                      .then((value) => Provider
                                                              .of<PostService>(
                                                                  context,
                                                                  listen: false)
                                                          .getPost(id: value));
                                                },
                                                icon: Icon(Icons.delete))
                                            : Container()
                                      ],
                                    ),
                                  );
                                }))
                        : Container(),
                    isloggedin
                        ? Column(children: [
                            Container(
                                padding: const EdgeInsets.all(10),
                                child: TextField(
                                  minLines: 1,
                                  maxLines: 5,
                                  keyboardType: TextInputType.multiline,
                                  controller: titlecontroller,
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
                                        'content': titlecontroller.text,
                                        'postid': getpost.id,
                                      };
                                      Provider.of<CommentService>(context,
                                              listen: false)
                                          .storeComment(datas: datas)
                                          .then((value) => {
                                                Provider.of<PostService>(
                                                        context,
                                                        listen: false)
                                                    .getPost(id: value)
                                              });
                                      titlecontroller.clear();
                                    },
                                    child: const Text('Hozzászólás mentése',
                                        style: TextStyle(
                                            fontSize: UIconfig.mySize))))
                          ])
                        : Container()
                  ],
                ));
          } else {
            return Container();
          }
        }));
  }
}
