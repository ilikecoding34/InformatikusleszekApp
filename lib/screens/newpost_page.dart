import 'package:blog/services/post_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewPostPage extends StatelessWidget {
  NewPostPage({Key? key, required this.pagetitle}) : super(key: key);
  String? pagetitle;

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

  TextEditingController title = TextEditingController();
  TextEditingController body = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Bejelentkezés'),
        ),
        body: Column(
          children: [
            Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: title,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Cím',
                  ),
                )),
            Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: body,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Tartalom',
                  ),
                )),
            Container(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  child: const Text('Új bejegyzés'),
                  onPressed: () async {
                    Map creds = {
                      'userid': 1,
                      'title': title.text,
                      'content': body.text,
                      'category': 1
                    };
                    await readToken();
                    print(token);
                    Provider.of<Postservice>(context, listen: false)
                        .storePost(token: token, datas: creds)
                        .then((value) => {Navigator.pop(context)});
                  },
                ))
          ],
        ));
  }
}
