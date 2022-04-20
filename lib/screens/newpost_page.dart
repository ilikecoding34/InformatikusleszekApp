import 'package:blog/config/ui_config.dart';
import 'package:blog/services/auth_service.dart';
import 'package:blog/services/post_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewPostPage extends StatelessWidget {
  NewPostPage({Key? key, required this.pagetitle}) : super(key: key);
  String? pagetitle;

  String? datas;

  TextEditingController title = TextEditingController();
  TextEditingController link = TextEditingController();
  TextEditingController body = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Bejelentkezés'),
        ),
        body: SingleChildScrollView(
            reverse: true,
            child: Column(
              children: [
                Container(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: title,
                      decoration: InputDecoration(
                          labelText: 'Cím',
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 3, color: Colors.blue),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 3, color: Colors.lime),
                            borderRadius: BorderRadius.circular(15),
                          )),
                    )),
                Container(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: link,
                      decoration: InputDecoration(
                          labelText: 'Url - opcionális',
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 3, color: Colors.blue),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 3, color: Colors.lime),
                            borderRadius: BorderRadius.circular(15),
                          )),
                    )),
                Container(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: body,
                      decoration: InputDecoration(
                          labelText: 'Tartalom',
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 3, color: Colors.blue),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 3, color: Colors.lime),
                            borderRadius: BorderRadius.circular(15),
                          )),
                    )),
                Container(
                    padding: const EdgeInsets.all(10),
                    width: 300.0,
                    height: 100.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.cyan,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20),
                          textStyle: const TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold)),
                      child: const Text('Új bejegyzés',
                          style: TextStyle(fontSize: UIconfig.mySize)),
                      onPressed: () async {
                        Map datas = {
                          'userid': 1,
                          'title': title.text,
                          'link': link.text,
                          'content': body.text,
                          'category': 1
                        };
                        await Provider.of<PostService>(context, listen: false)
                            .storePost(datas: datas)
                            .then((value) => {Navigator.pop(context)});
                        Provider.of<PostService>(context, listen: false)
                            .getallPost();
                      },
                    ))
              ],
            )));
  }
}
