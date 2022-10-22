import 'package:any_link_preview/any_link_preview.dart';
import 'package:blog/models/post_model.dart';
import 'package:blog/screens/editpost_page.dart';
import 'package:blog/screens/postlist_page.dart';
import 'package:blog/services/auth_service.dart';
import 'package:blog/services/comment_service.dart';
import 'package:blog/services/post_service.dart';
import 'package:blog/services/sharedpreferences_service.dart';
import 'package:blog/widgets/circle_widget.dart';
import 'package:blog/widgets/comment_list_body.dart';
import 'package:blog/widgets/comment_list.dart';
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
  List<TextEditingController> commentcontroller = [];

  List<dynamic> taglist = [];

  List<int> selected = [];

  List<Circle> circles = [];

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
    PostModel? getPostModel = Provider.of<PostService>(context).singlepost;
    taglist = Provider.of<PostService>(context, listen: true).getAllTags;
    selected = Provider.of<PostService>(context, listen: true).getSelectedTags;

    return WillPopScope(
        onWillPop: () async {
          await Provider.of<PostService>(context, listen: false)
              .getallPostnewversion()
              .then((value) => Navigator.pop(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            PostListScreen(title: 'Bejegyzés lista')),
                  ));
          return true;
        },
        child: Scaffold(
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
            body: Stack(
              children: [
                //   CirclesBackground(),
                Consumer<PostService>(builder: (context, post, child) {
                  if (!post.getIsloading) {
                    bool show = post.getCollapse;
                    double commentheight = 0.0;
                    if (getPostModel?.comments.length != null) {
                      commentheight = getPostModel!.comments.length * 0.12;
                    }
                    if (commentheight > 0.5) {
                      commentheight > 0.5;
                    }

                    String? filename = getPostModel!.file == null
                        ? 'Nincs fájl feltöltve'
                        : getPostModel.file?.name;
                    return SingleChildScrollView(
                        reverse: true,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                                padding: const EdgeInsets.all(10),
                                child: Text(getPostModel.title,
                                    style: const TextStyle(fontSize: 30.0))),
                            Visibility(
                              child: Container(
                                  padding: const EdgeInsets.all(10),
                                  child: ElevatedButton(
                                      onPressed: () =>
                                          _launchURL(getPostModel.link ?? ''),
                                      child: const Text('Link megnyitása'))),
                              visible: getPostModel.link != null,
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: AnyLinkPreview(
                                  displayDirection:
                                      UIDirection.uiDirectionHorizontal,
                                  link: getPostModel.link ?? '',
                                  errorBody: 'Show my custom error body',
                                  errorTitle:
                                      'Next one is youtube link, error title',
                                )),
                            const SizedBox(height: 25),
                            Container(
                                padding: const EdgeInsets.all(10),
                                child: SelectableText(getPostModel.body,
                                    style: const TextStyle(fontSize: 20.0))),
                            getPostModel.file != null
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 10),
                                    child: ElevatedButton(
                                        onPressed: () {
                                          Provider.of<PostService>(context,
                                                  listen: false)
                                              .getfile(
                                                  id: getPostModel.file!.id!);
                                        },
                                        child: Text(filename!)),
                                  )
                                : const SizedBox.shrink(),
                            Wrap(children: [
                              ...getPostModel.tags.map((tag) => Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Chip(label: Text(tag.name)),
                                  ))
                            ]),
                            getPostModel.comments.isNotEmpty
                                ? CommentListBody(
                                    show: show,
                                    commentheight: commentheight,
                                    getpost: getPostModel,
                                    isloggedin: isloggedin)
                                : const SizedBox.shrink(),
                            isloggedin
                                ? NewComment(
                                    getpost: getPostModel,
                                  )
                                : const SizedBox.shrink()
                          ],
                        ));
                  } else {
                    return const Center(
                        child: CircularProgressIndicator(value: null));
                  }
                })
              ],
            )));
  }
}
