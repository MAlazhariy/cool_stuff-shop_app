import 'package:cool_stuff/modules/login/login_screen.dart';
import 'package:cool_stuff/shared/network/local/cache_helper.dart';
import 'package:flutter/material.dart';

List<Map> newTasks = [];
List<Map> doneTasks = [];
List<Map> archiveTasks = [];


/// shop app
void signOut(BuildContext context){
  CacheHelper.removeToken();
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) {
      return ShopAppLoginScreen();
    }),
        (route) => false,
  );
}


String uId = '';
String token = '';