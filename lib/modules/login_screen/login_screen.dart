import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/modules/login_screen/cubit/cubit.dart';
import 'package:todo_app/modules/login_screen/cubit/states.dart';
import 'package:todo_app/modules/register_screen/register_screen.dart';
import 'package:todo_app/modules/setting/setting.dart';
import 'package:todo_app/shared/adaptive/adaptive_button.dart';
import 'package:todo_app/shared/adaptive/adaptive_text_field.dart';
import 'package:todo_app/shared/component.dart';
import 'package:todo_app/shared/constant.dart';
import 'package:todo_app/shared/network/local/cache_helper.dart';
import 'package:todo_app/shared/styles/colors.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is LoginErrorState) {
            showToast(
              text: state.error,
              state: ToastStates.ERROR,
            );
          }
          if (state is LoginSuccessState) {
            CacheHelper.saveData(key: 'uId', value: state.uId).then((value) {
              navigateAndFinish(context, SettingScreen());
            });
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //const SizedBox(height: 50,),
                        setSpaceBetween(height: 50),
                        const SizedBox(
                          height: 200,
                          child: Image(
                            image: AssetImage('assets/image/IconApp.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                        Text(
                          getTranslated(context, 'LogIn_title'),
                          style:
                              Theme.of(context).textTheme.headline4!.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Text(
                          getTranslated(context, 'LogIn_body'),
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: Colors.grey,
                                  ),
                        ),
                        setSpaceBetween(height: 30),
                        Container(
                          color: Colors.white,
                          child: AdaptiveTextField(
                            os: getOs(),
                            label: getTranslated(
                                context, 'LogIn_email_textFiled_hint'),
                            controller: emailController,
                            type: TextInputType.emailAddress,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return getTranslated(context,
                                    'LogIn_email_controller_validate_isEmpty');
                              }
                            },
                            prefix: Icons.email,
                            textInputAction: TextInputAction.next,
                            inputBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25))),
                            boxDecoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: defaultColor,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                        setSpaceBetween(height: 15),
                        Container(
                          color: Colors.white,
                          child: AdaptiveTextField(
                            os: getOs(),
                            label: getTranslated(
                                context, 'LogIn_password_textFiled_hint'),
                            controller: passwordController,
                            type: TextInputType.visiblePassword,
                            onSubmit: (value) {
                              if (formKey.currentState!.validate()) {
                                LoginCubit.get(context).userLogin(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                              }
                            },
                            isPassword: LoginCubit.get(context).isPassword,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return getTranslated(context,
                                    'LogIn_password_controller_validate_isEmpty');
                              }
                            },
                            prefix: Icons.lock_outline,
                            textInputAction: TextInputAction.done,
                            suffix: LoginCubit.get(context).suffix,
                            suffixPressed: () {
                              LoginCubit.get(context)
                                  .changePasswordVisibility();
                            },
                            inputBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25))),
                            boxDecoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: defaultColor,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                        setSpaceBetween(height: 30),
                        (state is! LoginLoadingState)
                            ? AdaptiveButton(
                                os: getOs(),
                                background: defaultColor,
                                function: () {
                                  if (formKey.currentState!.validate()) {
                                    LoginCubit.get(context).userLogin(
                                      email: emailController.text,
                                      password: passwordController.text,
                                    );

                                    //Cubit.get(context).getUserData();
                                  }
                                },
                                text:
                                    getTranslated(context, 'LogIn_button_text'),
                                isUpperCase: true,
                                radius: 20,
                              )
                            : const Center(child: CircularProgressIndicator()),
                        setSpaceBetween(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 1,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              getTranslated(context, 'LogIn_text_or'),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    color: Colors.grey,
                                  ),
                            ),
                            Expanded(
                              child: Container(
                                height: 1,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        setSpaceBetween(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                print('facebook');
                              },
                              child: const CircleAvatar(
                                backgroundImage:
                                    AssetImage('assets/image/facebook.png'),
                                radius: 29,
                              ),
                            ),
                            setSpaceBetween(width: 25),
                            InkWell(
                              onTap: () {
                                print('facebook');
                              },
                              child: const CircleAvatar(
                                backgroundImage:
                                    AssetImage('assets/image/gmail.png'),
                                radius: 29,
                              ),
                            ),
                          ],
                        ),
                        setSpaceBetween(height: 23),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              getTranslated(context, 'LogIn_text_register'),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    color: Colors.grey,
                                  ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            TextButton(
                              onPressed: () {
                                navigateTo(context, RegisterScreen());
                              },
                              child: Text(
                                getTranslated(
                                    context, 'LogIn_text_button_register'),
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
                        setSpaceBetween(height: 20),
                      ],
                    ),
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
