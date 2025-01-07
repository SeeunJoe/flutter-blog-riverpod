import 'package:flutter/material.dart';
import 'package:flutter_blog/ui/pages/post/detail_page/post_detail_page.dart';
import 'package:flutter_blog/ui/pages/post/list_page/wiegets/post_list_item.dart';
import 'package:flutter_blog/ui/pages/post/list_page/wiegets/post_list_vm.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PostListBody extends ConsumerWidget {
  const PostListBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    PostListModel? model = ref.watch(postListProvider);
    PostListVM vm = ref.read(postListProvider.notifier);

    if (model == null) {
      return Center(child: CircularProgressIndicator());
    } else {
      return SmartRefresher(
        // list_body와 연결된 list_vm에 controller만들어서 가져와
        controller: vm.refreshCtrl,
        enablePullUp: true, // 아래로 당기면 위에
        onRefresh: () async => await vm.init(), // 새로고침 통신을 하는 거 아니면 future안써
        enablePullDown: true,
        onLoading: () async => await vm.nextList(),//페이징 없이는 못만들어
        child: ListView.separated(
          itemCount: model.posts.length,
          itemBuilder: (context, index) {
            return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      // 1. model의 id 넘기기
                      MaterialPageRoute(
                          builder: (_) =>
                              PostDetailPage(model.posts[index].id!)));
                },
                child: PostListItem(post: model.posts[index]));
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
        ),
      );
    }
  }
}