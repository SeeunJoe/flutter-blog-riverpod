import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/utils/my_http.dart';

// post레파지토리 생성
class PostRepository {
  const PostRepository();

  Future<Map<String, dynamic>> findAll({int page = 0}) async {
    Response response =
    await dio.get("/api/post", queryParameters: {"page": page});
    Map<String, dynamic> body = response.data;
    return body;
  }

  Future<Map<String,dynamic>> findById(int id) async {
    Response response = await dio.get("/api/post/$id");
    Map<String,dynamic> body = response.data;
    return body;
  }

  Future<Map<String,dynamic>> delete(int id) async{
    Response response = await dio.delete("/api/post/$id");
    Map<String,dynamic> body = response.data;
    return body;
  }
}