import 'package:flutter/material.dart';
import 'package:flutter_blog/data/model/post.dart';
import 'package:flutter_blog/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../../data/repository/post_reposirtory.dart';

// model만들기!
class PostListModel {
  bool isFirst;
  bool isLast;
  int pageNumber;
  int size;
  int totalPage;
  List<Post> posts;

  PostListModel(
      {required this.isFirst, // 목록의 처음이냐?
        required this.isLast, // 목록의 마지막이냐?
        required this.pageNumber,
        required this.size,
        required this.totalPage,
        required this.posts});

  PostListModel copyWith(
      {bool? isFirst,
        bool? isLast,
        int? pageNumber,
        int? size,
        int? totalPage,
        List<Post>? posts}) {
    return PostListModel(
        isFirst: isFirst ?? this.isFirst,
        isLast: isLast ?? this.isLast,
        pageNumber: pageNumber ?? this.pageNumber,
        size: size ?? this.size,
        totalPage: totalPage ?? this.totalPage,
        posts: posts ?? this.posts);
  }

  PostListModel.fromMap(Map<String, dynamic> map)
      : isFirst = map["isFirst"],
        isLast = map["isLast"],
        pageNumber = map["pageNumber"],
        size = map["size"],
        totalPage = map["totalPage"],
        posts = (map["posts"] as List<dynamic>)
            .map((e) => Post.fromMap(e))
            .toList();
}



// provider 데려와!!
final postListProvider = NotifierProvider.autoDispose<PostListVM, PostListModel?>(() {
  return PostListVM();
});


// 클래스 시작!
class PostListVM extends AutoDisposeNotifier<PostListModel?> {
  final refreshCtrl = RefreshController();
  final mContext = navigatorKey.currentContext!;
  PostRepository postRepository = const PostRepository();

  @override
  PostListModel? build() {
    ref.onDispose(
        (){
          Logger().d("");
          refreshCtrl.dispose(); // 가비지컬렉션이 바로 일어나지 않으니까
        }
    );
    init();

/*    ref.listen<PostEvent>(postEventBusProvider, (previous, next) {
      if (next.deletedPostId != null) {
        Logger().d("삭제 수신함 event 발생 ${next.deletedPostId}");
        remove(next.deletedPostId!);
      }
      if (next.updatedPost != null) {
        update(next.updatedPost!);
      }
    });*/

    return null;
  }

  // 1. 페이지 초기화
  Future<void> init() async {
    Map<String, dynamic> responseBody = await postRepository.findAll();

    if (!responseBody["success"]) {
      ScaffoldMessenger.of(mContext!).showSnackBar(
        SnackBar(
            content: Text("게시글 목록보기 실패 : ${responseBody["errorMessage"]}")),
      );
      return;
    }

    state = PostListModel.fromMap(responseBody["response"]);
    refreshCtrl.refreshCompleted();
  }

  // 2. 페이징 로드
  Future<void> nextList() async {
    PostListModel model = state!;

    if (model.isLast) {
      await Future.delayed(Duration(milliseconds: 500));
      refreshCtrl.loadComplete();
      return;
    }

    Map<String, dynamic> responseBody =
    await postRepository.findAll(page: state!.pageNumber + 1);

    if (!responseBody["success"]) {
      ScaffoldMessenger.of(mContext!).showSnackBar(
        SnackBar(content: Text("게시글 로드 실패 : ${responseBody["errorMessage"]}")),
      );
      return;
    }

    PostListModel prevModel = state!;
    PostListModel nextModel = PostListModel.fromMap(responseBody["response"]);

    state = nextModel.copyWith(posts: [...prevModel.posts, ...nextModel.posts]);
    refreshCtrl.loadComplete();
  }

  // 삭제하기
  void remove(int id) {
    PostListModel model = state!;

    model.posts = model.posts.where((p) => p.id != id).toList();

    state = state!.copyWith(posts: model.posts);
  }

  // 글쓰기
  void add(Post post) {
    PostListModel model = state!;

    model.posts = [post, ...model.posts];

    state = state!.copyWith(posts: model.posts);
  }

  // 업데이트
  void update(Post updatedPost) {
    PostListModel model = state!;

    List<Post> updatedPosts = model.posts.map((post) {
      if (post.id == updatedPost.id) {
        return updatedPost; // 수정된 게시글로 교체
      }
      return post; // 나머지는 그대로 유지
    }).toList();

    state = state!.copyWith(posts: updatedPosts); // 리스트 복사로 상태 반영
  }
}