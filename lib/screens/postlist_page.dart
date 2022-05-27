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
  double startpoint = 0.0;
  double distance = 0.0;
  bool isTop = false;
  ScrollController _controller = ScrollController();
  List<dynamic> loadedposts = [];

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

  _scrollListener() {
    if (_controller.position.atEdge) {
      isTop = _controller.position.pixels == 0;
    }
  }

  final snackBar = const SnackBar(
    behavior: SnackBarBehavior.floating,
    content: Text('Frissítés megtörtént'),
  );

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
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    themeLoad();
    Provider.of<PostService>(context, listen: false).getallPostnewversion();
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeService>(context);
    bool isloggedin =
        Provider.of<AuthService>(context, listen: true).authenticated;
    double screenwidth = MediaQuery.of(context).size.width;
    int numberOfLines = (screenwidth / 17).floor();
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
                        Padding(
                            padding:
                                const EdgeInsets.only(right: 10, bottom: 10),
                            child: GestureDetector(
                                onTap: () {
                                  post.filterPosts('all');
                                },
                                child: Chip(
                                  label: Text(
                                    "Mind",
                                    style: TextStyle(
                                        color: post.tagFilterList.isEmpty
                                            ? Colors.blue
                                            : Colors.white),
                                  ),
                                ))),
                        for (var item in post.taglist)
                          post.tagFilterList.contains(item.name)
                              ? const SizedBox.shrink()
                              : Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: GestureDetector(
                                      onTap: () {
                                        post.filterPosts(item.name);
                                      },
                                      child: Chip(
                                        label: Text(
                                          item.name,
                                          style: TextStyle(
                                              color: post.tagFilterList
                                                      .contains(item.name)
                                                  ? Colors.blue
                                                  : Colors.white),
                                        ),
                                      ))),
                        for (var item in post.tagFilterList)
                          Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: GestureDetector(
                                  onTap: () {
                                    post.filterPosts(item);
                                  },
                                  child: Chip(
                                    label: Text(
                                      item,
                                      style: TextStyle(
                                          color:
                                              post.tagFilterList.contains(item)
                                                  ? Colors.blue
                                                  : Colors.white),
                                    ),
                                  ))),
                      ],
                    )),
                ClipRect(
                  child: Align(
                    alignment: Alignment.topCenter,
                    heightFactor: (post.calculatedswipe < 0)
                        ? 0
                        : post.calculatedswipe / 100,
                    child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                            height: 50,
                            child: Stack(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    for (int i = 0; i < numberOfLines; i++)
                                      RotationTransition(
                                          turns: const AlwaysStoppedAnimation(
                                              45 / 360),
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(right: 5),
                                            child: Container(
                                              height: 50,
                                              width: 10,
                                              decoration: BoxDecoration(
                                                  color: (post.calculatedswipe
                                                                          .floor() %
                                                                      20 <
                                                                  10 &&
                                                              post.calculatedswipe
                                                                          .floor() %
                                                                      20 >
                                                                  0
                                                          ? i.isEven
                                                          : i.isOdd)
                                                      ? Colors.blue
                                                      : Colors.green,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                            ),
                                          )),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Frissítés',
                                        style: TextStyle(
                                            backgroundColor: Colors.grey),
                                      ),
                                      RotationTransition(
                                        turns: AlwaysStoppedAnimation(
                                            post.calculatedswipe / 100),
                                        child: const Icon(Icons.autorenew),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ))),
                  ),
                ),
                post.filteredposts.isNotEmpty
                    ? Expanded(
                        child: Listener(
                            onPointerDown: (PointerDownEvent detail) => {
                                  startpoint =
                                      detail.position.dy.floorToDouble(),
                                  post.refreshing = true,
                                },
                            onPointerMove: (PointerMoveEvent detail) => {
                                  if (_controller.position.pixels == 0)
                                    {
                                      distance =
                                          detail.position.dy.floorToDouble(),
                                      post.refreshMovement(
                                          startpoint, distance),
                                      if (post.refresdone)
                                        {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar),
                                          post.refresdone = false,
                                        }
                                    }
                                  else
                                    {
                                      post.refreshing = false,
                                      post.refreshMovement(
                                          startpoint, distance),
                                    }
                                },
                            onPointerUp: (value) => {
                                  post.refreshing = false,
                                  post.refreshMovement(startpoint, distance),
                                },
                            child: ListView.separated(
                                separatorBuilder: (context, index) =>
                                    const Divider(
                                      color: Colors.black,
                                    ),
                                padding: const EdgeInsets.all(8),
                                controller: _controller,
                                itemCount: post.filteredposts.length,
                                itemBuilder: (BuildContext context, int index) {
                                  PostModel postitem =
                                      post.filteredposts[index];
                                  return PostListItem(
                                    postitem: postitem,
                                    openitem: () =>
                                        openPost(postitem.title, postitem.id),
                                  );
                                })))
                    : const Center(
                        child: Text('Nincs eredmény'),
                      )
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
