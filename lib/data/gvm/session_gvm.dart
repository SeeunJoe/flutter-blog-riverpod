import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog/data/repository/user_reposirtory.dart';
import 'package:flutter_blog/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SessionUser {
  int? id;
  String? username;
  String? accessToken;
  bool? isLogin;

  SessionUser({this.id, this.username, this.accessToken, this.isLogin});
}

class SessionGVM extends Notifier<SessionUser>{

  // TODO 2: context를 가져온다. mContext는 최상단의 context
  final mContext = navigatorKey.currentContext!; // 백그라운드에서 도는 페이지는 페이지가 없을 수도 있기 때문에 그 때에는 currentContext?로 사용한다
  UserRepository userRepository = const UserRepository(); //const 아님 싱글톤으로 만들기

  @override
  SessionUser build() {
    return SessionUser(id: null, username: null, accessToken: null, isLogin: false);
  }

  Future<void> login() async {}
  Future<void> join(String username, String email,String password) async {
    final body = {
      "username":username,
      "email":email,
      "password":password,
    };
    Map<String,dynamic> responseBody = await userRepository.save(body);
    if(!responseBody["success"]){
      ScaffoldMessenger.of(mContext!).showSnackBar(
        SnackBar(content: Text("회원가입 실패 : ${responseBody["errorMessage"]}")),
      );
      return;
    }
    Navigator.pushNamed(mContext, "/login");
  }

  Future<void> logout() async {}
  Future<void> autoLogin() async {
    Future.delayed(
      Duration(seconds: 3),
          () {
        Navigator.popAndPushNamed(mContext, "/login");
      },
    );
  }

}

final sessionProvider = NotifierProvider<SessionGVM, SessionUser>(() {
  return SessionGVM();
});