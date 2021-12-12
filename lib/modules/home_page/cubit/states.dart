abstract class TodoAppStates {}

class InitialState extends TodoAppStates {}

class GetNotesLoadingState extends TodoAppStates {}

class GetNotesSuccessState extends TodoAppStates {}

class GetNotesErrorState extends TodoAppStates {
  final String error;
  GetNotesErrorState(this.error);
}

class AddNoteLoadingState extends TodoAppStates {}

class AddNoteSuccessState extends TodoAppStates {}

class AddNoteErrorState extends TodoAppStates {
  final String error;
  AddNoteErrorState(this.error);
}

class ChangeColorState extends TodoAppStates {}

//all State for SqfLite

//get database from sqfLite
class AppGetDatabaseLoadingState extends TodoAppStates {}

class AppGetDatabaseSuccessState extends TodoAppStates {}

class AppGetDatabaseErrorState extends TodoAppStates {
  final String error;
  AppGetDatabaseErrorState(this.error);
}

//state Create database
class AppCreateDatabaseState extends TodoAppStates {}

//state insert item in database
class AppInsertDatabaseSuccessState extends TodoAppStates {}

class AppInsertDatabaseErrorState extends TodoAppStates {}

//update item in database
class AppUpdateDatabaseState extends TodoAppStates {}

//delete item in database
class AppDeleteDatabaseState extends TodoAppStates {}

class StateChangeCanDelete extends TodoAppStates {}

//State for change language
class ChangeLanguageState extends TodoAppStates {}

//State for change language
class ChangeThemeState extends TodoAppStates {}
