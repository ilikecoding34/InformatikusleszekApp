import 'package:blog/models/post_model.dart';
import 'package:blog/screens/singlepost_page.dart';
import 'package:blog/services/post_service.dart';
import 'package:blog/widgets/post_list_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostListContainer extends StatelessWidget {
  PostListContainer({Key? key, required this.post, required this.controller})
      : super(key: key);
  final PostService post;
  final ScrollController controller;

  double startpoint = 0.0;
  double distance = 0.0;

  final snackBar = const SnackBar(
    behavior: SnackBarBehavior.floating,
    content: Text('Frissítés megtörtént'),
  );

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Listener(
            onPointerDown: (PointerDownEvent detail) => {
                  startpoint = detail.position.dy.floorToDouble(),
                  post.refreshing = true,
                },
            onPointerMove: (PointerMoveEvent detail) => {
                  if (controller.position.pixels == 0)
                    {
                      distance = detail.position.dy.floorToDouble(),
                      post.refreshMovement(startpoint, distance),
                      if (post.refresdone)
                        {
                          ScaffoldMessenger.of(context).showSnackBar(snackBar),
                          post.refresdone = false,
                        }
                    }
                  else
                    {
                      post.refreshing = false,
                      post.refreshMovement(startpoint, distance),
                    }
                },
            onPointerUp: (value) => {
                  post.refreshing = false,
                  post.refreshMovement(startpoint, distance),
                },
            child: ListView.separated(
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
                          .collapse = true;
                      Provider.of<PostService>(context, listen: false)
                          .isLoading = true;
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
                })));
  }
}
