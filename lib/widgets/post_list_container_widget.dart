import 'package:blog/models/post_model.dart';
import 'package:blog/screens/singlepost_page.dart';
import 'package:blog/services/post_service.dart';
import 'package:blog/widgets/post_list_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostListContainer extends StatefulWidget {
  PostListContainer({Key? key, required this.post}) : super(key: key);
  final PostService post;

  @override
  State<PostListContainer> createState() => _PostListContainerState();
}

class _PostListContainerState extends State<PostListContainer> {
  late ScrollController controller;
  late PostService post;
  bool isTop = true;
  bool isScrolled = false;

  _scrollListener() {
    if (controller.offset <= controller.position.minScrollExtent &&
        !controller.position.outOfRange) {
      isTop = true;
    } else {
      isTop = false;
    }
    if (!(controller.offset <= controller.position.minScrollExtent &&
        !controller.position.outOfRange)) {
      isScrolled = true;
    } else {
      isScrolled = false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    controller = ScrollController();
    controller.addListener(_scrollListener);
    post = widget.post;
    super.initState();
  }

  final snackBar = const SnackBar(
    behavior: SnackBarBehavior.floating,
    content: Text('Frissítés megtörtént'),
  );

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Listener(
            onPointerDown: (PointerDownEvent detail) => {
                  if (!post.getRefreshing && (isTop))
                    {
                      post.begin = detail.position.dy.floorToDouble(),
                      post.setRefreshing = true,
                    },
                },
            onPointerMove: (PointerMoveEvent detail) => {
                  if (post.getRefreshing)
                    {
                      post.end = detail.position.dy.floorToDouble(),
                      post.refreshMovement()
                    },
                  if (post.getRefresdone)
                    {
                      ScaffoldMessenger.of(context).showSnackBar(snackBar),
                      post.setRefresdone = false,
                    },
                },
            onPointerUp: (value) =>
                {post.setRefreshing = false, post.refreshMovement()},
            child: Stack(
              children: [
                ListView.separated(
                    separatorBuilder: (context, index) => const Divider(
                          color: Colors.black,
                        ),
                    padding: const EdgeInsets.all(8),
                    controller: controller,
                    itemCount: post.filteredposts.length,
                    itemBuilder: (BuildContext context, int index) {
                      PostModel postitem = post.filteredposts[index];
                      return PostListItem(
                        postitem: postitem,
                        openitem: () {
                          Provider.of<PostService>(context, listen: false)
                              .setCollapse = true;
                          Provider.of<PostService>(context, listen: false)
                              .setIsloading = true;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SinglePostScreen(title: postitem.title)),
                          );
                          Provider.of<PostService>(context, listen: false)
                              .getPost(id: postitem.id);
                        },
                      );
                    }),
                AnimatedContainer(
                  duration: Duration(milliseconds: isScrolled ? 200 : 0),
                  height: isScrolled ? 50 : 0,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.8),
                        Color(0xffffff),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
            )));
  }
}
