import 'package:blog/config/ui_config.dart';
import 'package:blog/services/post_service.dart';
import 'package:blog/widgets/tags_chip_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewPostPage extends StatelessWidget {
  NewPostPage({Key? key, required this.pagetitle}) : super(key: key);
  String? pagetitle;

  String? datas;

  TextEditingController title = TextEditingController();
  TextEditingController link = TextEditingController();
  TextEditingController body = TextEditingController();

  List<dynamic> taglist = [];

  @override
  Widget build(BuildContext context) {
    Provider.of<PostService>(context, listen: false).getallPostnewversion();
    taglist = Provider.of<PostService>(context, listen: true).getAllTags;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Új bejegyzés'),
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
                TagsChip(
                  post: Provider.of<PostService>(context, listen: false),
                ),
                Container(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.cyan,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
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
                          'tags': taglist,
                          'category': 1
                        };
                        await Provider.of<PostService>(context, listen: false)
                            .storePost(datas: datas)
                            .then((value) => {
                                  Provider.of<PostService>(context,
                                          listen: false)
                                      .getallPostnewversion()
                                      .then((value) => Navigator.pop(context))
                                });
                      },
                    ))
              ],
            )));
  }
}
