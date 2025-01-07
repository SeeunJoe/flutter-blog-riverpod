import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/utils/my_http.dart';
import 'package:flutter_blog/data/repository/user_reposirtory.dart';
import 'package:flutter_blog/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

class SessionUser {
  int? id;
  String? username;
  String? accessToken;
  bool? isLogin;

  SessionUser({this.id, this.username, this.accessToken, this.isLogin=false});
  // SessionUser.logout(isLogin:false);
}

class SessionGVM extends Notifier<SessionUser>{

  // TODO 2: context를 가져온다. mContext는 최상단의 context
  final mContext = navigatorKey.currentContext!; // 백그라운드에서 도는 페이지는 페이지가 없을 수도 있기 때문에 그 때에는 currentContext?로 사용한다
  UserRepository userRepository = const UserRepository(); //const 아님 싱글톤으로 만들기

  @override
  SessionUser build() {
    return SessionUser(id: null, username: null, accessToken: null, isLogin: false);
  }

  Future<void> login(String username,String password) async {
    final body = {
      "username" : username,
      "password" : password,
    };
    // final response = await userRepository.findByUsernameAndPassword(body);
    // Map<String,dynamic> responseBody = await userRepository.findByUsernameAndPassword(body);
    final (responseBody,accessToken) = await userRepository.findByUsernameAndPassword(body);

    if(!responseBody["success"]){
      ScaffoldMessenger.of(mContext!).showSnackBar(
        SnackBar(content: Text("로그인 실패: ${responseBody["errorMessage"]}")),
      );
      return;
    }

    // 2. 토큰을 Storage에 저장 -> 다시 킬 때 자동로그인하도록 (메모리에 저장 시 매번 재로그인해야한다)  -> 메모리가 한다
    secureStorage.write(key: "accessToken", value: accessToken); // I/O -> 오래 걸려 await걸어줘라

    // 1. SessionUser 갱신 -> 스레드 ( cpu가 한다)
    Map<String,dynamic> data = responseBody["response"];
    state = SessionUser(id:data["id"],username: data["username"],accessToken: accessToken,isLogin: true);

    // 3. Dio 토큰 세팅 -> 스레드 ( cpu가 한다)
    dio.options.headers = {  // dio는 메모리에 저장하는거라 await 안 걸어
      "Authorization" : accessToken  //barer필수
    };
    // Logger().d(dio.options.headers);

    // 4. 페이지 이동
    Navigator.popAndPushNamed(mContext, "/post/list");
  }

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
      return; // return에 값을 안넣으면 종료!
    }
    Navigator.pushNamed(mContext, "/login");
  }

  Future<void> logout() async {
    // 1. 디바이스 토큰 삭제
    await secureStorage.delete(key: "accessToken");

    // 2. 상태 갱신
    state = SessionUser();

    // 3. 화면이동
    Navigator.pushNamedAndRemoveUntil(mContext, "/login",(route) => false);
  }

  // 1. SessionUser가 존재할 수 없다.
  Future<void> autoLogin() async {
    // 1. 토큰 디바이스에서 가져오기
    String? accessToken = await secureStorage.read(key: "accessToken");


    if(accessToken == null){
      Navigator.popAndPushNamed(mContext, "/login");
      return;
    }
    Map<String,dynamic> responseBody = await userRepository.autoLogin(accessToken);
    if(!responseBody["success"]){
      Navigator.popAndPushNamed(mContext, "/login");
      return;
    }
    Map<String,dynamic> data = responseBody["respone"];
    state = SessionUser(id:data["id"],username: data["username"],accessToken: accessToken,isLogin: true);
    dio.options.headers = {"Authorization" : accessToken};
    Navigator.popAndPushNamed(mContext, "/post/list");

  }

}

final sessionProvider = NotifierProvider<SessionGVM, SessionUser>(() {
  return SessionGVM();
});