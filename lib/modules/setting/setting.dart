import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:todo_app/modules/change_password_screen/change_password_screen.dart';
import 'package:todo_app/modules/home_page/cubit/cubit.dart';
import 'package:todo_app/modules/home_page/cubit/states.dart';
import 'package:todo_app/modules/login_screen/login_screen.dart';
import 'package:todo_app/shared/component.dart';
import 'package:todo_app/shared/constant.dart';
import 'package:todo_app/shared/icon_broken.dart';
import 'package:todo_app/shared/styles/colors.dart';

languageType? languageTypeItem = languageType.defaults;
themeType? themeTypeItem = themeType.light;

class SettingScreen extends StatelessWidget {
  SettingScreen({Key? key}) : super(key: key);

//  String language = 'Default';
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, 'Setting_screen_appBar_title')),
        centerTitle: false,
      ),
      body: BlocConsumer<TodoAppCubit, TodoAppStates>(
        listener: (context, state) {
          if (state is AddNoteLoadingState || state is GetNotesLoadingState) {
            isLoading = true;
          }
          if (state is AddNoteSuccessState || state is GetNotesSuccessState) {
            isLoading = false;
          }
          if (state is AddNoteErrorState) {
            isLoading = false;
            showToast(
                text: getTranslated(context,
                    'Setting_screen_button_showToast_error_uploadNotes'),
                state: ToastStates.ERROR);
          }
          if (state is GetNotesErrorState) {
            isLoading = false;
            showToast(
                text: getTranslated(context,
                    'Setting_screen_button_showToast_error_downloadNotes'),
                state: ToastStates.ERROR);
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                setSpaceBetween(height: 15),
                Text(getTranslated(context, 'Setting_screen_text_general'),
                    style: Theme.of(context).textTheme.headline6),
                MaterialButton(
                  onPressed: () {
                    showLanguageDialog(context);
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.language,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        getTranslated(context, 'Setting_screen_text_language'),
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ],
                  ),
                ),
                setSpaceBetween(height: 12),
                /*    MaterialButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                       Icon(
                        Icons.lock,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        getTranslated(context, 'Setting_screen_text_lock'),
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ],
                  ),
                ),
                setSpaceBetween(height: 12),*/
                MaterialButton(
                  onPressed: () {
                    navigateTo(context, ChangePasswordScreen());
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.password,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        password != null
                            ? getTranslated(context,
                                'Setting_screen_button_change_password')
                            : getTranslated(
                                context, 'Setting_screen_button_add_password'),
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ],
                  ),
                ),
                setSpaceBetween(height: 12),
                MaterialButton(
                  onPressed: () {
                    showThemeDialog(context);
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.style,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        getTranslated(context, 'Setting_screen_text_style'),
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ],
                  ),
                ),
                setSpaceBetween(height: 10),
                myDivider(),
                setSpaceBetween(height: 15),
                Text(
                    getTranslated(
                      context,
                      'Setting_screen_text_storage',
                    ),
                    style: Theme.of(context).textTheme.headline6),
                setSpaceBetween(height: 12),
                MaterialButton(
                  onPressed: () {
                    navigateTo(context, LoginScreen());
                  },
                  child: Row(
                    children: [
                      Icon(
                        IconBroken.User,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        uId == null
                            ? getTranslated(
                                context, 'Setting_screen_button_logIn')
                            : getTranslated(
                                context, 'Setting_screen_button_logOut'),
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ],
                  ),
                ),
                setSpaceBetween(height: 12),
                MaterialButton(
                  onPressed: () {
                    print('start upload');
                    if (uId != null) {
                      TodoAppCubit.get(context).uploadNotes(uId!);
                    } else {
                      showToast(
                          text: getTranslated(context,
                              'Setting_screen_button_showToast_error_upload'),
                          state: ToastStates.ERROR);
                    }
                  },
                  child: Row(
                    children: [
                      Icon(
                        IconBroken.Arrow___Up_Square,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        getTranslated(context, 'Setting_screen_text_setData'),
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ],
                  ),
                ),
                setSpaceBetween(height: 12),
                MaterialButton(
                  onPressed: () {
                    if (uId != null) {
                      TodoAppCubit.get(context).getNotes(userUid: '$uId');
                    } else {
                      showToast(
                          text: getTranslated(context,
                              'Setting_screen_button_showToast_error_upload'),
                          state: ToastStates.ERROR);
                    }
                  },
                  child: Row(
                    children: [
                      Icon(
                        IconBroken.Arrow___Down_Square,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        getTranslated(context, 'Setting_screen_text_getData'),
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      //setSpaceBetween(height: 20),
                     // if (isLoading == true) const LinearProgressIndicator(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  //Language dialog
  dynamic showLanguageDialog(BuildContext context) {
    return AwesomeDialog(
      context: context,
      dialogBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
      dialogType: DialogType.NO_HEADER,
      width: 300,
      animType: AnimType.SCALE,
      buttonsBorderRadius: const BorderRadius.all(Radius.circular(2)),
      body: const DialogContainLanguage(),
    ).show();
  }

  //Theme dialog
  dynamic showThemeDialog(BuildContext context) {
    return AwesomeDialog(
      context: context,
      dialogBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
      dialogType: DialogType.NO_HEADER,
      width: 300,
      animType: AnimType.SCALE,
      buttonsBorderRadius: const BorderRadius.all(Radius.circular(2)),
      body: const DialogContainTheme(),
    ).show();
  }
}

//Language dialog contain and enum
enum languageType { defaults, ar, en }

class DialogContainLanguage extends StatelessWidget {
  const DialogContainLanguage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoAppCubit, TodoAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Text(
                getTranslated(context, 'Setting_screen_button_language_title'),
                style: Theme.of(context).textTheme.subtitle1,
              ),
              setSpaceBetween(height: 10),
              SizedBox(
                width: 80,
                child: myDivider(),
              ),
              RadioListTile<languageType>(
                title: Text(
                  getTranslated(
                      context, 'Setting_screen_button_language_default'),
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                value: languageType.defaults,
                groupValue: languageTypeItem,
                onChanged: (languageType? value) {
                  languageTypeItem = value;
                  language = 'Default';
                  print('value is $value');
                  print(value);
                  TodoAppCubit.get(context).emit(ChangeLanguageState());
                },
                activeColor: Theme.of(context).iconTheme.color,
              ),
              RadioListTile<languageType>(
                title: Text(
                  'العربية',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                value: languageType.ar,
                groupValue: languageTypeItem,
                onChanged: (languageType? value) {
                  languageTypeItem = value;
                  language = 'ar';
                  print('language is $language');
                  TodoAppCubit.get(context).emit(ChangeLanguageState());
                },
                activeColor: Theme.of(context).iconTheme.color,
              ),
              RadioListTile<languageType>(
                title: Text(
                  'English',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                value: languageType.en,
                groupValue: languageTypeItem,
                onChanged: (languageType? value) {
                  languageTypeItem = value;
                  language = 'en';
                  print(value);
                  TodoAppCubit.get(context).emit(ChangeLanguageState());
                },
                activeColor: Theme.of(context).iconTheme.color,
              ),
              myDivider(),
              TextButton(
                onPressed: () {
                  TodoAppCubit.get(context).changeLanguage(language!, context);
                  TodoAppCubit.get(context).emit(ChangeLanguageState());
                },
                child: Text(
                  getTranslated(context, 'Setting_screen_button_language_button'),
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

//Theme dialog contain and enum
enum themeType { light, dark }

class DialogContainTheme extends StatelessWidget {
  const DialogContainTheme({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoAppCubit, TodoAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Column(
          children: [
            Text(getTranslated(context, 'Setting_screen_button_theme_title'),
                style: Theme.of(context).textTheme.subtitle1),
            setSpaceBetween(height: 10),
            SizedBox(
              width: 80,
              child: myDivider(),
            ),
            RadioListTile<themeType>(
              title: Text(getTranslated(
                  context, 'Setting_screen_button_theme_lightTheme')),
              value: themeType.light,
              groupValue: themeTypeItem,
              onChanged: (themeType? value) {
                themeTypeItem = value;
                theme = 'lightTheme';
                TodoAppCubit.get(context).emit(ChangeThemeState());
              },
              activeColor: Theme.of(context).iconTheme.color,
            ),
            RadioListTile<themeType>(
              title: Text(getTranslated(
                  context, 'Setting_screen_button_theme_darkTheme')),
              value: themeType.dark,
              groupValue: themeTypeItem,
              onChanged: (themeType? value) {
                themeTypeItem = value;
                theme = 'darkTheme';
                TodoAppCubit.get(context).emit(ChangeLanguageState());
              },
              activeColor: Theme.of(context).iconTheme.color,
            ),
            myDivider(),
            TextButton(
              onPressed: () {
                TodoAppCubit.get(context).changeTheme('$theme', context);
                TodoAppCubit.get(context).emit(ChangeThemeState());
              },
              child: Text(
                getTranslated(context, 'Setting_screen_button_language_button'),
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ],
        );
      },
    );
  }
}
