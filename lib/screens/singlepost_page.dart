import 'package:blog/config/ui_config.dart';
import 'package:blog/services/auth_service.dart';
import 'package:blog/services/post_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SinglePostScreen extends StatelessWidget {
  SinglePostScreen({Key? key, required this.title});

  final String title;
  TextEditingController titlecontroller = TextEditingController();

  final storage = FlutterSecureStorage();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String? token;
  String? datas;

  Future readToken() async {
    SharedPreferences prefs = await _prefs;
    if (kIsWeb) {
      token = prefs.getString('token');
    } else {
      token = await storage.read(key: "token");
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isloggedin =
        Provider.of<AuthService>(context, listen: true).authenticated;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(title),
        ),
        body: Consumer<Postservice>(builder: (context, post, child) {
          if (post.singlepost != null) {
            var comments = post.singlepost['comments'];
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    padding: const EdgeInsets.all(10),
                    child: Text(post.singlepost['title'],
                        style: const TextStyle(fontSize: 30.0))),
                Text(post.singlepost['body'],
                    style: const TextStyle(fontSize: 20.0)),
                Container(
                    padding: const EdgeInsets.all(10),
                    child: const Text('Kommentek:',
                        style: TextStyle(fontSize: 15.0))),
                Flexible(
                    child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: comments.length,
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
                            child: Text(
                              '${index + 1}: ${comments[index]['body']}',
                              style: const TextStyle(fontSize: 15.0),
                              textAlign: TextAlign.center,
                            ),
                          );
                        })),
                isloggedin
                    ? Column(children: [
                        Container(
                            height: 50.0,
                            padding: const EdgeInsets.all(10),
                            child: TextField(
                              controller: titlecontroller,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Új hozzászólás',
                              ),
                            )),
                        Container(
                            padding: const EdgeInsets.all(10),
                            width: 300.0,
                            height: 80.0,
                            child: ElevatedButton(
                                onPressed: () async {
                                  await readToken();
                                  Map datas = {
                                    'userid': 1,
                                    'content': titlecontroller.text,
                                    'postid': post.singlepost['id'],
                                  };
                                  Provider.of<Postservice>(context,
                                          listen: false)
                                      .storeComment(token: token, datas: datas)
                                      .then((value) => {
                                            Provider.of<Postservice>(context,
                                                    listen: false)
                                                .getPost(
                                                    id: int.parse(
                                                        post.singlepost['id']))
                                          });
                                  titlecontroller.clear();
                                },
                                child: const Text('Hozzászólás mentése',
                                    style:
                                        TextStyle(fontSize: UIconfig.mySize))))
                      ])
                    : Container()
              ],
            );
          } else {
            return Container();
          }
        }));
  }
}
