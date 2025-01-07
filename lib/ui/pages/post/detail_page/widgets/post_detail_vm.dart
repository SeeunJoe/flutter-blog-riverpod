// vm(Viwe Model) - model이어도 앱에서는 DB 아님 주의(웹에서는 DB)
// 여기서 적용할 스니펫은 fno

import 'package:flutter/material.dart';
import 'package:flutter_blog/data/model/post.dart';
import 'package:flutter_blog/main.dart';
import 'package:flutter_blog/ui/pages/post/list_page/wiegets/post_list_vm.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../data/repository/post_reposirtory.dart';

class PostDetailModel {
  Post post;

  PostDetailModel({required this.post});

  PostDetailModel copyWith({Post? post}) {
    return PostDetailModel(post: post ?? this.post);
  }

  PostDetailModel.fromMap(Map<String, dynamic> map) : post = Post.fromMap(map);

}

// vm은 창고, provider는 창고 관리자
// autoDispose 화면 파괴 시 창고 같이 소멸함.
final postDetailProvider = NotifierProvider.family.autoDispose<PostDetailVM, PostDetailModel?, int>(() {
  return PostDetailVM();
});

class PostDetailVM extends AutoDisposeFamilyNotifier<PostDetailModel?, int> {

  final mContext = navigatorKey.currentContext!; // null일수도 있어서 ! 붙임 / mContext가 Stack에서 최상단 context
  PostRepository postRepository = const PostRepository(); // const가 있어야 싱글턴으로 관리됨

  @override
  PostDetailModel? build(id) {
    init(id);
    return null;
  }

  // 화면 초기화
  Future<void> init(int id) async {
    // 통신 요청했으니까 Map<String, dynamic> 반환 받음
    Map<String, dynamic> responseBody = await postRepository.findById(id);

    // 이 경우 성공이 아닌 경우를 if의 조건으로 넣으면 else를 굳이 안 써도 돼서 편함
    if (!responseBody["success"]) {
      ScaffoldMessenger.of(mContext!).showSnackBar(
        SnackBar(
            content: Text("게시글 상세 보기 실패 : ${responseBody["errorMessage"]}")),
      );
      return;
    }
    // Map 던지게 만들기 -> 상단 fromMap 메서드 생성
    PostDetailModel model = PostDetailModel.fromMap(responseBody["response"]);
    state = model;
  }



  Future<void> deleteById(int id) async {
    Map<String,dynamic> responseBody = await postRepository.delete(id);

    if(!responseBody["success"]){
      ScaffoldMessenger.of(mContext).showSnackBar(
          SnackBar(
            content: Text('게시물 삭제 실패:${responseBody["errorMessage"]}'),
            duration: Duration(seconds: 3),)
      );
      return;
    }
    // PostListVM의 상태를 변경
    // ref.read(postListProvider.notifier).init(0);

    // 다른 뷰모델
    ref.read(postListProvider.notifier).remove(id);

    // EventBus Notifier -> 삭제했어!



    // 화면 파괴 시 vm이 autoDispose됨.
    Navigator.pop(mContext);
  }
}