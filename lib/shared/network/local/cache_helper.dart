import 'package:hive_flutter/hive_flutter.dart';

class CacheHelper {
  static final Box _box = Hive.box('shop_app');

  /// Shop app login data
  static void setToken(String token) {
    _box.put('token', token);
  }

  static String getToken(){
    return _box.get('token', defaultValue: '');
  }

  static void removeToken(){
    _box.delete('token');
  }

  /// Social App login
  static void setSocialUId(String token) {
    _box.put('socialUId', token);
  }

  static String getSocialUId(){
    return _box.get('socialUId', defaultValue: '');
  }

  static void removeSocialUId(){
    _box.delete('socialUId');
  }

  // user model
  static void setUserModel(Map<String, dynamic> map) {
    _box.put('userModel', map);
  }

  static Map<String, dynamic> getUserModel(){
    return _box.get('userModel', defaultValue: {});
  }


}
