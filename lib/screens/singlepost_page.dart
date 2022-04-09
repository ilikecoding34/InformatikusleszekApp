import 'package:blog/config/ui_config.dart';
import 'package:blog/models/comment_model.dart';
import 'package:blog/models/post_model.dart';
import 'package:blog/services/auth_service.dart';
import 'package:blog/services/comment_service.dart';
import 'package:blog/services/post_service.dart';
import 'package:blog/widgets/comment_tile.dart';
import 'package:blog/widgets/new_comment_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'login_page.dart';

class SinglePostScreen extends StatelessWidget {
  SinglePostScreen({Key? key, required this.title});

  final String title;
  TextEditingController posttitlecontroller = TextEditingController();
  TextEditingController postbodycontroller = TextEditingController();
  TextEditingController postlinkcontroller = TextEditingController();
  TextEditingController newcommentcontroller = TextEditingController();
  List<TextEditingController> commentcontroller = [];

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
    bool isEditing = Provider.of<CommentService>(context).commentedit;
    bool isPostEdit = Provider.of<PostService>(context).postedit;
    PostModel? getpost = Provider.of<PostService>(context).singlepost;
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Provider.of<PostService>(context, listen: false).getallPost();
                Navigator.pop(context);
              }),
          actions: [
            isloggedin
                ? isPostEdit
                    ? IconButton(
                        onPressed: () async {
                          postdatas = {
                            'id': getpost!.id,
                            'userid': 1,
                            'title': posttitlecontroller.text,
                            'link': postlinkcontroller.text,
                            'content': postbodycontroller.text,
                            'category': 1
                          };
                          await Provider.of<PostService>(context, listen: false)
                              .modifyPost(datas: postdatas)
                              .then((value) => Provider.of<PostService>(context,
                                      listen: false)
                                  .getPost(id: value));
                        },
                        icon: const Icon(Icons.save))
                    : IconButton(
                        onPressed: () {
                          Provider.of<PostService>(context, listen: false)
                              .setToModify();
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
          if (post.singlepost != null) {
            bool show = Provider.of<PostService>(context).collapse;

            posttitlecontroller.text = getpost!.title;
            postlinkcontroller.text = getpost.link ?? '';
            postbodycontroller.text = getpost.body;
            List<CommentModel> commentlist =
                getpost.comments!.map((i) => CommentModel.fromJson(i)).toList();

            return SingleChildScrollView(
                reverse: true,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        padding: const EdgeInsets.all(10),
                        child: !isPostEdit
                            ? Text(getpost.title,
                                style: const TextStyle(fontSize: 30.0))
                            : TextField(
                                controller: posttitlecontroller,
                              )),
                    !isPostEdit
                        ? Visibility(
                            child: Container(
                                padding: const EdgeInsets.all(10),
                                child: ElevatedButton(
                                    onPressed: () =>
                                        _launchURL(getpost.link ?? ''),
                                    child: const Text('Link megnyitása'))),
                            visible: getpost.link != null,
                          )
                        : TextField(
                            controller: postlinkcontroller,
                          ),
                    Container(
                        padding: const EdgeInsets.all(10),
                        child: !isPostEdit
                            ? Text(getpost.body,
                                style: const TextStyle(fontSize: 20.0))
                            : TextField(
                                controller: postbodycontroller,
                              )),
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
                            height: show
                                ? 0
                                : (MediaQuery.of(context).size.height * 0.5),
                            child: ListView.separated(
                                separatorBuilder: (context, index) =>
                                    const Divider(
                                      color: Colors.black,
                                    ),
                                padding: const EdgeInsets.all(8),
                                shrinkWrap: true,
                                primary: false,
                                itemCount: commentlist.length,
                                itemBuilder: (BuildContext context, int index) {
                                  TextEditingController comedit =
                                      TextEditingController();
                                  commentcontroller.add(comedit);
                                  return CommentTile(
                                      commentlist: commentlist,
                                      commentcontroller: commentcontroller,
                                      getpost: getpost,
                                      index: index,
                                      isEditing: isEditing,
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
            return CircularProgressIndicator(value: null);
          }
        }));
  }
}
