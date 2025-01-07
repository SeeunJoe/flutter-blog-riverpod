import 'package:flutter_blog/data/model/user.dart';
import 'package:intl/intl.dart';

// 웹은 model이 DB지만 앱은 model이 DB가 아니라 화면을 위한 것이어서 데이터가 필요한만큼 필드를 계속 추가해도됨
// (DB면 컬럼값대로만 필드를 고정시킬 수 밖에 없는데, DB가 아니면 고정시키지않아도 되니까)

// null처리 할 수도 있어서 ?붙임
class Post {
  int? id;
  String? title;
  String? content;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? bookmarkCount;
  bool? isBookmark; // 상세보기 화면에서만 필요한거지만 여기다 필드 추가 가능한 이유? : 상세보기 화면에서도 Post 클래스를 활용할거니까
  User? user;

  // Map을 오브젝트로 바꾸는 생성자
  Post.fromMap(Map<String, dynamic> map)
      : this.id = map["id"],
        this.title = map["title"],
        this.content = map["content"],
        this.createdAt = DateFormat("yyyy-mm-dd").parse(map["createdAt"]),
        this.updatedAt = DateFormat("yyyy-mm-dd").parse(map["updatedAt"]),
        this.bookmarkCount = map["bookmarkCount"],
        this.isBookmark = map["isBookmark"],
        user = User.fromMap(map["user"]); // User 클래스의 생성자(fromMap) 들고옴
}