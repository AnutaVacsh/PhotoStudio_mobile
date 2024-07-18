import 'package:flutter/cupertino.dart';

class UserDataProvider extends InheritedWidget {

  final UserData userData;

  const UserDataProvider({required this.userData, required super.child, super.key});

  static UserDataProvider? of(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<UserDataProvider>();
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;
}

class UserData {
  int userId;
  String userName;
  String userStatus;

  UserData(
      {
        required this.userId,
        required this.userName,
        required this.userStatus,
      });

    void changeUserId(int id){
      print("changeId");
      userId = id;
    }

    void changeUserName(String name){
      print("changeUserName");
      userName = name;
    }

    void changeUserStatus(String s){
      print("changeUserStatus");
      userStatus = s;
    }
}