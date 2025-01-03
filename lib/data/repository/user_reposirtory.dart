
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../_core/utils/my_http.dart';

class UserRepository{
  const UserRepository();

  Future<Map<String,dynamic>> save(Map<String,dynamic> data)async {
    Response response = await dio.post("/join", data:data);

/*    if(response.statusCode != 200 ){
      // 비즈니스 로직처리.....는 vm에서 해야하기 때문에 여기서 안해
    }*/

    // final responseBody = response.data;
    // Map<String,dynamic> body = response.data["response"];
    Map<String,dynamic> body = response.data; //response의 header와 body중에 body이다.
    // success와 errormessage모두 포함한 data 모두를 받아와서 vm으로 넘겨야해
    // Logger().d(body); //test 코드 작성, 직접해보기
    return body;

  }
  //record는 () type이라 ()안에 넣어줘야한다.
  Future<(Map<String,dynamic>,String)> findByUsernameAndPassword( Map<String, dynamic> data ) async {
    Response response = await dio.post("/login", data:data);
    Map<String,dynamic> body = response.data; 

    // Logger().d(body);

    String accessToken = "";
    try{
      accessToken = response.headers["Authorization"]![0]; // header말고 body에 accesstoken 넣어주는게 좋다.
      // Logger().d(accessToken);
    }catch(e){
      // token이 없으면 처리해야할 로직은 VM에 적는다.
    }

    return (body,accessToken);
  }

  Future<Map<String, dynamic>> autoLogin(String accessToken) async {

      Response response = await dio.post(
        "/auto/login",
        options: Options(
        headers: {"Authorization": accessToken}
        ),
      );
      Map<String, dynamic> body = response.data;
      return body;
  }
}