
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../_core/utils/my_http.dart';

class UserRepository{
  const UserRepository();

  Future<Map<String,dynamic>> save(Map<String,dynamic> data)async {
    Response response = await dio.post(
        "/join",
        data:data
    );

/*    if(response.statusCode != 200 ){
      // 비즈니스 로직처리.....는 vm에서 해야하기 때문에 여기서 안해
    }*/

    // final responseBody = response.data;
    // Map<String,dynamic> body = response.data["response"];
    Map<String,dynamic> body = response.data; //response의 header와 body중에 body이다.
    // success와 errormessage모두 포함한 data 모두를 받아와서 vm으로 넘겨야해
    Logger().d(body); //test 코드 작성, 직접해보기
    return body;

  }
}