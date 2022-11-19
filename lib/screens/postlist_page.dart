import 'package:blog/config/ui_config.dart';
import 'package:blog/services/auth_service.dart';
import 'package:blog/services/post_service.dart';
import 'package:blog/services/sharedpreferences_service.dart';
import 'package:blog/services/theme_service.dart';
import 'package:blog/widgets/appbar_widget.dart';
import 'package:blog/widgets/post_list_container_widget.dart';
import 'package:blog/widgets/refresh_widget.dart';
import 'package:blog/widgets/tags_chip_widget.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

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
  bool topViewOrder = false;
  late bool darkModeOn;
  List<dynamic> loadedposts = [];

  PreferencesService shared = PreferencesService();

  Future themeLoad() async {
    darkModeOn = await shared.readThemeType() ?? true;
    Provider.of<ThemeService>(context, listen: false).changeMode(darkModeOn);
  }

  Future userLoad() async {
    String userid = await shared.readUserId();
    userid.isNotEmpty
        ? Provider.of<AuthService>(context, listen: false).loginUser()
        : '0';
  }

  getPermissions() async {
    // You can request multiple permissions at once.
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      //add more permission to request here.
    ].request();

    if (statuses[Permission.storage]!.isDenied) {
      //check each permission status after.
      print("Location permission is denied.");
    }
  }

  @override
  void initState() {
    super.initState();
    getPermissions();
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
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 10.0,
                          shadowColor:
                              Provider.of<ThemeService>(context).isDarkMode()
                                  ? const ColorScheme.light().background
                                  : const ColorScheme.dark().background,
                          backgroundColor: Colors.cyan,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          textStyle: const TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        if (mounted) {
                          topViewOrder = !topViewOrder;
                          post.orderTopViewed(topViewOrder);
                        }
                      },
                      child: Text(
                          topViewOrder ? "Időrend" : "Legtöbb megtekintés",
                          style: const TextStyle(fontSize: UIconfig.mySize)),
                    )),
                Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TagsChip(
                      post: post,
                    )),
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
          } else if (post.error != null) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    child: const Text('Hiba a betöltés közben',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.red))),
                ElevatedButton(
                    onPressed: () =>
                        Provider.of<PostService>(context, listen: false)
                            .getallPostnewversion(),
                    child: const Text('Újra'))
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
