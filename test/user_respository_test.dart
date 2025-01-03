import 'package:flutter_blog/data/repository/user_reposirtory.dart';

void main() async {
  UserRepository userRepository = const UserRepository();
  await userRepository.findByUsernameAndPassword(
    {"username":"d","password":"1234"}
  );
}