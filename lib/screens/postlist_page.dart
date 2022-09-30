import 'package:blog/services/auth_service.dart';
import 'package:blog/services/post_service.dart';
import 'package:blog/services/sharedpreferences_service.dart';
import 'package:blog/services/theme_service.dart';
import 'package:blog/widgets/appbar_widget.dart';
import 'package:blog/widgets/post_list_container_widget.dart';
import 'package:blog/widgets/refresh_widget.dart';
import 'package:blog/widgets/tags_chip_widget.dart';
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
  List<dynamic> loadedposts = [];

  PreferencesService shared = PreferencesService();

  Future themeLoad() async {
    bool darkModeOn = await shared.readThemeType() ?? true;
    Provider.of<ThemeService>(context, listen: false).changeMode(darkModeOn);
  }

  Future userLoad() async {
    String userid = await shared.readUserId();
    userid.isNotEmpty
        ? Provider.of<AuthService>(context, listen: false).loginUser()
        : null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    themeLoad();
    userLoad();
    Provider.of<PostService>(context, listen: false).getallPostnewversion();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    int numberOfLines = (size.width / 17).floor();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Bejegyzések'),
        actions: const [AppBarActions()],
      ),
      body: Consumer<PostService>(
        builder: (context, post, child) {
          double swiped = post.calculatedswipe;
          bool evenOrOdd = swiped.floor() % 20 < 10 && swiped.floor() % 20 > 0;
          if (post.postlist.isNotEmpty) {
            return Column(
              children: [
                TagsChip(
                  post: post,
                ),
                RefreshList(
                    swiped: swiped,
                    numberOfLines: numberOfLines,
                    evenOrOdd: evenOrOdd),
                post.filteredposts.isNotEmpty
                    ? PostListContainer(post: post)
                    : const Center(
                        child: Text('Nincs eredmény'),
                      ),
                post.getShowAll
                    ? const Text('Minden bejegyzés megjelenítve')
                    : const SizedBox.shrink(),
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
