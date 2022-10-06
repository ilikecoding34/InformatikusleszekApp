import 'package:blog/config/ui_config.dart';
import 'package:blog/services/post_service.dart';
import 'package:blog/widgets/input_widget.dart';
import 'package:blog/widgets/tags_chip_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

class NewPostPage extends StatelessWidget {
  NewPostPage({Key? key, required this.pagetitle}) : super(key: key);
  String? pagetitle;

  String? datas;
  String feedback = "";

  TextEditingController title = TextEditingController();
  TextEditingController link = TextEditingController();
  TextEditingController body = TextEditingController();

  List<dynamic> taglist = [];

  messageSnackBar(String content) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(content),
    );
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<PostService>(context, listen: false).getallPostnewversion();
    taglist = Provider.of<PostService>(context, listen: true).getSelectedTags;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Új bejegyzés'),
        ),
        body: SingleChildScrollView(
            reverse: true,
            child: Column(
              children: [
                InputFieldWidget(title: 'Cím', controller: title),
                InputFieldWidget(title: 'Url - opcionális', controller: link),
                InputFieldWidget(title: 'Tartalom', controller: body),
                TagsChip(
                  post: Provider.of<PostService>(context, listen: false),
                ),
                Container(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      style: UIconfig.buttonStyle,
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

                        if (!isURL(link.text)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            messageSnackBar("Hibás link"),
                          );
                          return;
                        }

                        await Provider.of<PostService>(context, listen: false)
                            .storePost(datas: datas)
                            .then((value) => {
                                  if (value != null)
                                    {
                                      value == "success"
                                          ? feedback = "Sikeres mentés"
                                          : "",
                                      value == "link exist"
                                          ? feedback =
                                              "Már létezik ez a bejegyzés"
                                          : "",
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                              messageSnackBar(feedback))
                                          .closed
                                          .then((value) => {
                                                Provider.of<PostService>(
                                                        context,
                                                        listen: false)
                                                    .clearTagFilterList(),
                                                Provider.of<PostService>(
                                                        context,
                                                        listen: false)
                                                    .getallPostnewversion()
                                                    .then((value) =>
                                                        Navigator.pop(context))
                                              }),
                                    }
                                  else
                                    {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                            messageSnackBar(
                                                "Hiba történt a mentés közben"),
                                          )
                                          .closed
                                          .then((value) {
                                        return;
                                      })
                                    },
                                });
                      },
                    ))
              ],
            )));
  }
}
