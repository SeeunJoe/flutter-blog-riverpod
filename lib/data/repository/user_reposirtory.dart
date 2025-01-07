import 'package:dio/dio.dart';
import 'package:flutter_blog/_core/utils/my_http.dart';
import 'package:logger/logger.dart';

class UserRepository {
  const UserRepository();

  Future<Map<String, dynamic>> save(Map<String, dynamic> data) async {
    Response response = await dio.post("/join", data: data);

    Map<String, dynamic> body = response.data;
    Logger().d(body); // test 코드 작성 - 직접해보기
    return body;
  }

  //async* >> stream 데이터 받을 때, 계속 받아준다. || 받을 때는 >> yield;
  Future<(Map<String, dynamic>, String)> findByUsernameAndPassword(
      Map<String, String> data) async {
    Response response = await dio.post("/login", data: data);

    Map<String, dynamic> body = response.data;
    //Logger().d(body); // test 코드 작성 - 직접해보기

    // 토큰꺼내기
    String accessToken = "";

    try {
      accessToken = response.headers["Authorization"]![0] ?? "";
      //Logger().d(accessToken);
    } catch (e) {}

    return (body, accessToken);
  }

  //Map<String, dynamic>
  Future<Map<String, dynamic>> autoLogin(String accessToken) async {
    Response response = await dio.post(
      "/auto/login",
      options: Options(headers: {"Authorization": accessToken}),
    );
    Map<String, dynamic> body = response.data;
    return body;
  }
}