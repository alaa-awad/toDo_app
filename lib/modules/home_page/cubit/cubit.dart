import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/note_model.dart';
import 'package:todo_app/modules/home_page/cubit/states.dart';
import 'package:todo_app/shared/component.dart';
import 'package:todo_app/shared/network/local/cache_helper.dart';

class TodoAppCubit extends Cubit<TodoAppStates> {
  TodoAppCubit() : super(InitialState());

  static TodoAppCubit get(context) => BlocProvider.of(context);

  List<NoteModel> notes = [];
  late Database database;

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        // id integer
        // title String
        // text String
        // dateTime String
        // color String

        print('database created');
        database
            .execute(
                'CREATE TABLE notes (uId INTEGER PRIMARY KEY, title TEXT, text TEXT, dateTime TEXT, color TEXT)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('Error When Creating Table ${error.toString()}');
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database);
        print('database opened');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  void getDataFromDatabase(database) {
    notes = [];

    emit(AppGetDatabaseLoadingState());

    database.rawQuery('SELECT * FROM notes').then((value) {
      value.forEach((element) {
        notes.add(NoteModel.fromJson(element));
      });
      emit(AppGetDatabaseSuccessState());
    }).catchError((error) {
      print('get DataBase Error is ${error.toString()}');
      emit(AppGetDatabaseErrorState(error.toString()));
    });
  }

  insertToDatabase({
    required String text,
    required String color,
    String title = '',
    String dateTime = '',
  }) async {
    await database.transaction((txn) async {
      txn
          .rawInsert(
        'INSERT INTO notes(title, text, dateTime, color) VALUES("$title", "$text", "$dateTime", "$color")',
      )
          .then((value) {
        print('$value inserted successfully');
        emit(AppInsertDatabaseSuccessState());

        getDataFromDatabase(database);
      }).catchError((error) {
        print('Error When Inserting New Record ${error.toString()}');
        emit(AppInsertDatabaseErrorState());
      });
    });
  }

  void updateData({
    required int id,
    required String text,
    required String title,
    required String dateTime,
    required String color,
  }) async {
    database.rawUpdate(
      'UPDATE notes SET text = ?,title = ?,dateTime = ?,color = ? WHERE uId = ?',
      [text, title, dateTime, color, id],
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteData({
    required int uId,
  }) async {
    database.rawDelete('DELETE FROM notes WHERE uId = ?', [uId]).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }

//all function to get note from Firebase
  void getNotes({required String userUid}) {
    notes = [];
    emit(GetNotesLoadingState());
    FirebaseFirestore.instance
        .collection('notes')
        .doc(userUid)
        .collection('userNotes')
        .get()
        .then((value) {
      for (var element in value.docs) {
        // notes.add(NoteModel.fromJson(element.data()));
        insertToDatabase(
            text: NoteModel.fromJson(element.data()).text,
            color: NoteModel.fromJson(element.data()).color,
            title: NoteModel.fromJson(element.data()).title as String,
            dateTime: NoteModel.fromJson(element.data()).dateTime as String);

        // print(NoteModel.fromJson(element.data()).text);
      }
      // emit(GetNotesSuccessState());
    }).catchError((error) {
      print('error get Note is $error');
      emit(GetNotesErrorState(error.toString()));
    });
  }

  void uploadNotes(String uId) {
    for (var element in notes) {
      addNote(
          text: element.text,
          title: element.title,
          color: element.color,
          dateTime: element.dateTime,
          uIdUser: uId,
          uIdNote: element.uId);
    }
  }

  void addNote(
      {required String text,
      String? dateTime,
      String? title,
      required String color,
      required int uIdNote,
      required String uIdUser}) {
    emit(AddNoteLoadingState());
    NoteModel model = NoteModel(
        text: text,
        title: title,
        dateTime: dateTime,
        color: color,
        uId: uIdNote);
    FirebaseFirestore.instance
        .collection('notes')
        .doc(uIdUser)
        .collection('userNotes')
        .doc('$uIdNote')
        .set(model.toMap())
        .then((value) {
      emit(AddNoteSuccessState());
    }).catchError((error) {
      print('Error add note is $error');
      emit(AddNoteErrorState(error.toString()));
    });
  }

/*  void updateNote({
    required String text,
    String? dateTime,
    required String color,
  }) {
    emit(AddNoteLoadingState());
    NoteModel model =
        NoteModel(text: text, dateTime: dateTime, color: color, uId: '');
    FirebaseFirestore.instance
        .collection('notes')
        .doc(model.uId)
        .update(model.toMap())
        .then((value) {
      emit(AddNoteSuccessState());
    }).catchError((error) {
      print('Error add note is $error');
      emit(AddNoteErrorState(error.toString()));
    });
  }*/

  void changeLanguage(String value, BuildContext context) {
    CacheHelper.sharedPreferences.setString('language', value);
    navigateAndFinish(context, MyApp());
  }

  void changeTheme(String value, BuildContext context) {
    CacheHelper.sharedPreferences.setString('theme', value);
    navigateAndFinish(context, MyApp());
  }
}
