import 'package:blog/config/ui_config.dart';
import 'package:blog/screens/postlist_page.dart';
import 'package:blog/services/post_service.dart';
import 'package:blog/services/sharedpreferences_service.dart';
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

  PreferencesService shareddatas = PreferencesService();

  PostService? postService;

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

  createFeedbackString(String value) {
    String message = '';
    value == "success" ? message = "Sikeres mentés" : "";
    value == "link exist" ? message = "Már létezik ez a bejegyzés" : "";
    return message;
  }

  backToMainScreen(BuildContext context, String value) {
    ScaffoldMessenger.of(context)
        .showSnackBar(messageSnackBar(createFeedbackString(value)))
        .closed
        .then((value) => {
              postService?.clearTagFilterList(),
              postService?.getallPostnewversion().then((value) {
                postService?.setStoreSuccess(false);
                Navigator.pop(context);
              })
            });
  }

  failedSave(BuildContext context, String inputttext) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
          messageSnackBar(inputttext),
        )
        .closed
        .then((value) {
      return;
    });
  }

  @override
  Widget build(BuildContext context) {
    //  postService.getallPostnewversion();
    postService = Provider.of<PostService>(context, listen: false);
    taglist = Provider.of<PostService>(context, listen: true).getSelectedTags;
    bool postStoreSuccess =
        Provider.of<PostService>(context, listen: true).isStoreSuccess;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Új bejegyzés'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              postService?.clearTagFilterList();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        PostListScreen(title: 'Bejegyzés lista')),
              );
            },
          ),
        ),
        body: SingleChildScrollView(
            reverse: true,
            child: Column(
              children: [
                InputFieldWidget(title: 'Cím', controller: title),
                InputFieldWidget(title: 'Url - opcionális', controller: link),
                InputFieldWidget(title: 'Tartalom', controller: body),
                TagsChip(
                  post: postService!,
                ),
                postStoreSuccess == false
                    ? Container(
                        padding: const EdgeInsets.all(10),
                        child: ElevatedButton(
                          style: UIconfig.buttonBasicStyle,
                          child: const Text('Új bejegyzés',
                              style: TextStyle(fontSize: UIconfig.mySize)),
                          onPressed: () async {
                            Map datas = {
                              'userid': await shareddatas.readUserId(),
                              'title': title.text,
                              'link': link.text,
                              'content': body.text,
                              'tags': taglist,
                              'category': 1
                            };

                            if (!isURL(link.text)) {
                              failedSave(context, 'Hibás link');
                            }

                            await postService
                                ?.storePost(datas: datas)
                                .then((value) => {
                                      value != null
                                          ? backToMainScreen(context, value)
                                          : failedSave(context,
                                              'Hiba történt a mentés közben')
                                    });
                          },
                        ))
                    : const SizedBox.shrink()
              ],
            )));
  }
}
