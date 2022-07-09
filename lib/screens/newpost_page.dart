import 'package:blog/config/ui_config.dart';
import 'package:blog/services/post_service.dart';
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

  List<int> selected = [];

  @override
  Widget build(BuildContext context) {
    Provider.of<PostService>(context, listen: false).getallPostnewversion();
    taglist = Provider.of<PostService>(context, listen: true).getAllTags;
    selected = Provider.of<PostService>(context, listen: true).getSelectedTags;
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
                Wrap(
                  children: [
                    for (var item in taglist)
                      AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: selected.contains(item.id) ? 30 : 40,
                          child: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: GestureDetector(
                                onTap: () {
                                  Provider.of<PostService>(context,
                                          listen: false)
                                      .tagsSelection(item.id);
                                },
                                child: Chip(
                                  backgroundColor: selected.contains(item.id)
                                      ? Colors.blue
                                      : Colors.grey,
                                  label: Text(item.name),
                                ),
                              )))
                  ],
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
                          'tags': selected,
                          'category': 1
                        };
                        await Provider.of<PostService>(context, listen: false)
                            .storePost(datas: datas)
                            .then((value) => {Navigator.pop(context)});
                        Provider.of<PostService>(context, listen: false)
                            .getallPostnewversion();
                      },
                    ))
              ],
            )));
  }
}
