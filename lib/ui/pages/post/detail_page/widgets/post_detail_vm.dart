import 'package:flutter/material.dart';
import 'package:flutter_blog/data/model/post.dart';
import 'package:flutter_blog/data/repository/post_repository.dart';
import 'package:flutter_blog/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostDetailModel {
  Post post;

  PostDetailModel(this.post);
}

final postDetailProvider = NotifierProvider<PostDetailVM, PostDetailModel?>(() {
  return PostDetailVM();
});

class PostDetailVM extends Notifier<PostDetailModel?> {
  final mContext = navigatorKey.currentContext!;
  PostRepository postRepository = const PostRepository();

  @override
  PostDetailModel? build() {
    init();
    return null;
  }

  Future<void> init() async {
    // 4. 위임
    // findById 메서드 생성
    Map<String, dynamic> responseBody =
    await postRepository.findById(1); // 무조건 Map을 받음

    if (!responseBody["success"]) {
      ScaffoldMessenger.of(mContext!).showSnackBar(
        SnackBar(
            content: Text("게시글 상세보기 실패 : ${responseBody["errorMessage"]}")),
      );
      return;
    }
    // Map 던지게 만들기
    PostDetailModel model = PostDetailModel(responseBody["response"]);
    state = model;
  }
}