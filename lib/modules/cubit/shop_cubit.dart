import 'dart:developer';
import 'package:cool_stuff/models/categories_model.dart';
import 'package:cool_stuff/models/change_favorites_model.dart';
import 'package:cool_stuff/models/get_favorites_model.dart';
import 'package:cool_stuff/models/home_model.dart';
import 'package:cool_stuff/models/login_model.dart';
import 'package:cool_stuff/modules/categories/categories_screen.dart';
import 'package:cool_stuff/modules/cubit/shop_states.dart';
import 'package:cool_stuff/modules/favorites/favorites_screen.dart';
import 'package:cool_stuff/modules/products/products_screen.dart';
import 'package:cool_stuff/modules/settings/settings_screen.dart';
import 'package:cool_stuff/shared/network/end_points.dart';
import 'package:cool_stuff/shared/network/local/cache_helper.dart';
import 'package:cool_stuff/shared/network/remote/dio_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitState());

  static ShopCubit get(context) {
    return BlocProvider.of(context);
  }

  int currentIndex = 0;
  HomeModel? homeModel;
  CategoriesModel? categoriesModel;
  ChangeFavoritesModel? changeFavoritesModel;
  Map<int, bool> favorites = {};
  GetFavoritesModel? favoritesModel;
  ShopLoginModel? userModel;

  List<Widget> bottomScreens = [
    const ProductsScreen(),
    const CategoriesScreen(),
    const FavoritesScreen(),
    const SettingsScreen(),
  ];

  void changeBottom(int index) {
    currentIndex = index;
    emit(ShopChangeBottomNavState());
  }

  void getHomeData() {
    emit(ShopLoadingHomeDataState());

    DioHelper.getData(
      endPoint: HOME,
    ).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      for (var element in homeModel!.data.products) {
        favorites.addAll({
          element.id: element.inFavorites,
        });
      }

      emit(ShopSuccessHomeDataState());
    }).catchError((error) {
      log('error when getHomeData: ' + error.toString());
      emit(ShopErrorHomeDataState());
    });
  }

  void getCategoriesData() {
    DioHelper.getData(
      endPoint: CATEGORIES,
    ).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);
      emit(ShopSuccessCategoriesState());
    }).catchError((error) {
      log('error when getCategoriesData: ' + error.toString());
      emit(ShopErrorCategoriesState());
    });
  }

  void changeFavorites(int productId) {

    favorites.update(productId, (value) => !value);
    emit(ShopLoadingChangeFavoritesState());

    DioHelper.postData(
      endPoint: FAVORITES,
      data: {
        'product_id': productId,
      },
    ).then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);

      if(changeFavoritesModel!.status == false){
        favorites.update(productId, (value) => !value);
      } else {
        getFavoritesData();
      }
      emit(ShopSuccessChangeFavoritesState(changeFavoritesModel));
    }).catchError((error) {
      log('error when changeFavorites: ' + error.toString());
      favorites.update(productId, (value) => !value);
      emit(ShopErrorChangeFavoritesState());
    });
  }

  void getFavoritesData() {
    emit(ShopLoadingGetFavoritesState());
    log('loading ShopLoadingGetFavoritesState');

    DioHelper.getData(
      endPoint: FAVORITES,
    ).then((value) {
      favoritesModel = GetFavoritesModel.fromJson(value.data);
      emit(ShopSuccessGetFavoritesState());
    }).catchError((error) {
      emit(ShopErrorGetFavoritesState());
    });
  }

  void getUserData() {
    emit(ShopLoadingUserDataState());

    DioHelper.getData(
      endPoint: PROFILE,
      token: CacheHelper.getToken(),
    ).then((value) {
      log('saving data in getUserData..');
      userModel = ShopLoginModel(value.data);
      emit(ShopSuccessUserDataState());
    }).catchError((error) {
      log('error when getUserData: ' + error.toString());
      emit(ShopErrorUserDataState());
    });
  }

  void updateUserData({
  required String name,
  required String email,
  required String phone,
}) {
    emit(ShopLoadingUpdateUserState());

    DioHelper.putData(
      endPoint: UPDATE_PROFILE,
      token: CacheHelper.getToken(),
      data: {
        'name':name,
        'email':email,
        'phone':phone,
      },
    ).then((value) {
      log('saving data in getUpdateUser..');
      userModel = ShopLoginModel(value.data);
      emit(ShopSuccessUpdateUserState());
    }).catchError((error) {
      log('error when getUpdateUser: ' + error.toString());
      emit(ShopErrorUpdateUserState());
    });
  }
}
