import 'package:cool_stuff/layout/shop_layout.dart';
import 'package:cool_stuff/modules/cubit/shop_cubit.dart';
import 'package:cool_stuff/modules/login/login_screen.dart';
import 'package:cool_stuff/shared/components/constants.dart';
import 'package:cool_stuff/shared/network/local/cache_helper.dart';
import 'package:cool_stuff/shared/network/remote/dio_helper.dart';
import 'package:cool_stuff/shared/styles/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // API init
  DioHelper.init();
  // local DB init & open
  await Hive.initFlutter();
  await Hive.openBox('shop_app');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    uId = CacheHelper.getSocialUId();

    return MultiBlocProvider(
      providers: [
        // shop app cubit
        BlocProvider(
        create: (context) => ShopCubit()..getHomeData()..getCategoriesData()..getFavoritesData()..getUserData(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.light,
        home:
        uId.isEmpty ? const ShopLayout() : ShopAppLoginScreen(),
      ),
    );
  }
}
