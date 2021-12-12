import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:todo_app/modules/home_page/cubit/cubit.dart';
import 'package:todo_app/modules/home_page/home_page.dart';
import 'package:todo_app/shared/bloc_observer.dart';
import 'package:todo_app/shared/constant.dart';
import 'package:todo_app/shared/localization/app_local.dart';
import 'package:todo_app/shared/network/local/cache_helper.dart';
import 'package:todo_app/shared/styles/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper.init();
  Bloc.observer = MyBlocObserver();

 password = CacheHelper.getData(key: 'password');
  language = CacheHelper.getData(key: 'language');
  theme = CacheHelper.getData(key: 'theme');
  uId = CacheHelper.getData(key: 'uId');
  print('Uid is $uId');
 // theme = 'lightTheme';
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => TodoAppCubit()..createDatabase(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme:
            (theme == 'lightTheme' || theme == null) ? lightTheme : darkTheme,
        supportedLocales: const [
          Locale('en', ''),
          Locale('ar', ''),
        ],
        //   locale: const Locale('ar', ''),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          AppLocale.delegate,
        ],
        localeResolutionCallback: (currentLocale, supportedLocale) {
          if (currentLocale != null) {
            for (Locale locale in supportedLocale) {
              if (currentLocale.languageCode == locale.languageCode) {
                return currentLocale;
              }
            }
          }
          return supportedLocale.first;
          //
        },
        locale: Locale('$language', ''),
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}
