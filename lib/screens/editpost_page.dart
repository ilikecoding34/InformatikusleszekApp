import 'package:blog/models/post_model.dart';
import 'package:blog/screens/login_page.dart';
import 'package:blog/services/auth_service.dart';
import 'package:blog/services/post_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditPostScreen extends StatelessWidget {
  EditPostScreen({Key? key, required this.title}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    bool isloggedin = Provider.of<AuthService>(context).authenticated;
    PostModel? getpost = Provider.of<PostService>(context).singlepost;
    taglist = Provider.of<PostService>(context, listen: true).taglist;
    selected = Provider.of<PostService>(context, listen: true).tagselected;
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
          actions: [
            isloggedin
                ? IconButton(
                    onPressed: () async {
                      postdatas = {
                        'id': getpost!.id,
                        'userid': 1,
                        'title': posttitlecontroller.text,
                        'link': postlinkcontroller.text,
                        'content': postbodycontroller.text,
                        'tags': selected,
                        'category': 1
                      };

                      await Provider.of<PostService>(context, listen: false)
                          .modifyPost(datas: postdatas)
                          .then((value) =>
                              Provider.of<PostService>(context, listen: false)
                                  .getPost(id: value));
                    },
                    icon: const Icon(Icons.save))
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
          if (!post.isLoading) {
            posttitlecontroller.text = getpost!.title;
            postlinkcontroller.text = getpost.link ?? '';
            postbodycontroller.text = getpost.body;
            String filename = getpost.file == null
                ? 'Nincs fájl feltöltve'
                : getpost.file!.name!;
            return SingleChildScrollView(
                reverse: true,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          controller: posttitlecontroller,
                        )),
                    Container(
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          controller: postlinkcontroller,
                        )),
                    Container(
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          controller: postbodycontroller,
                        )),
                    getpost.file != null
                        ? Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: ElevatedButton(
                                onPressed: () {
                                  Provider.of<PostService>(context,
                                          listen: false)
                                      .getfile(id: getpost.file!.id!);
                                },
                                child: Text(filename)),
                          )
                        : ElevatedButton(
                            onPressed: null,
                            child: const Text('File feltöltés')),
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
                                      //   print(selected);
                                    },
                                    child: Chip(
                                      backgroundColor:
                                          selected.contains(item.id)
                                              ? Colors.blue
                                              : Colors.grey,
                                      label: Text(item.name),
                                    ),
                                  )))
                      ],
                    ),
                  ],
                ));
          } else {
            return const Center(child: CircularProgressIndicator(value: null));
          }
        }));
  }
}
