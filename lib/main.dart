import 'package:blog/screens/login_page.dart';
import 'package:blog/screens/newpost_page.dart';
import 'package:blog/screens/postlist_page.dart';
import 'package:blog/services/auth_service.dart';
import 'package:blog/services/comment_service.dart';
import 'package:blog/services/post_service.dart';
import 'package:blog/config/ui_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => AuthService()),
    ChangeNotifierProvider(create: (context) => PostService()),
    ChangeNotifierProvider(create: (context) => CommentService()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Informatikus leszek blog'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              icon: const Icon(Icons.login))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              height: 100.0,
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () async {
                    await readToken();
                    Provider.of<PostService>(context, listen: false)
                        .getallPost();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PostListScreen(title: 'Bejegyzés lista')),
                    );
                  },
                  child: const Text('Adatlekérés',
                      style: TextStyle(fontSize: UIconfig.mySize)))),
          isloggedin
              ? Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  height: 100.0,
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  NewPostPage(pagetitle: 'Új bejegyzés')),
                        );
                      },
                      child: const Text('Új bejegyzés',
                          style: TextStyle(fontSize: UIconfig.mySize))))
              : Container()
        ],
      ),
    );
  }
}
