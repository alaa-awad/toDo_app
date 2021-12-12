import 'package:flutter/material.dart';
import 'package:todo_app/modules/setting/setting.dart';
import 'package:todo_app/shared/adaptive/adaptive_button.dart';
import 'package:todo_app/shared/adaptive/adaptive_text_field.dart';
import 'package:todo_app/shared/component.dart';
import 'package:todo_app/shared/constant.dart';
import 'package:todo_app/shared/network/local/cache_helper.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({Key? key}) : super(key: key);

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Form(
            key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              if (password != null)
                AdaptiveTextField(
                  os: getOs(),
                  isPassword: true,
                  label: getTranslated(
                      context, 'ChangePassword_screen_textFiled_oldPassword'),
                  controller: _oldPasswordController,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).iconTheme.color!, width: 2.0),
                  ),
                  validate: (value) {
                    if (value!.isEmpty) {
                      return getTranslated(
                          context, 'ChangePassword_screen_textFiled_validate');
                    }
                  },
                ),
              const SizedBox(
                height: 20,
              ),
              AdaptiveTextField(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).iconTheme.color!, width: 2.0),
                  ),
                  os: getOs(),
                  isPassword: true,
                  label: password != null
                      ? getTranslated(context,
                          'ChangePassword_screen_textFiled_newPassword')
                      : getTranslated(context,
                          'ChangePassword_screen_textFiled_addPassword'),
                  controller: _newPasswordController,
                validate: (value) {
                  if (value!.isEmpty) {
                    return getTranslated(
                        context, 'ChangePassword_screen_textFiled_validate');
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              AdaptiveTextField(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).iconTheme.color!, width: 2.0),
                  ),
                  os: getOs(),
                  isPassword: true,
                  label: getTranslated(context,
                      'ChangePassword_screen_textFiled_confirmPassword'),
                  controller: _confirmPasswordController,
                validate: (value) {
                  if (value!.isEmpty) {
                    return getTranslated(
                        context, 'ChangePassword_screen_textFiled_validate');
                  }
                },
              ),
              const SizedBox(
                height: 25,
              ),
              AdaptiveButton(
                  background: Theme.of(context).iconTheme.color!,
                  os: getOs(),
                  //ToDo: add function change password
                  function: password == null
                      ? () {
                          if (formKey.currentState!.validate()) {
                            checkPassword(context);
                          }
                        }
                      : () {
                          if (password == _oldPasswordController.text) {
                            if (formKey.currentState!.validate()) {
                              checkPassword(context);
                            }
                          } else {
                            showToast(
                                text: getTranslated(context,
                                    'ChangePassword_screen_button_Error_old_password'),
                                state: ToastStates.ERROR);
                          }
                        },
                  text: password != null
                      ? getTranslated(context,
                          'ChangePassword_screen_button_change_password')
                      : getTranslated(context,
                          'ChangePassword_screen_button_add_password')),
            ],
          ),
        ),
      )),
    );
  }

  checkPassword(BuildContext context) {
    if (_confirmPasswordController.text == _newPasswordController.text) {
      password = _newPasswordController.text;
      CacheHelper.saveData(key: 'password', value: _newPasswordController.text);
      navigateAndFinish(context, SettingScreen());
    } else {
      showToast(
          text: getTranslated(
              context, 'ChangePassword_screen_button_Error_password'),
          state: ToastStates.ERROR);
    }
  }
}
