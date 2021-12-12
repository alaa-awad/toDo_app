import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/models/user_model.dart';
import 'package:todo_app/modules/register_screen/cubit/states.dart';

class AddUserCubit extends Cubit<AddUserStates> {
  AddUserCubit() : super(AddUserInitialState());

  static AddUserCubit get(context) => BlocProvider.of(context);

  void userRegister({
    required String name,
    required String email,
    required String password,
    required BuildContext context,
  }) {
    emit(AddUserLoadingState());

    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      print('starte userCreate');
      userCreate(
        name: name,
        email: email,
        uId: '${value.user?.uid}',
        context: context,
      );
      print('Register email is ${value.user?.email.toString()}');
      print('Register id is ${value.user?.uid.toString()}');
    }).catchError((error) {
      print('Register user Error is ${error.toString()}');
    });
  }

  void userCreate({
    required String name,
    required String email,
    required String uId,
    required BuildContext context,
  }) {
    UserModel model = UserModel(
      name: name,
      email: email,
      uId: uId,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then((value) {
      emit(AddUserCreateUserSuccessState(uId));
    }).catchError((error) {
      print('Error create user is ${error.toString()}');
      emit(AddUserCreateUserErrorState(error.toString()));
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;

    emit(AddUserChangePasswordVisibilityState());
  }
}
