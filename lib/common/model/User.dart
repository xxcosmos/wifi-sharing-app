import 'package:json_annotation/json_annotation.dart';

class User {
  int id;
  String avatarUrl;
  String nickname;
  DateTime createTime;

  User(this.id, this.avatarUrl, this.nickname, this.createTime);


  //factory User.formJson(Map<String,dynamic> json) =>_$UserFromJson(json);

  //Map<String,dynamic> toJson() => -$UserToJson(this);

  User.empty();
}
