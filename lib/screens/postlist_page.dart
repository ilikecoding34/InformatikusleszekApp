import 'package:blog/models/post_model.dart';
import 'package:blog/screens/singlepost_page.dart';
import 'package:blog/services/auth_service.dart';
import 'package:blog/services/post_service.dart';
import 'package:blog/services/sharedpreferences_service.dart';
import 'package:blog/services/theme_service.dart';
import 'package:blog/widgets/post_list_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  List<dynamic> loadedposts = [];
  List<PostModel> filteredposts = [];

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

  loadposts() async {
    await Provider.of<PostService>(context, listen: false)
        .getallPostnewversion();

    setState(() {
      loadedposts = Provider.of<PostService>(context, listen: true).postlist;
    });
  }

/*
  Future userLoad() async {
    bool userLoggedIn = await shared.readUserId();
    userLoggedIn
        ? Provider.of<AuthService>(context, listen: false).loginUser()
        : null;
  }
*/
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    themeLoad();
    loadposts();
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
            return Column(
              children: [
                Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Wrap(
                      children: [
                        Chip(
                            label: ElevatedButton(
                                child: const Text("Mind"),
                                onPressed: () {
                                  setState(() {
                                    loadedposts = post.postlist;
                                  });
                                })),
                        for (var item in post.taglist)
                          Chip(
                              label: ElevatedButton(
                            child: Text(item.name),
                            onPressed: () {
                              filteredposts.clear();
                              for (int i = 0; i < post.postlist.length; i++) {
                                if (post.postlist[i].tags != null) {
                                  if (post.postlist[i].tags.length > 0) {
                                    for (var tag in post.postlist[i].tags) {
                                      if (tag.name == item.name) {
                                        filteredposts.add(post.postlist[i]);
                                      }
                                    }
                                  }
                                }
                              }
                              setState(() {
                                loadedposts = filteredposts;
                              });
                            },
                          )),
                      ],
                    )),
                Expanded(
                    child: ListView.separated(
                        separatorBuilder: (context, index) => const Divider(
                              color: Colors.black,
                            ),
                        padding: const EdgeInsets.all(8),
                        itemCount: loadedposts.length,
                        itemBuilder: (BuildContext context, int index) {
                          PostModel postitem = loadedposts[index];
                          return PostListItem(
                            postitem: postitem,
                            openitem: () =>
                                openPost(postitem.title, postitem.id),
                          );
                        }))
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator(value: null));
          }
        },
      ),
    );
  }
}
