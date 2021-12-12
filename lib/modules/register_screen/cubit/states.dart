abstract class AddUserStates {}

class AddUserInitialState extends AddUserStates {}

class AddUserLoadingState extends AddUserStates {}

class AddUserSuccessState extends AddUserStates {}

/*class AddUserErrorState extends AddUserStates
{
  final String error;

  AddUserErrorState(this.error);
}*/

class AddUserCreateUserSuccessState extends AddUserStates {
  final String uId;

  AddUserCreateUserSuccessState(this.uId);
}

class AddUserCreateUserErrorState extends AddUserStates {
  final String error;

  AddUserCreateUserErrorState(this.error);
}

class AddUserChangePasswordVisibilityState extends AddUserStates {}

class AddUserChangeRadioButton extends AddUserStates {}

class AddUserProfileImagePickedSuccessState extends AddUserStates {}

class AddUserProfileImagePickedErrorState extends AddUserStates {}

class UpdateUserLoadingState extends AddUserStates {}

class UpdateUserSuccessState extends AddUserStates {}

class UpdateUserErrorState extends AddUserStates {
  final String error;

  UpdateUserErrorState(this.error);
}
