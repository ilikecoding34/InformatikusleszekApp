import 'package:blog/models/post_model.dart';
import 'package:blog/screens/singlepost_page.dart';
import 'package:blog/services/auth_service.dart';
import 'package:blog/services/post_service.dart';
import 'package:blog/services/sharedpreferences_service.dart';
import 'package:blog/services/theme_service.dart';
import 'package:blog/widgets/post_list_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'login_page.dart';
import 'newpost_page.dart';

class PostListScreen extends StatefulWidget {
  PostListScreen({Key? key, required this.title}) : super(key: key);
  String title;
  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  String? title;

  PreferencesService shared = PreferencesService();

  openPost(String title, int id) {
    Provider.of<PostService>(context, listen: false).collapse = true;
    Provider.of<PostService>(context, listen: false).isLoading = true;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SinglePostScreen(title: title)),
    );
    Provider.of<PostService>(context, listen: false).getPost(id: id);
  }

  Future themeLoad() async {
    bool darkModeOn = await shared.readThemeType() ?? true;
    Provider.of<ThemeService>(context, listen: false).changeMode(darkModeOn);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    themeLoad();
    Provider.of<PostService>(context, listen: false).getallPost();
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeService>(context);
    bool isloggedin =
        Provider.of<AuthService>(context, listen: true).authenticated;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Bejegyzések'),
        actions: [
          Container(
            alignment: Alignment.center,
            child: const Text('Mode:'),
          ),
          IconButton(
              onPressed: () {
                bool value = !themeNotifier.getMode();
                themeNotifier.changeMode(value);
              },
              icon: themeNotifier.getMode()
                  ? const Icon(Icons.dark_mode)
                  : const Icon(Icons.light_mode)),
          isloggedin
              ? IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              NewPostPage(pagetitle: 'Új bejegyzés')),
                    );
                  },
                  icon: const Icon(Icons.playlist_add_outlined))
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
      body: Consumer<PostService>(
        builder: (context, post, child) {
          if (post.postlist.isNotEmpty) {
            return ListView.separated(
                separatorBuilder: (context, index) => const Divider(
                      color: Colors.black,
                    ),
                padding: const EdgeInsets.all(8),
                itemCount: post.postlist.length,
                itemBuilder: (BuildContext context, int index) {
                  PostModel postitem = post.postlist[index];
                  return PostListItem(
                    postitem: postitem,
                    openitem: () => openPost(postitem.title, postitem.id),
                  );
                });
          } else {
            return const Center(child: CircularProgressIndicator(value: null));
          }
        },
      ),
    );
  }
}
