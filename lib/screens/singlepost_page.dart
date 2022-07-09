import 'package:blog/models/post_model.dart';
import 'package:blog/screens/editpost_page.dart';
import 'package:blog/services/auth_service.dart';
import 'package:blog/services/comment_service.dart';
import 'package:blog/services/post_service.dart';
import 'package:blog/widgets/comment_tile_widget.dart';
import 'package:blog/widgets/new_comment_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'login_page.dart';

class SinglePostScreen extends StatelessWidget {
  SinglePostScreen({required this.title});

  final String title;
  TextEditingController posttitlecontroller = TextEditingController();
  TextEditingController postbodycontroller = TextEditingController();
  TextEditingController postlinkcontroller = TextEditingController();
  TextEditingController newcommentcontroller = TextEditingController();
  List<TextEditingController> commentcontroller = [];

  List<dynamic> taglist = [];

  List<int> selected = [];

  String? datas;

  Map postdatas = {};

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
    bool isloggedin = Provider.of<AuthService>(context).authenticated;
    PostModel? getpost = Provider.of<PostService>(context).singlepost;
    taglist = Provider.of<PostService>(context, listen: true).getAllTags;
    selected = Provider.of<PostService>(context, listen: true).getSelectedTags;
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Provider.of<PostService>(context, listen: false)
                    .getallPostnewversion();
                Navigator.pop(context);
              }),
          actions: [
            isloggedin
                ? IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditPostScreen()),
                      );
                    },
                    icon: const Icon(Icons.edit))
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
        body: Consumer<PostService>(builder: (context, post, child) {
          if (!post.getIsloading) {
            bool show = Provider.of<PostService>(context).getCollapse;
            double commentheight = 0.0;
            if (getpost?.comments.length != null) {
              commentheight = getpost!.comments.length * 0.12;
            }
            if (commentheight > 0.5) {
              commentheight > 0.5;
            }

            String? filename = getpost!.file == null
                ? 'Nincs fájl feltöltve'
                : getpost.file?.name;
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
                        child: SelectableText(getpost.body,
                            style: const TextStyle(fontSize: 20.0))),
                    getpost.file != null
                        ? Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: ElevatedButton(
                                onPressed: () {
                                  Provider.of<PostService>(context,
                                          listen: false)
                                      .getfile(id: getpost.file!.id!);
                                },
                                child: Text(filename!)),
                          )
                        : Container(),
                    Wrap(children: [
                      ...getpost.tags.map((tag) => Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Chip(label: Text(tag.name)),
                          ))
                    ]),
                    getpost.comments.isNotEmpty
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
                    getpost.comments.isNotEmpty
                        ? AnimatedContainer(
                            duration: const Duration(seconds: 1),
                            height: show
                                ? 0
                                : (MediaQuery.of(context).size.height *
                                    commentheight),
                            child: ListView.separated(
                                separatorBuilder: (context, index) =>
                                    const Divider(
                                      color: Colors.black,
                                    ),
                                padding: const EdgeInsets.all(8),
                                shrinkWrap: true,
                                primary: false,
                                itemCount: getpost.comments.length,
                                itemBuilder: (BuildContext context, int index) {
                                  TextEditingController comedit =
                                      TextEditingController();
                                  commentcontroller.add(comedit);
                                  return CommentTile(
                                      commentlist: getpost.comments,
                                      commentcontroller: commentcontroller,
                                      getpost: getpost,
                                      index: index,
                                      isloggedin: isloggedin);
                                }))
                        : Container(),
                    isloggedin
                        ? NewComment(
                            newcommentcontroller: newcommentcontroller,
                            getpost: getpost)
                        : Container()
                  ],
                ));
          } else {
            return const Center(child: CircularProgressIndicator(value: null));
          }
        }));
  }
}
