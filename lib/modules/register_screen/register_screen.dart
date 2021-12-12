import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/modules/login_screen/login_screen.dart';
import 'package:todo_app/modules/register_screen/cubit/cubit.dart';
import 'package:todo_app/modules/register_screen/cubit/states.dart';
import 'package:todo_app/modules/setting/setting.dart';
import 'package:todo_app/shared/adaptive/adaptive_button.dart';
import 'package:todo_app/shared/adaptive/adaptive_text_field.dart';
import 'package:todo_app/shared/component.dart';
import 'package:todo_app/shared/constant.dart';
import 'package:todo_app/shared/icon_broken.dart';
import 'package:todo_app/shared/network/local/cache_helper.dart';
import 'package:todo_app/shared/styles/colors.dart';

class RegisterScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();

  var nameController = TextEditingController();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  var confirmPasswordController = TextEditingController();

  RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AddUserCubit(),
      child: BlocConsumer<AddUserCubit, AddUserStates>(
        listener: (context, state) {
          if (state is AddUserCreateUserErrorState) {
            showToast(
              text: state.error,
              state: ToastStates.ERROR,
            );
          }
          if (state is AddUserCreateUserSuccessState) {
              CacheHelper.saveData(key: 'uId', value: state.uId).then((value) {
              navigateAndFinish(context, SettingScreen());
            });
            navigateAndFinish(context, SettingScreen());
          }
        },
        builder: (context, state) {
          AddUserCubit userCubit = AddUserCubit.get(context);
          return Scaffold(
            appBar: AppBar(),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getTranslated(context, 'Add_user_title'),
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                              color: Colors.black,
                            ),
                      ),
                      setSpaceBetween(height: 65),
                      AdaptiveTextField(
                        os: getOs(),
                        label: getTranslated(context, 'Add_user_label_name'),
                        controller: nameController,
                        type: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return getTranslated(
                                context, 'Add_user_validate_name');
                          }
                        },
                        prefix: Icons.person,
                        inputBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        boxDecoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: defaultColor,
                            width: 1,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      AdaptiveTextField(
                        os: getOs(),
                        label: getTranslated(context, 'Add_user_label_email'),
                        controller: emailController,
                        type: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return getTranslated(
                                context, 'Add_user_validate_email');
                          }
                        },
                        prefix: Icons.email,
                        inputBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        boxDecoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: defaultColor,
                            width: 1,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      AdaptiveTextField(
                        os: getOs(),
                        label:
                            getTranslated(context, 'Add_user_label_password'),
                        controller: passwordController,
                        type: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.next,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return getTranslated(
                                context, 'Add_user_validate_password');
                          }
                          if (value.length < 4) {
                            return getTranslated(context,
                                'add_user_password_controller_validate_isWeek');
                          }
                        },
                        prefix: Icons.lock_outline,
                        inputBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        boxDecoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: defaultColor,
                            width: 1,
                          ),
                        ),
                        suffix: userCubit.suffix,
                        suffixPressed: () {
                          userCubit.changePasswordVisibility();
                        },
                        isPassword: userCubit.isPassword,
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      AdaptiveTextField(
                        os: getOs(),
                        label: getTranslated(
                            context, 'Add_user_label_confirmPassword'),
                        controller: confirmPasswordController,
                        type: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return getTranslated(
                                context, 'Add_user_validate_confirmPassword');
                          }
                        },
                        prefix: Icons.lock_outline,
                        inputBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        boxDecoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: defaultColor,
                            width: 1,
                          ),
                        ),
                        suffixPressed: () {
                          userCubit.changePasswordVisibility();
                        },
                        isPassword: userCubit.isPassword,
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      state is! AddUserLoadingState ||
                              state is AddUserCreateUserErrorState
                          ? AdaptiveButton(
                              radius: 20,
                              function: () {
                                if (formKey.currentState!.validate()) {
                                  if (passwordController.text ==
                                      confirmPasswordController.text) {
                                    userCubit.userRegister(
                                      name: nameController.text,
                                      email: emailController.text,
                                      password:
                                          passwordController.text.toString(),
                                      context: context,
                                    );
                                  } else {
                                    showToast(
                                        text: getTranslated(context,
                                            "Add_user_showToast_error"),
                                        state: ToastStates.ERROR);
                                  }
                                  // navigateTo(context,ProductsScreen());
                                }
                              },
                              text: getTranslated(
                                  context, 'Add_user_text_button'),
                              isUpperCase: true,
                              background: defaultColor,
                              os: getOs(),
                            )
                          : const Center(child: CircularProgressIndicator()),
                      setSpaceBetween(height: 23),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            getTranslated(context, 'Add_user_text_register'),
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: Colors.grey,
                                    ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          TextButton(
                            onPressed: () {
                              navigateTo(context, LoginScreen());
                            },
                            child: Text(
                              getTranslated(
                                  context, 'Add_user_text_button_register'),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    color: Colors.blue,
                                  ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

enum addUserType { user, supervisor, admin }
